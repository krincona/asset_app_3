class AddSerialToTutoriaInstance < ActiveRecord::Migration
  def change
    add_column :tutoria_instances, :serial, :integer
  end
end
