class AddStudentNumberToTutoriaInstance < ActiveRecord::Migration
  def change
    add_column :tutoria_instances, :student_number, :integer
  end
end
