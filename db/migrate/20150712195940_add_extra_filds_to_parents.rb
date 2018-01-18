class AddExtraFildsToParents < ActiveRecord::Migration
  def change
    add_column :parents, :address_alt, :string
    add_column :parents, :address_comment, :text
  end
end
