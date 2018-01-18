class AddDurationToTutoriaInstance < ActiveRecord::Migration
  def change
    add_column :tutoria_instances, :duration, :float
  end
end
