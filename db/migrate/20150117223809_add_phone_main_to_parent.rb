class AddPhoneMainToParent < ActiveRecord::Migration
  def change
    add_column :parents, :phone_main, :string
  end
end
