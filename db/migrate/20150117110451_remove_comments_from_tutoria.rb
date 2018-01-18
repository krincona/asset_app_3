class RemoveCommentsFromTutoria < ActiveRecord::Migration
  def change
    remove_column :tutoria, :comments, :text
  end
end
