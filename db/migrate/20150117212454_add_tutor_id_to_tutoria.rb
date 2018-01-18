class AddTutorIdToTutoria < ActiveRecord::Migration
  def change
    add_reference :tutoria, :tutor, index: true
  end
end
