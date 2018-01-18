class CreateParents < ActiveRecord::Migration
  def change
    create_table :parents do |t|
      t.string :name
      t.string :email
      t.integer :phone
      t.string :card_id
      t.references :student, index: true

      t.timestamps
    end
  end
end
