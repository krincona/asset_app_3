class AddStatusToTutoriaInstance < ActiveRecord::Migration
  def change
    add_column :tutoria_instances, :status, :string, :default => "avaible"
  end
end
