class AddCategoryToTutor < ActiveRecord::Migration
  def change
    add_column :tutors, :category, :integer
  end
end
