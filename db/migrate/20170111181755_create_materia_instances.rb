class CreateMateriaInstances < ActiveRecord::Migration
  def change
    create_table :materia_instances do |t|
      t.decimal :duration
      t.date :at_date
      t.time :at_time
      t.references :materia, index: true

      t.timestamps
    end
  end
end
