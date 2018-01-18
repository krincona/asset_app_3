class AddCerradoToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :cerrado, :boolean
  end
end
