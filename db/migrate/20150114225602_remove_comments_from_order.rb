class RemoveCommentsFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :comments, :text
  end
end
