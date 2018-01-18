class AddSerialToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :serial, :integer
  end
end
