class AddPolymorphicToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_role_id, :integer
    add_column :users, :user_role_type, :string
  end
end
