class CreateInstituteUsers < ActiveRecord::Migration
  def change
    create_table :institute_users do |t|
      t.references :user, index: true
      t.string :name
      t.string :contact_phone
      t.string :position

      t.timestamps
    end
  end
end
