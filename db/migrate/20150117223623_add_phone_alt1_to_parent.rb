class AddPhoneAlt1ToParent < ActiveRecord::Migration
  def change
    add_column :parents, :phone_alt1, :string
  end
end
