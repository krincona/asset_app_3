class AddPhoneAlt2ToParent < ActiveRecord::Migration
  def change
    add_column :parents, :phone_alt2, :string
  end
end
