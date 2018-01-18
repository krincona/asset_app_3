class AddNewToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :new, :boolean
  end
end
