class CreateTutorSlots < ActiveRecord::Migration
  def change
    create_table :tutor_slots do |t|
      t.string :day
      t.time :from_hour
      t.time :to_hour
      t.references :tutor, index: true

      t.timestamps
    end
  end
end
