class RemovePhoneFromParent < ActiveRecord::Migration
  def change
    remove_column :parents, :phone, :integer
  end
end
