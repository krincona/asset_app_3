class AddWeekDaysToTutoria < ActiveRecord::Migration
  def change
    add_column :tutoria, :sunday,     :boolean
    add_column :tutoria, :monday,     :boolean
    add_column :tutoria, :tuesday,    :boolean
    add_column :tutoria, :wednesday,  :boolean
    add_column :tutoria, :thursday,   :boolean
    add_column :tutoria, :friday,     :boolean
  add_column :tutoria, :saturday,     :boolean
  end
end
