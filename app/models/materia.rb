require 'chronic'

class Materia < ActiveRecord::Base

  belongs_to :materia_status
  belongs_to :order, autosave: true
  belongs_to :tutor
  belongs_to :student

  #new model
  has_many :materia_instances, :dependent => :delete_all
  accepts_nested_attributes_for :materia_instances, reject_if: :all_blank, :allow_destroy => true

  validates :name , presence: true
  validates :topic, presence: true
  #validates :students_number, presence: true

  scope :no_publicada, -> {where materia_status_id:1}
  scope :oferta      , -> {where materia_status_id:2}
  scope :publicables , -> {where materia_status_id:2}

  before_save :before_save_callbacks
  
  #after_initialize :after_initialize_callbacks

  before_create :set_materia_defaults
  
  after_create  :check_weekly, :check_student_id



  SUBJECTS=['Matemáticas', 'Física', 'Química','Biología', 'Sociales', 'Ingles','Español', 'Francés', 'Economia', 'Tareas','Excel','Contabilidad', 'Finanzas', 'Estadística', 'Filosofía','Matematicas(SAT)', 'Ingles(SAT)'].sort
              
  SUBJECTS_CURSO=['TOEFL','IELTS','Matematicas(SAT)', 'Ingles(SAT)'].sort

  SUBJECTS_UNIV = ['Matematicas', 'Fisica', 'Quimica','Biologia', 'Sociales', 'Ingles','Español', 'Frances', 'Economia','Excel','Contabilidad', 'Finanzas', 'Estadística', 'Filosofía', 'Tareas'].sort

  SUBJECTS_ICFES = ['Matematicas', 'Fisica', 'Quimica','Biologia', 'Sociales', 'Español'].sort



  SUBJECTS_SHORT= {'Matemáticas'=>'MAT', 'Física'=>'FIS', 'Química'=>'QUI','Biología'=>'BIO', 'Sociales'=>'SOC', 'Ingles'=>'ING',
            'Español'=>'ESP', 'Francés'=>'FRA', 'Economia'=>'ECO', 'Tareas'=>'TAREAS','TOEFL'=>'TOEFL','IELTS'=>'IELTS',
            'Matemáticas(SAT)'=>'MAT-SAT', 'Ingles(SAT)'=>'ING-SAT','Excel'=>'EXCEL','Contabilidad'=>'CONTABILIDAD', 'Finanzas'=>'FINANZAS', 'Estadística'=>'ESTADISTICA', 'Filosofía'=> 'FILO',
            'Matematicas'=>'MAT', 'Fisica'=>'FIS', 'Quimica'=>'QUI','Biologia'=>'BIO','Frances'=>'FRA','Matematicas(SAT)'=>'MAT-SAT', 'Estadistica'=>'ESTADISTICA', 'Filosofia'=> 'FILO'
                  }

#new stuff - Functions

  def save_order
    self.order.students_number = self.students_number
    self.order.save!
  end

  def reservada?
    if self.materia_instances.any? {|i| i.materia_instance_status_id == 1}
      false
    else
      true
    end
  end 

  def before_save_callbacks 
    self.check_status
    self.check_topics
    self.save_totals
    self.check_hours
    self.save_order
  end
  
  def after_initialize_callbacks
    
    self.check_status
    #self.save_totals
  
  end

  def check_hours
    if self.total_hours.nil? 
      self.total_hours = self.calculate_total_hours
      #self.save!
    end 
    
  end

  def check_materia_instance_status
    if self.order.status == 5
      list = self.materia_instances.select {instance.materia_instance_status_id == 2 }

      list.each do |i|
        i.update_attribute :materia_instance_status_id,3
      end
    end 
  end

  def check_topics 
    if self.topic.empty?
      self.topic = "Pendiente"
    end
  end 

  def check_student_id
    if self.student_id.nil?
      self.update_attribute :student_id, self.order.student_id
    end
  end 

  def force_order_save
    self.order.save
  end

  def calculate_duration
    if self.materia_instances.count!=0
      durations = []
      self.materia_instances.each {|inst| durations.append inst.duration}
      stats = DescriptiveStatistics::Stats.new(durations)
      self.duration = stats.mode
    end
  end

  def  check_status
    paid = self.order.is_paid?
    if self.reservada?
      self.materia_status_id = paid ? 3 : 5
    else
      self.materia_status_id =  2
    end
  end
