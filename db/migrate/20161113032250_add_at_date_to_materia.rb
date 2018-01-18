class AddAtDateToMateria < ActiveRecord::Migration
  def change
    add_column :materia, :at_date, :date
  end
end
