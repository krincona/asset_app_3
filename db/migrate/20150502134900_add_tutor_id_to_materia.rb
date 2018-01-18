class AddTutorIdToMateria < ActiveRecord::Migration
  def change
    add_reference :materia, :tutor, index: true
  end
end
