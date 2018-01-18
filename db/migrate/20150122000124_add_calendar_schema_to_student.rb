class AddCalendarSchemaToStudent < ActiveRecord::Migration
  def change
    add_column :students, :calendar_schema, :string
  end
end
