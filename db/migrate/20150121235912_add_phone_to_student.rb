class AddPhoneToStudent < ActiveRecord::Migration
  def change
    add_column :students, :phone, :string
  end
end
