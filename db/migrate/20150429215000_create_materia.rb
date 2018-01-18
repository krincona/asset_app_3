class CreateMateria < ActiveRecord::Migration
  def change
    create_table :materia do |t|
      t.string :name
      t.text :wdays,array: true, default: '{}'
      t.time :at_time
      t.string :ocurrence
      t.references :student, index: true
      t.float :duration
      t.references :horario, index: true

      t.timestamps
    end
  end
end
