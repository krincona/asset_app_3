class Horario < ActiveRecord::Base
  belongs_to :student
  
  has_many :materias, :dependent => :delete_all
  accepts_nested_attributes_for :materias,  :allow_destroy => true

  validates :from, presence: true
  validates :to, presence: true
  validates :student_id, presence: true


end
