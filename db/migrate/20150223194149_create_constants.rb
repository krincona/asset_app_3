class CreateConstants < ActiveRecord::Migration
  def change
    create_table :constants do |t|
      t.string :name
      t.string :value
      t.string :description

      t.timestamps
    end
  end
end
