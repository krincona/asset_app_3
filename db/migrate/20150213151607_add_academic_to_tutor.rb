class AddAcademicToTutor < ActiveRecord::Migration
  def change
    add_column :tutors, :bilingual, :boolean
    add_column :tutors, :level, :string
  end
end
