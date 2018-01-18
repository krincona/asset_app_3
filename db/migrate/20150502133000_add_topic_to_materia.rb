class AddTopicToMateria < ActiveRecord::Migration
  def change
    add_column :materia, :topic, :text
  end
end
