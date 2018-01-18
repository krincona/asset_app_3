class AddMateriaStatusToMateria < ActiveRecord::Migration
  def change
    add_reference :materia, :materia_status, index: true
  end
end
