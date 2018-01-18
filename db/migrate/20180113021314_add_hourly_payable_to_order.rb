class AddHourlyPayableToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :hourly_payable, :integer
  end
end
