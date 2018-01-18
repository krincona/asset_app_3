class AddWeekDaysAtToTutoria < ActiveRecord::Migration
  def change
    add_column :tutoria, :sunday_at,    :datetime
    add_column :tutoria, :monday_at,    :datetime
    add_column :tutoria, :tuesday_at,   :datetime
    add_column :tutoria, :wednesday_at, :datetime
    add_column :tutoria, :thursday_at,  :datetime
    add_column :tutoria, :friday_at,    :datetime
    add_column :tutoria, :saturday_at,  :datetime
  end
end
