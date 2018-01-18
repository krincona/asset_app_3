class AddParentIdToStudent < ActiveRecord::Migration
  def change
    add_reference :students, :parent, index: true
  end
end
