class AddStudentsNumberToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :students_number, :integer
  end
end
