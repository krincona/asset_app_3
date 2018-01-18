class RemoveAtTimeFromTutoria < ActiveRecord::Migration
  def change
    remove_column :tutoria, :at_time, :time
  end
end
