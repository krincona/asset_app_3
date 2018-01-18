class AddInstituteIdToStudent < ActiveRecord::Migration
  def change
    add_reference :students, :institute, index: true
  end
end
