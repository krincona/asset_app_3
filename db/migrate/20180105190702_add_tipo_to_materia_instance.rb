class AddTipoToMateriaInstance < ActiveRecord::Migration[5.0]
  def change
    add_column :materia_instances, :tipo, :string
  end
end
