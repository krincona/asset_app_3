class AddPaymentRefToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :payment_ref, :text
  end
end
