class RemoveStudentsNumberFromMateriaInstance < ActiveRecord::Migration
  def change
    remove_column :materia_instances, :students_number, :integer
  end
end
