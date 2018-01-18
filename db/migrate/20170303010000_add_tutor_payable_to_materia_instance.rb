class AddTutorPayableToMateriaInstance < ActiveRecord::Migration
  def change
    add_column :materia_instances, :tutor_payable, :decimal
  end
end
