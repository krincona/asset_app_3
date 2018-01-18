require 'chronic'

class Tutoria < ActiveRecord::Base

  belongs_to :order
  belongs_to :tutor
  has_many :tutoria_instances

  validates :subject,   presence: true
  validates :topic,     presence: true
  #validates :recurrence, presence: true

  def create_duplicates
    materia = Materia.new(name: self.subject, order_id: self.order_id,topic: self.topic,student_id: self.order.student_id)
    case self.status
      when "closed"
        materia.materia_status_id = 5
      when "confirm"
        materia.materia_status_id = 5
      when "avaible"
        materia.materia_status_id = 2
      when "reserved"
        materia.materia_status_id = 3
    end
    materia.save!
    self.tutoria_instances.each do |ti|
      instance = MateriaInstance.new(duration: ti.duration,at_date: ti.at_date,at_time: ti.at_time,materia_id: materia.id,tutor_id: ti.tutor_id)
      case ti.status
        when "paid"
          instance.materia_instance_status_id = 5
        when "confirm"
          instance.materia_instance_status_id = 3
        when "avaible"
          instance.materia_instance_status_id = 1
        when "reserved"
          instance.materia_instance_status_id = 2
      end
      instance.save!
    end
  end

  def self.payable
    Tutoria.select {|t| t.has_payables?}
  end

  def student
    Order.find(self.order_id).student
  end

  def cost
    subtotal = self.hours*self.order.hourly_cost + self.sessions*self.student.parent.subsidy_amount
    return subtotal
  end

  def update_postulate(tutor_id)
    self.update_attributes({:status=>'reserved',:tutor_id => tutor_id})
    self.tutoria_instances.each {|t| t.update_attributes({:status=>'reserved',
    :tutor_id => tutor_id})}
    if self.order.tutorias.all? {|t| t.status == 'reserved' }
      parent = self.student.parent
      TutoriaMailer.parent_reserved_notification(self.order).deliver
    end
  end

  def update_account_acceptance
    self.update_attributes({:status=>'closed'})
    self.payable_instances.each {|instance| instance.update_attribute :status,'paid'}

  end

  def has_payables?
    if status != "closed"
      !!self.tutoria_instances.any? {|instance| instance.payable?}
    else
      false
    end
  end

  def payable_hours
    hours = 0
    self.payable_instances.each {|instance| hours +=instance.duration}
    return hours
  end

  def payable_sessions
    self.payable_instances.count
  end

  def payable_instances
    self.tutoria_instances.select {|instance| instance.payable?}
  end

  def payable_subsidy
    self.payable_sessions*self.student.parent.subsidy_amount
  end


  def payable_subtotal
    sum = 0
    payable_instances = self.payable_instances
    payable_instances.each {|instance| sum+= instance.duration}
    if self.students_number == 1
      subtotal = sum*self.tutor.hourly_rate
    else
      subtotal = sum*23000
    end
  end

  def total_account
    total = self.payable_subtotal+self.payable_subsidy
  end

  def load_status
    if self.tutor_id.nil?
      self.update_attribute :status,'avaible'
    else
      self.update_attribute :status,'reserved'
    end

  end
end
