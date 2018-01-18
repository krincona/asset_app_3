class RemoveTutorPayableFromMateriaInstance < ActiveRecord::Migration
  def change
    remove_column :materia_instances, :tutor_payable, :decimal
  end
end
