class TutoriaInstance < ActiveRecord::Base

  default_scope { order('at_date ASC') }

  #acts_as_schedulable :schedule
    
  belongs_to :tutor
  belongs_to :student 
  belongs_to :order
  belongs_to :tutoria
  belongs_to :extra_horario


  SUBJECTS=['Matematicas', 'Fisica', 'Quimica','Biologia', 'Sociales', 'Ingles',
            'Español', 'Frances', 'Economia', 'Tareas','TOEFL','IELTS',
            'Matematicas(SAT)', 'Ingles(SAT)','Excel','Contabilidad', 'Finanzas', 'Estadística'].sort

  RECURRENCE=['Fija','Esporadica']

  #validates :at_date, presence: true, allow_blank: false
  #validates :at_time, presence: true, allow_blank: false
  validates :topic, presence: true, allow_blank: false


  extend SimpleCalendar
  #has_calendar :attribute => :at_date

  before_save :change_status, :update_student
  after_save :update_order, :update_tutorias

  def student_name
    if !self.student.nil?
        self.student.name
    else
      "--Dato Vacio--"
    end
  end

  def tutor_name
    if !self.tutor.nil?
        self.tutor.name
    else
      "--Dato Vacio--"
    end
  end
  
  def update_order
    if !self.order.nil?
      self.order.calc_payment_dateline
    end
  end

  def payable?
    if self.materia_instance_status_id != 5
      self.at_date.month == (Date.today - 1.month).month
    else
      false
    end
  end

  def update_tutorias
    if !self.order.nil?
      if self.tutor_id.nil?
        status='avaible'
      else
        status='reserved'
      end
      text=""
      resume  = self.order.tutoria_by_subject[self.subject]
      resume[:schedule].each {|k,v|
      text+=I18n.t(:"date.day_names")[k]+" "+I18n.l(v,format:"%I:%M %p")+" "}
      if self.tutoria_id.nil?
        tutorias = self.order.tutorias.select {|t| t.subject == self.subject}
        if tutorias.empty?
          new_tutoria=Tutoria.create!(order_id:self.order_id,subject:self.subject,
          duration:resume[:duration],students_number:resume[:student_number],
          sessions:resume[:sessions], hours:resume[:hours],status:status,
          topic:self.topic,schedule: text, first: resume[:first],
          tutor_id:self.tutor_id)
          new_tutoria.save
          tutoria_id = new_tutoria.id
        else
          tutoria_id = tutorias[0].id
        end
        self.update_attribute :tutoria_id,tutoria_id
      else
        Tutoria.find(self.tutoria_id).update_attributes({duration:resume[:duration],
        students_number:resume[:student_number],sessions:resume[:sessions],
        hours:resume[:hours],topic:resume[:topic],schedule: text,status:status,
        first: resume[:first],tutor_id:self.tutor_id})
      end
    end
  end

  def change_status
    if self.status != 'confirmed' and self.status != 'paid'
      if !self.tutor_id.nil?
        self.status = 'reserved'
      else
        self.status = 'avaible'
      end
    end
  end

  def update_student
    if !self.order.nil? and !self.order.student.nil?
      self.student_id = self.order.student.id
    else
      self.student_id = self.extra_horario.id
    end
  end


  def create_tutoria_offer
    resume = Order.find(self.order_id).tutoria_by_subject[self.subject]
    schedule=""
    resume[:schedule].each do |q,b|
      wday = I18n.translate(:'date.day_names')[q]
      schedule+="#{wday} #{I18n.l(b,format: " %I:%M %p")} "
    end
    tutoria_new = Tutoria.create(order_id:self.order_id,subject:self.subject,schedule:schedule,
    status:resume[:status],recurrence:self.recurrence,duration:self.duration,
    topic:self.topic, students_number:self.student_number,hours:resume[:hours],
    sessions:resume[:sessions], first:resume[:first],tutor_id:self.tutor_id)
    return tutoria_new.id
  end

  def create_copies
    if self.copy
      if self.recurrence == "Fija"
        date_copy = self.at_date + 1.week
        month = Order::MONTHS[Order.find(self.order_id).for_month]
        while date_copy <= Date.civil(self.at_date.year,month,-1)
          new_copy = self.amoeba_dup
          new_copy.at_date = date_copy
          new_copy.save
          date_copy+= 1.week
        end
      end
      self.copy = false
      tutoria_id = self.create_tutoria_offer
      self.tutoria_id = tutoria_id
      self.save
    end
  end

  def tutor_status
    if self.tutor_id.nil?
      "Pendiente"
    else
      Tutor.find(self.tutor_id).name
    end
  end

  def header
    student = Student.find(self.student_id)
    (I18n.l(self.at_time, format:"%I:%M %p")) + " " + self.subject.to_s + " con " + student.name
  end

  def cost_per_hour # what is paid to tutors per hour
    case self.student_number
    when 1
      if self.tutor.nil? or self.tutor.category == 1
        18000
      elsif self.tutor.category == 2
        19000
      else
        20000
      end
    when 2
      23000
    else
      25000
    end
  end

  def cost_per_session
    self.cost_per_hour*self.duration + self.subsidy_per_session
  end

  def subsidy_per_session
    if self.student.nil?
      0
    else
      self.student.parent.subsidy_amount
    end
  end
end
