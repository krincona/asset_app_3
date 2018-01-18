class CreateMateriaInstanceStatuses < ActiveRecord::Migration
  def change
    create_table :materia_instance_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
