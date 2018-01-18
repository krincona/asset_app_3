class AddDateTimeToTutoriaInstance < ActiveRecord::Migration
  def change
    add_column :tutoria_instances, :at_date, :date
    add_column :tutoria_instances, :at_time, :time
  end
end
