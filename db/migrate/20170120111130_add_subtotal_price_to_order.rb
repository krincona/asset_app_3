class AddSubtotalPriceToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :subtotal_sale_price, :decimal
  end
end
