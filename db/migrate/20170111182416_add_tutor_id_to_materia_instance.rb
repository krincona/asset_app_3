class AddTutorIdToMateriaInstance < ActiveRecord::Migration
  def change
    add_reference :materia_instances, :tutor, index: true
  end
end
