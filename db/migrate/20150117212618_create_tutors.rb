class CreateTutors < ActiveRecord::Migration
  def change
    create_table :tutors do |t|
      t.string :name
      t.string :email,              null: false, default: ""

      t.timestamps
    end
  end
end
