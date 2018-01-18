class CreateMateriaStatuses < ActiveRecord::Migration
  def change
    create_table :materia_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
