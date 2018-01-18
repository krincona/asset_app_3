class RemoveAtDatetimeFromTutoriaInstance < ActiveRecord::Migration
  def change
    remove_column :tutoria_instances, :at_datetime, :string
  end
end
