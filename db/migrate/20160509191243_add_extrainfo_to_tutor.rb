class AddExtrainfoToTutor < ActiveRecord::Migration
  def change
    add_column :tutors, :specific_experience, :text
    add_column :tutors, :school_experience, :text
    add_column :tutors, :language_experience, :text, array: true, default: '{}'
  end
end
