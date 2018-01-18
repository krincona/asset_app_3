class AddTutorIdToInvoice < ActiveRecord::Migration
  def change
    add_reference :invoices, :tutor, index: true
  end
end
