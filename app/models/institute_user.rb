class InstituteUser < ActiveRecord::Base  
  belongs_to :institute
  has_one :user, :as => :user_role

  after_create :create_user

  def create_user

    new_user = User.create(email:self.email, role:2, password:self.card_id,
               password_confirmation:self.card_id,user_role_id:self.id, 
               user_role_type:InstituteUser.model_name.name)
    self.user_id = new_user.id
    self.save
  end

end
