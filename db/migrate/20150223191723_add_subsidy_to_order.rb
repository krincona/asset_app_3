class AddSubsidyToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :subsidy, :boolean
  end
end
