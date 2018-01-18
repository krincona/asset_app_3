class Student < ActiveRecord::Base
  belongs_to :parent
  belongs_to :admin_user
  belongs_to :institute
  has_one :horario, :dependent => :destroy
  has_one :extra_horario, :dependent => :destroy
  has_many :orders, :dependent => :delete_all
  has_many :tutoria_instances, :dependent => :delete_all
  has_many :materias

  has_many :comments, as: :commentable

  default_scope { order('name ASC') }


  validates :name,    presence: true, uniqueness: true
  #validates :email,   presence: true, uniqueness: true
  #validates :school,  presence: true
  #validates :grade,   presence: true
  #validates :calendar_schema,   presence: true


  before_save :upcase_name
  #after_create :defaults

  def self.is_univ(id)
    student = Student.find(id)
    if student.univ
      return true 
    else
      return false
    end
  end

  def shortname
    return self.name.split(' ', 2)[0]
  end
  def upcase_name
    self.name = self.name.upcase
  end

  def subjects_all
    all = []
    self.horario.materias.each do |materia|
      all.append(materia.name)
    end
    return all
  end

  def is_fixed?
    if self.fixed
      'Si'
    else
      'No'
    end
  end

  def active_materias
    active = self.materias.select {|mat| mat.active == true && mat.weekly == true}
    return active
  end


  def defaults
    self.update_attribute :address,self.main_parent.address
    today = Date.today
    Horario.create!(student_id:self.id,from:Date.today,
    to:Date.civil(today.year,today.month,-1))
    ExtraHorario.create!(student_id:self.id)
  end

  def update_dates(inputs)
    self.horario.update_attributes({:from=>inputs[:inicia],:to=>inputs[:termina]})
  end

  def generate_order(admin_id,inputs)


    new_init_cost = inputs[:nueva]
    tipo = inputs[:tipo]
    students_number = inputs[:estudiantes]
    curso = inputs[:curso]

    if tipo == 'Fija'
      if self.horario.materias.empty?
        return -1
      #elsif self.orders.any? {|order| order.active == true}
      #  return 0
      else
        new_order = Order.create(student_id: self.id, renovate: true,
        admin_user_id: admin_id, init_cost: new_init_cost, curso: curso )
        new_order.save!
        self.materias.each {|materia| materia.update_attribute :order_id,new_order.id}
        self.horario.materias.each do |materia|
          materia.wdays[1..-1].each do |day|
            week_day_n = I18n.t(:"date.day_names").index(day)
            week_day = Date::DAYNAMES[week_day_n]
            now = self.horario.from
            if now.wday == week_day_n
              date_instance = now
            else
              date_instance = Chronic.parse("next #{week_day}",:now=>now).to_date
            end
            if materia.tutor_id.nil?
              instance_status = 'avaible'
            else
              instance_status = 'reserved'


              #new_order.update_attribute :status, 'Pendiente de Pago'

            end
            while date_instance <= self.horario.to
              new_instance = TutoriaInstance.create(at_date:date_instance,
              at_time:materia.at_time,student_id:self.id,order_id:new_order.id,
              duration:materia.duration,status:instance_status,subject:materia.name,
              serial:new_order.serial, recurrence:materia.ocurrence,
              tutor_id:materia.tutor_id,topic:materia.topic, student_number:students_number)
              new_instance.save
              date_instance+= 1.week
            end
            new_order.calc_payment_dateline
          end
        end
        #return 1
      end
    else
      if self.extra_horario.tutoria_instances.empty?
        return -1
      else
        new_order = Order.create!(student_id: self.id, renovate: false,
        admin_user_id: admin_id, init_cost: new_init_cost, curso: curso)
        new_order.save!
        self.extra_horario.tutoria_instances.each do |tutoria|
          tutoria.update_attributes ({:order_id=>new_order.id,:student_number=>students_number})
        end

        # Remove tutoria_instances from extra_horario
        self.extra_horario.tutoria_instances.each {|tutoria| tutoria.update_attribute :extra_horario_id, 1}
      end
      new_order.calc_payment_dateline
    end
=begin
    if new_order.tutoria_instances.all? {|tutoria| tutoria.status == "reserved"}
        TutoriaMailer.parent_reserved_notification(new_order).deliver
    end
=end
    return 1
  end

  def update_materia(name,tutor)
    if !self.materias.empty?
      self.materias.select {|m| m.name == name}.each do |materia|
        materia.update_attribute :tutor_id,tutor
      end
    end
  end



end
