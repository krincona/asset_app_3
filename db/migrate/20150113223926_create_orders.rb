require 'chronic'

class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :student, index: true
      t.text :comments
      t.string :status, :default => "En Oferta"
      t.date :re_date 

      t.timestamps
    end
  end
end
