class AddTarifaToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :tarifa, :string
  end
end
