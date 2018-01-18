class AddOrderIdToMateria < ActiveRecord::Migration
  def change
    add_reference :materia, :order, index: true
  end
end
