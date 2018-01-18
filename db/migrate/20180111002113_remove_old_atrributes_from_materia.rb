class RemoveOldAtrributesFromMateria < ActiveRecord::Migration[5.0]
  def change
    remove_column :materia, :wdays, :string
    remove_column :materia, :at_time, :time
    remove_column :materia, :ocurrence, :string
    remove_column :materia, :duration, :float
    remove_column :materia, :at_date, :date
    remove_column :materia, :horario_id, :integer
    remove_column :materia, :tutor_id, :integer
  end
end
