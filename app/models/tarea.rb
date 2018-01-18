class Tarea < ActiveRecord::Base
  belongs_to :admin_user

  validates :title, :admin_user_id, :presence => true

  before_save :check_status

  def self.due_today
    Tarea.where("due_date= ?",Date.today)
  end

  def self.due_tomorrow
    Tarea.where("due_date= ?",Date.tomorrow)
  end

  def check_status
    if self.status != 'Ok'
      if self.due_date <= Date.today
        self.status = "Urgente"
      else
        self.status = "Pendiente"
      end
    end
  end

end
