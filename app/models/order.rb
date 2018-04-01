require 'chronic'

class Order < ActiveRecord::Base
  include ModelHelper
  include ActiveModel::Dirty

  belongs_to :student
  belongs_to :admin_user
  belongs_to :order_status

  has_many :materias, :dependent => :delete_all
  accepts_nested_attributes_for :materias, reject_if: :all_blank, :allow_destroy => true

  has_many :materia_instances, :dependent => :delete_all
  accepts_nested_attributes_for :materia_instances, reject_if: :all_blank, :allow_destroy => true

  
  MONTHS = {'Enero' => 1,'Febrero' => 2,'Marzo' => 3,'Abril' => 4,'Mayo' => 5,
    'Junio' => 6,'Julio' => 7,'Agosto' => 8,'Septiembre' =>9,'Octubre' => 10,
    'Noviembre' => 11,'Diciembre' => 12}

  CONSTANTS ={:serial_init=> 3740} # no en uso

  STATUS = {1=>"En Proceso",2=>"En Oferta",3=> "Pendiente de Pago",4=>"Pendiente de Tutor", 5=>"Confirmada", 6=>"Caduca"}

  TARIFA_PRICE={"Colegio"=>{1=>44000,2=>74000,3=>99000},"Curso"=>{1=>56000,2=>90000,3=>121000},"ICFES"=>{1=>43000,2=>73000,3=>98000},"Univ"=>{1=>56000,2=>90000,3=>121000}}

  TARIFA_PAY={"Anterior"=>{1=>18000,2=>23000,3=>25000},"Colegio"=>{1=>20000,2=>25000,3=>30000},"Curso"=>{1=>25000,2=>30000,3=>35000},"ICFES"=>{1=>20000,2=>25000,3=>30000},"Univ"=>{1=>25000,2=>30000,3=>35000}}

  #Callbacks
  before_create :set_order_status
  
  after_create  :calc_serial, :update_student_active_materias, :update_materias_student
    
  before_save :before_save_callbacks

  before_save :check_status
  
  after_initialize :after_initialize_callbacks
    
  #Functions

  def is_open?
    !self.cerrado
  end

  def before_save_callbacks
    if self.is_open?
      self.check_status 
      self.calculate_price_amounts 
      self.calculate_datelines
    end 
  end

  def after_initialize_callbacks
    if self.is_open?
      self.check_status 
      self.calculate_price_amounts
      self.calculate_datelines
    end
  end

  def self.check_tarifa(student_id)
    student = Student.find(student_id)
      case student.calendar_schema
      when "S"
        return "Univ"
      when "A"
        return "Colegio"
      when "B"
        return "Colegio"
      end
  end 

  def check_instances_parms
    self.materias.each do |m|
      m.materia_instances.each {|i| i.update_attribute :parent_id,self.student.parent.id}
    end
      
  end  

  def calc_serial
    self.serial = self.id + CONSTANTS[:serial_init]
    self.save
  end

  def change_redate
    if self.renovate && !self.for_month.nil?
      self.re_date = Date.civil(2015,MONTHS[self.for_month],25).to_datetime
    end
  end

  def confirm(inputs)
  
    self.update_attributes({:payment_ref=>inputs[:detalle], :payment_date => inputs[:fecha] })
    
    ParentMailer.parent_confirmation_notification(self).deliver
    
    #Tutor notification
    self.materias.each do |materia|


        tutors = materia.email_tutors
        tutors.each {|tutor| TutorMailer.tutor_confirmation_notification(materia,tutor).deliver}

    end
  end

  def resend_emails
    if self.status == 3
      ParentMailer.parent_reserved_notification(self).deliver
    elsif self.status == 5
      ParentMailer.parent_confirmation_notification(self).deliver
      self.materias.each do |materia|
        tutors = materia.email_tutors
        tutors.each {|tutor| TutorMailer.tutor_confirmation_notification(materia,tutor.id).deliver}
      end
    end  
  end

  #new_methods


  def subjects
    case self.tarifa
    when "Colegio"
      Materia::SUBJECTS
    when "Curso"
      Materia::SUBJECTS_CURSO
    when "ICFES"
      Materia::SUBJECTS_ICFES
    when "Univ"
      Materia::SUBJECTS_UNIV
    else
      Materia::SUBJECTS
    end
      
  end 

  def status_name

    return STATUS[self.status]

  end

  def calculate_subtotal_tutoria
    #self.materias.each {|mat| total+= mat.tutor_cost}
    total = self.calculate_total_sale_hours*self.calculate_hourly_payable
    return total
  end

  def materia_instances
    ids = []
    self.materias.each {|mat| ids.append(mat.id)}
    instances = MateriaInstance.select {|inst| ids.include?(inst.materia_id)}
    return instances
  end


  def publish_materias
    self.materias.each  do |m|
      m.update_attribute :materia_status_id,2
      m.reload
      #m.check_weekly
    end
    self.update_attribute :order_status_id,2
    self.reload
  end

  def is_paid?
     if !self.new_record?
      if self.payment_ref.empty? || self.payment_ref.nil? || self.payment_ref=="-"
        false
      else
        true
      end
    end
  end

  def check_status
    if self.is_open? && self.status!=6 && !self.materias.empty? 

      paid = self.is_paid?
      
      materias = self.materias  
      materias_reservadas = self.materias.select {|mat| mat.reservada? }
      materias_no_reservadas = self.materias - materias_reservadas

      if !materias_no_reservadas.empty? 
        #materias_no_reservadas.each {|mat| mat.update_attribute :materia_status_id,2}
        #materias_reservadas.each    {|mat| mat.update_attribute :materia_status_id, paid ? 4 : 2 }
        new_order_status = paid ? 4 : 2
      else  
        new_order_status = paid ? 5 : 3
        #materias_reservadas.each {|mat| mat.update_attribute :materia_status_id, paid ? 5 : 3 }
      end

      self.status = new_order_status
    end
  end
