class AddStudentIdToHorario < ActiveRecord::Migration
  def change
    add_reference :horarios, :student, index: true
  end
end
