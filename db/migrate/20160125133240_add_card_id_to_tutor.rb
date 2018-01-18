class AddCardIdToTutor < ActiveRecord::Migration
  def change
    add_column :tutors, :card_id, :string, :default => "" 
  end
end
