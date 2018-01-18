class CreateInstitutes < ActiveRecord::Migration
  def change
    create_table :institutes do |t|
      t.string :name
      t.string :calendar_schema
      t.string :address
      t.string :pbx

      t.timestamps
    end
  end
end
