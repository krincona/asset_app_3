class AddStudentsNumberToTutoria < ActiveRecord::Migration
  def change
    add_column :tutoria, :students_number, :integer
  end
end
