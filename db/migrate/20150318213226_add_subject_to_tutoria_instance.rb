class AddSubjectToTutoriaInstance < ActiveRecord::Migration
  def change
    add_column :tutoria_instances, :subject, :string
  end
end
