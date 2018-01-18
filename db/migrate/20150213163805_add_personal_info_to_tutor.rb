class AddPersonalInfoToTutor < ActiveRecord::Migration
  def change
    add_column :tutors, :university, :string
    add_column :tutors, :grade, :string
    add_column :tutors, :homephone, :string
    add_column :tutors, :cellphone, :string
    add_column :tutors, :major, :string
  end
end
