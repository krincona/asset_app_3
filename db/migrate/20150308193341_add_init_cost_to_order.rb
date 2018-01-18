class AddInitCostToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :init_cost, :boolean
  end
end
