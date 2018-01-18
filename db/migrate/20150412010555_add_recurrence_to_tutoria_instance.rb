class AddRecurrenceToTutoriaInstance < ActiveRecord::Migration
  def change
    add_column :tutoria_instances, :recurrence, :string, :default => "fija"
  end
end
