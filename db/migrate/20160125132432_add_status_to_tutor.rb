class AddStatusToTutor < ActiveRecord::Migration
  def change
    add_column :tutors, :status, :boolean, :default => true
  end
end
