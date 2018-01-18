class AddRenovateToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :renovate, :boolean, default: false
  end
end
