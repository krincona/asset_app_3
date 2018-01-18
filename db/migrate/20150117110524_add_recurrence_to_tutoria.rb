class AddRecurrenceToTutoria < ActiveRecord::Migration
  def change
    add_column :tutoria, :recurrence, :string
  end
end
