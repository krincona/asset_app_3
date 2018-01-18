class CreateHorarios < ActiveRecord::Migration
  def change
    create_table :horarios do |t|
      t.date :from
      t.date :to

      t.timestamps
    end
  end
end
