class AddTarifaToMateriaInstance < ActiveRecord::Migration[5.0]
  def change
    add_column :materia_instances, :tarifa, :decimal
  end
end
