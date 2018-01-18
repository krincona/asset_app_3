class RemoveStudentIdFromParent < ActiveRecord::Migration
  def change
    remove_reference :parents, :student, index: true
  end
end
