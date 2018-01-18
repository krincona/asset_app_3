class AddAddressToParent < ActiveRecord::Migration
  def change
    add_column :parents, :address, :string
  end
end
