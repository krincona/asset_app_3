class AddCopyToTutoriaInstance < ActiveRecord::Migration
  def change
    add_column :tutoria_instances, :copy, :boolean, :default => true
  end
end
