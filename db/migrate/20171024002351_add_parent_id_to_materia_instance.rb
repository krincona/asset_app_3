class AddParentIdToMateriaInstance < ActiveRecord::Migration[5.0]
  def change
    add_reference :materia_instances, :parent, foreign_key: true
  end
end
