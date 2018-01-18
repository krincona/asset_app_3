class RemoveExtraFromTutoria < ActiveRecord::Migration
  def change
    remove_column :tutoria, :sunday, :boolean
    remove_column :tutoria, :sunday_at, :datetime
    remove_column :tutoria, :monday, :boolean
    remove_column :tutoria, :monday_at, :datetime
    remove_column :tutoria, :tuesday, :boolean
    remove_column :tutoria, :tuesday_at, :datetime
    remove_column :tutoria, :wednesday, :boolean
    remove_column :tutoria, :wednesday_at, :datetime
    remove_column :tutoria, :thursday, :boolean
    remove_column :tutoria, :thursday_at, :datetime
    remove_column :tutoria, :friday, :boolean
    remove_column :tutoria, :friday_at, :datetime
    remove_column :tutoria, :saturday, :boolean
    remove_column :tutoria, :saturday_at, :datetime
  end
end
