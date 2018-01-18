class AddCreatedByToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :created_by, :string
  end
end
