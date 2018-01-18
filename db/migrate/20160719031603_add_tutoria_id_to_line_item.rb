class AddTutoriaIdToLineItem < ActiveRecord::Migration
  def change
    add_reference :line_items, :tutoria, index: true
  end
end
