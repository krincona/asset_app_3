class AddStudentsNumberToMateriaInstance < ActiveRecord::Migration
  def change
    add_column :materia_instances, :students_number, :integer
  end
end
