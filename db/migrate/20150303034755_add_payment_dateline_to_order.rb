class AddPaymentDatelineToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :payment_dateline, :date
  end
end
