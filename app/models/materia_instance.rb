class MateriaInstance < ActiveRecord::Base
  include ModelHelper
  belongs_to :materia
  belongs_to :order
  belongs_to :tutor
  belongs_to :materia_instance_status
  belongs_to :parent

  extend SimpleCalendar
  #has_calendar :attribute => :at_date

  default_scope { order('at_date ASC') }

  before_create  :set_materia_instance_status

  before_save    :set_materia_instance_status
  after_save     :update_ids, :save_materia
  #after_destroy  :force_materia_reload

  
  def confirmada?
    if self.materia_instance_status_id == 2 && self.order.status >= 4
      true
    else
      false
    end
  end

  def save_materia
    self.materia.save!
  end



  def update_ids
    if self.parent_id.nil?
      self.parent_id = self.materia.student.parent.id  
    end
    if self.order_id.nil?
      self.parent_id = self.materia.order.id  
    end
  end


  def force_materia_save
    self.materia.save
  end


  def payable?
    if self.materia_instance_status_id != 5
      self.at_date.month == (Date.today - 1.month).month
    else
      false
    end
  end

  def tutor_payable
    rate = self.order.hourly_payable
    return rate*self.duration
  end

  def tutor_payable_acceptance
    self.update_attribute :materia_instance_status_id,5

  end

  def order
    self.materia.order
  end

  def student
    self.order.student
  end

  def students_number
    self.materia.students_number
  end

  def subsidy
    self.student.parent.subsidy_amount
  end

  def total_payable
    self.subsidy + self.tutor_payable
  end


  def tutor_status
    if self.tutor_id.nil?
      "Pendiente"
    else
      Tutor.find(self.tutor_id).name
    end
  end

  def duplicate(date)

    dup_until = date
    
    instance_date = self.at_date + 1.week
    
    while  instance_date <= dup_until
        instance_copy = self.dup
        instance_copy.at_date = instance_date
        instance_copy.save!
        instance_date += 1.week
        #instance_copy.materia.save!
    end
  end

  def count_until_end_of_month
    dup_until = self.until_date
    instance_date = self.at_date + 1.week
    count = 1
    while  instance_date <= dup_until
        count +=1
        instance_date += 1.week
    end
    return count
  end

  def set_materia_instance_status
    unless self.materia_instance_status_id == 5
      if self.tutor_id.nil?
        self.materia_instance_status_id = 1
      else
        self.materia_instance_status_id = 2   
     end
    end 
 end

  def force_materia_reload
    self.materia.reload.save
    self.order.reload.save
  end

  def tipo_tarifa
    if self.materia.univ
      return "Univ"
    elsif ['TOEFL','IELTS','Matematicas(SAT)','Ingles(SAT)'].include? self.materia.name 
      return "Examenes"
    else
      return "Colegio"
    end
  end 

  def calculate_rate
    self.materia.order.hourly_price
  end

end
