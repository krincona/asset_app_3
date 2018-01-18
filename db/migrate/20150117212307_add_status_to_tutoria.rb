class AddStatusToTutoria < ActiveRecord::Migration
  def change
    add_column :tutoria, :status, :string
  end
end
