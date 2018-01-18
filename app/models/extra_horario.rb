class ExtraHorario < ActiveRecord::Base
  belongs_to :student
  has_many :tutoria_instances, :dependent => :delete_all
  accepts_nested_attributes_for :tutoria_instances,  :allow_destroy => true

  validates :student_id, presence: true
end
