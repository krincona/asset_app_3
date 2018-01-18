class AddWeeklyToMateria < ActiveRecord::Migration
  def change
    add_column :materia, :weekly, :boolean
  end
end
