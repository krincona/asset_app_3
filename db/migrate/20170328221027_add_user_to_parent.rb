class AddUserToParent < ActiveRecord::Migration
  def change
    add_reference :parents, :user, index: true
  end
end
