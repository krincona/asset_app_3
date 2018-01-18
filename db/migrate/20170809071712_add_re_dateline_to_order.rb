class AddReDatelineToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :re_dateline, :date
  end
end
