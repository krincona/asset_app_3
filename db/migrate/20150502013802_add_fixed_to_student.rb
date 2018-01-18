class AddFixedToStudent < ActiveRecord::Migration
  def change
    add_column :students, :fixed, :boolean
  end
end
