class AddScheduleToTutoria < ActiveRecord::Migration
  def change
    add_column :tutoria, :schedule, :string
  end
end
