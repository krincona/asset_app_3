class RemoveUserIdFromParent < ActiveRecord::Migration
  def change
    remove_column :parents, :user_id_id, :integer
  end
end
