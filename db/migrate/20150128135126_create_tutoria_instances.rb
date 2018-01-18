class CreateTutoriaInstances < ActiveRecord::Migration
  def change
    create_table :tutoria_instances do |t|
      t.datetime :at_datetime
      t.text :topic
      t.references :tutor, index: true
      t.references :tutoria, index: true

      t.timestamps
    end
  end
end
