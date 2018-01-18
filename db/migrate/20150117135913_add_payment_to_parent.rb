class AddPaymentToParent < ActiveRecord::Migration
  def change
    add_column :parents, :payment, :boolean
  end
end
