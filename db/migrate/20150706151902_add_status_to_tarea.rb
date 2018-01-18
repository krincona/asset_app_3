class AddStatusToTarea < ActiveRecord::Migration
  def change
    add_column :tareas, :status, :string, :default => 'Pendiente'
  end
end
