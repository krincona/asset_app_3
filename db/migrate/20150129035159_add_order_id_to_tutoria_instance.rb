class AddOrderIdToTutoriaInstance < ActiveRecord::Migration
  def change
    add_reference :tutoria_instances, :order, index: true
  end
end
