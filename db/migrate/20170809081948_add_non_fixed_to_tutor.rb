class AddNonFixedToTutor < ActiveRecord::Migration[5.0]
  def change
    add_column :tutors, :non_fixed, :boolean
  end
end
