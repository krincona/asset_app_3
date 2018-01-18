class AddOrderIdToMateriaInstance < ActiveRecord::Migration[5.0]
  def change
    add_reference :materia_instances, :order, foreign_key: true
  end
end
