class AddProfileToTutor < ActiveRecord::Migration
  def change
    add_column :tutors, :profile, :text, array: true, default: '{}'
  end
end
