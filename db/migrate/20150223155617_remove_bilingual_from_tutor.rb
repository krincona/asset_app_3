class RemoveBilingualFromTutor < ActiveRecord::Migration
  def change
    remove_column :tutors, :bilingual, :boolean
  end
end
