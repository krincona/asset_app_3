class AddAlternativeContactToParent < ActiveRecord::Migration
  def change
    add_column :parents, :name_alt, :string
    add_column :parents, :email_alt, :string
  end
end
