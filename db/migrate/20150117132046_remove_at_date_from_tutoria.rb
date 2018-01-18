class RemoveAtDateFromTutoria < ActiveRecord::Migration
  def change
    remove_column :tutoria, :at_date, :date
  end
end
