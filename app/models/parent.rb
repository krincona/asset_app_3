class Parent < ActiveRecord::Base

  has_many :students, :dependent => :delete_all
  accepts_nested_attributes_for :students,  :allow_destroy => true

  has_one :user, :as => :user_role

  has_many :materia_instances

  validates :name,           presence: true, uniqueness: true
  validates :email,          presence: true, uniqueness: true
  validates :card_id,        presence: true, uniqueness: true
  validates :card_id_type,   presence: true
  #validates :address,        presence: true
  #validates :phone_main,     presence: true
  #validates :phone_alt1,     presence: true
  #validates :subsidy_amount, presence: true

  before_save :upcase_name, :subsidy_check

  after_create :create_user


  def create_user

    new_user = User.create(email:self.email,role:1,password:self.card_id,
               password_confirmation:self.card_id,user_role_id:self.id, user_role_type:Parent.model_name.name)
    self.update_attribute :user_id, new_user.id
  end

  def upcase_name
    self.name = self.name.upcase
  end


  def number_of_students
    self.students.count
  end
=begin
  def students_materia_instances
    ids = self.students.map(&:id)
    instances = MateriaInstance.select {|m| ids.include?(m.materia.student_id) }
    return instances
  end
=end
  private

  def  subsidy_check
    if self.subsidy_amount.nil?
      self.subsidy_amount = 0
    end
  end


end