=begin
    if self.materia_instances.count!=0
      case self.materia_status_id
      when 2
        if self.materia_instances.all? {|instance| instance.materia_instance_status_id==2}
          self.materia_status_id = 3
          self.save!
        end
      when 3  
        if self.materia_instances.any? {|instance| instance.materia_instance_status_id==1}
          self.materia_status_id = 2
          self.save!
        elsif self.order.status == 5
          self.materia_status_id = 5
          self.save!
        end
      when 5
        if self.materia_instances.any? {|instance| instance.materia_instance_status_id==1}
          self.materia_status_id = 2
          self.save!
        end 
      end 
    else
      self.materia_status_id = 1
    end
=end

  def  resume_materia
    return "(#{self.order.serial}) #{self.shortname}: #{self.place} #{self.schedule_hash_to_string}"
  end

  def  resume_instance
    return "(#{self.order.serial}) #{self.shortname}: #{self.place} "
  end

  def  resume_parent
    return "(#{self.student.shortname}) #{self.shortname}"
  end

  def shortname
    short = SUBJECTS_SHORT[self.name]
    return short
  end

  def schedule_hash_to_string
    word=""
    self.schedule_hash.each do |key,value|
      day = value.map {|wday| I18n.t('date.abbr_day_names')[wday]}
      word += " "+ day.join(" ") + " " + I18n.l(key, format:'%I:%M %p')
    end
    return word
  end

  def schedule_hash

    schedule = {}
    self.materia_instances.each do |i|
      if !schedule.has_key? i.at_time
        schedule[i.at_time] = [i.at_date.wday]
      else
        if !(i.at_date.wday) == schedule[i.at_time]
          schedule[i.at_time].append i.at_date.wday
        end
      end
    end
    #word=""
    #schedule.each {|key,value| word += " "+value.to_s + " " + I18n.l(key, format:'%I:%M %p')}
    return schedule
  end

  def place
    where = (self.order.student.parent.address).to_s
    return where
  end

  def first_instance
    first = Date.today + 2.months
    unless self.materia_instances.empty?
      self.materia_instances.each do |instance|
        if instance.at_date < first
          first = instance.at_date
        end
      end
    end
    return first
  end

  def last_instance
    unless self.materia_instances.empty?
      last = self.materia_instances.last.at_date    
      self.materia_instances.each do |instance|
        if instance.at_date > last
          last = instance.at_date
        end
      end
      return last
    end
    
  end

  def postulation_updates(id)
      if self.materia_status_id == 2 || self.materia_status_id == 4
        instances = self.materia_instances.select {|instance| instance.materia_instance_status_id==1}
        instances.each do |instance|
          instance.update_attributes({tutor_id: id})
        end
        self.check_status
        self.save!
        ParentMailer.parent_reserved_notification(self.order).deliver
        return true
      else
        return false
      end
  end

  def save_totals
    self.total_hours = self.calculate_total_hours
    #self.sale_price  = self.calculate_sale_price
  end

  def check_weekly
    date = self.until_re_date
    if self.weekly && !date.nil?
      self.materia_instances.each do |instance|
        instance.duplicate(date)
      end
    end
    #self.student.update_attribute :fixed, true
    #self.update_attribute :horario_id, self.student.horario.id
  end

  def calculate_total_hours#en uso 2018
    total = 0
    self.materia_instances.each { |instance| total+= instance.duration } 
    return total.nil? ? 0 : total
  end

  def calculate_sale_price#en uso en 2018 
    hourly = self.order.hourly_price
    return self.calculate_total_hours*hourly
  end

  def has_payables?
    if self.materia_status_id == 3 && self.order.status > 3
      self.materia_instances.any? {|inst| inst.payable?}
    else
      false
    end
  end

  def email_tutors
    tutors = Tutor.select {|tut| self.materia_instances.any? {|inst| inst.tutor_id==tut.id}}
    return tutors
  end

  def tutor_cost
    total = 0
    self.materia_instances.each {|inst| total+=inst.tutor_payable}
    return total
  end

#old stuff

  def wdays_to_string
    text = ''
    self.wdays.select {|day| !day.empty?}.each {|day| text+=day+" "}
    return text
  end

  def update_postulate(tutor_id)
    self.update_attributes({:tutor_id => tutor_id})
    self.order.tutoria_instances.each {|t| t.update_attributes({:status=>'reserved',:tutor_id => tutor_id})}
  end

  def has_tags?
    return self.tags.empty? ? false : true
  end

  def tags
    tags = ""
    if self.weekly
      tags+="#Fija Semanal  "
    end
    if !self.order.tarifa.nil?
      tags+="#"+self.order.tarifa
    end
    return tags
  end

#Tutors Account

  private

  def set_materia_defaults
    #if self.order.admin_user_id.nil?
     # self.materia_status_id = 1
    #else
    #self.student_id = Order.find(params[:order_id]).student_id
    self.materia_status_id = 2
    self.sale_price = 0
    #end
    if self.weekly && !self.active
      self.active = true
    end
  end

end
