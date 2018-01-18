class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

 	belongs_to :user_role, polymorphic: true

 	before_save :default_role

 	def default_role
 	  if self.role.nil?
 	    self.role = 1
 	    self.user_role_type = "Parent"
 	  end
  end


end
