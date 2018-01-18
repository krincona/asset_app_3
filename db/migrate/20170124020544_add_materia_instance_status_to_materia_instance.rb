class AddMateriaInstanceStatusToMateriaInstance < ActiveRecord::Migration
  def change
    add_reference :materia_instances, :materia_instance_status, index: true
  end
end
