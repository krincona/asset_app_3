class AddForMonthToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :for_month, :string    
  end
end
