class AddUserIdToParent < ActiveRecord::Migration
  def change
    add_reference :parents, :user_id, index: true
  end
end
