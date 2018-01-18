class AddPaymentDateToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :payment_date, :date
  end
end
