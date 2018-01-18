class AddSubsidyAmountToParent < ActiveRecord::Migration
  def change
    add_column :parents, :subsidy_amount, :float
  end
end
