class AddUserDataToInstituteUser < ActiveRecord::Migration
  def change
    add_column :institute_users, :email, :string
    add_column :institute_users, :card_id, :string
  end
end
