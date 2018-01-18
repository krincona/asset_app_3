class AddStudentsNumberToMateria < ActiveRecord::Migration
  def change
    add_column :materia, :students_number, :integer
  end
end
