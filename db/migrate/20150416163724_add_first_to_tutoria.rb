class AddFirstToTutoria < ActiveRecord::Migration
  def change
    add_column :tutoria, :first, :date
  end
end
