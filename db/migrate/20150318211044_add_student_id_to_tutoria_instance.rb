class AddStudentIdToTutoriaInstance < ActiveRecord::Migration
  def change
    add_reference :tutoria_instances, :student, index: true
  end
end
