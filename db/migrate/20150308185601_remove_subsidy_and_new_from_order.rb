class RemoveSubsidyAndNewFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :subsidy, :boolean
    remove_column :orders, :new, :boolean
  end
end
