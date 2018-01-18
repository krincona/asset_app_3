class CreateTutoria < ActiveRecord::Migration
  def change
    create_table :tutoria do |t|
      t.references :order, index: true
      t.string :subject
      t.date :at_date
      t.time :at_time
      t.text :comments

      t.timestamps
    end
  end
end
