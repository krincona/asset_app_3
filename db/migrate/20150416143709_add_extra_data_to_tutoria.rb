class AddExtraDataToTutoria < ActiveRecord::Migration
  def change
    add_column :tutoria, :sessions, :integer
    add_column :tutoria, :hours, :float
  end
end
