class AddDurationToTutoria < ActiveRecord::Migration
  def change
    add_column :tutoria, :duration, :float
  end
end
