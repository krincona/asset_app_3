class AddMateriaIdToTutoriaInstance < ActiveRecord::Migration
  def change
    add_reference :tutoria_instances, :materia, index: true
  end
end
