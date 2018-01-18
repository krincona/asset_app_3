class AddTopicToTutoria < ActiveRecord::Migration
  def change
    add_column :tutoria, :topic, :string
  end
end
