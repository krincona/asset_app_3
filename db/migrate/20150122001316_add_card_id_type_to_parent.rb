class AddCardIdTypeToParent < ActiveRecord::Migration
  def change
    add_column :parents, :card_id_type, :string
  end
end