=begin # old status checking code
      materias_status = self.check_materias_status
      if self.payment_ref == "-" # No esta paga
        case materias_status
        when 1 # No publicada
          self.status = 1 # En proceso de creacion
        when 2 # 1 o mas materias Publicadas (Orden No Paga)
          self.status = 2 # En oferta
        when 3 # Todas con tutor
          self.status = 3 # Pendiente de pago
        end  
      else # Esta paga
        if self.status == 5 && materias_status == 2 # 1 o mas materias Publicadas (Orden Paga)
          self.status = 4 # Pendiente de Tutor
        elsif self.status == 4 # Esta pendiente de tutor
          case materias_status
          when 2 # 1 o mas materias Publicadas (Orden Paga)
            self.status = 4 # Pendiente de Tutor
          when 3 || 5 # Todas con tutor
            self.status = 5
          end
        else
          self.status = 5         
        end 
      end
=end

  def calculate_datelines
    if self.materias.count > 0 
      self.payment_dateline = calculate_payment_deadline
      self.re_dateline      = calculate_re_deadline
    end
  end

  def calculate_payment_deadline

    deadline = self.materias.first.first_instance
    unless self.materias.empty?
      self.materias.each do |materia|
        if materia.first_instance < deadline
          deadline = materia.first_instance
        end
      end
    end
    
    return deadline - 1.day
  end

  def calculate_re_deadline
    unless order_status == 6
      deadline = self.materias.last.last_instance
      unless self.materias.empty?
        self.materias.each do |materia|
          if materia.last_instance > deadline
            deadline = materia.last_instance
          end
        end
      end
      return deadline + 10.day
    end
    

  end

  def calculate_price_amounts#en uso 2018
    if !self.materias.empty?
      self.hours               = self.calculate_total_sale_hours#check
      self.subtotal_sale_price = self.calculate_subtotal_sale_price#check
      self.subsidy             = self.calculate_subsidy_amount#check
      self.discount            = self.calculate_discount_sale_price#check
      self.sale_price          = self.subtotal_sale_price + self.subsidy - self.discount#
      self.hourly_price        = self.calculate_hourly_price#check
      self.hourly_payable        = self.calculate_hourly_payable#check
      self.subtotal_tutoria    = self.calculate_subtotal_tutoria + self.subsidy #check
      self.subtotal_admin      = (self.subtotal_sale_price - self.discount - self.subtotal_tutoria)/1.19
      self.tax                 = self.subtotal_admin*0.19
    end
  end

  def calculate_total_sale_hours#en uso 2018
    total = 0
    if !self.materias.empty?
      self.materias.each {|materia| total+= materia.calculate_total_hours}
    end
    return total
  end

  def calculate_subsidy_amount#en uso 2018
    sessions = 0
    subsidy = self.student.parent.subsidy_amount
    self.materias.each {|mat| sessions+= mat.materia_instances.count}
    total = sessions*subsidy
    return total
  end
  
  def calculate_discount_sale_price#en uso 2018

    if self.tarifa == "Colegio"
      case self.calculate_total_sale_hours
      when 0...16
        return 0
      when 16...24
        return 4000 * self.calculate_total_sale_hours
      when 24...1000
        return 6000 * self.calculate_total_sale_hours
      else
        return nil
      end

    else 
      return 0
    end 

    
  end

  def calculate_subtotal_sale_price#en uso 2018
    total = self.calculate_total_sale_hours*self.calculate_hourly_price
    return total 
  end

  def calculate_sale_price
    total = 0
    total = self.calculate_subtotal_sale_price + self.calculate_subsidy_amount - self.calculate_discount_sale_price
    return total
  end

  def calculate_hourly_price#en uso 2018
    return TARIFA_PRICE[self.tarifa][self.students_number]
  end


  def calculate_hourly_payable# NUEVO - en uso 2018
    return TARIFA_PAY[self.tarifa][self.students_number]
  end

  def update_materias_student
    self.materias.each do |mate|
      mate.update_attribute :student_id,self.student_id
    end
  end

  def update_student_active_materias
    if self.materias.any? {|mate| mate.weekly}
      self.student.materias.select {|mate| mate.weekly && mate.order_id != self.id}.each do |mate|
        mate.update_attribute :active,false
      end
    end
  end


  def self.preload_order(student, admin_id)
    #student = Student.find(student_id)
    order = Order.create(student_id: student.id, admin_user_id: admin_id,re_date: Date.today.end_of_month + 1.month)
    #order.save!
    #move to student model
    student.active_materias.each do |mate|
      #move to materia model
      new_mate = mate.dup

      new_mate.order_id = order.id
      new_mate.student_id = student.id
      new_mate.weekly = true
      new_mate.active = true
      new_mate.save!
      tutor = mate.materia_instances.first.tutor

      if tutor.nil?
        tutorr_id = nil
      else
        tutorr_id = tutor.id
      end

      mate.schedule_hash.each do |time,wdays|
        wdays.each do |wday|
          day = Chronic.parse(Date::DAYNAMES[wday],:now=> Date.today.end_of_month)
          instance = MateriaInstance.create(duration: mate.duration, at_date: day,
          at_time: time, materia_id: new_mate.id, tutor_id: tutorr_id)
          instance.duplicate
        end
      end

      mate.update_attribute :active, false

    end

    return order
  end

  private

  def set_order_status
    self.status = 1
    self.payment_ref = "-"
    self.students_number = 1
    if self.admin_user_id.nil?
      self.admin_user_id = 100
      #self.status = 1
      self.created_by = "Acudiente"

    else
      #self.status = 2
      self.created_by = "Coordinador"
    end

  end

end
