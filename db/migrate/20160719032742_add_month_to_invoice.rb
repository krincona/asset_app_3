class AddMonthToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :month, :integer
  end
end
