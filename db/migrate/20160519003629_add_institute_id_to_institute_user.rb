class AddInstituteIdToInstituteUser < ActiveRecord::Migration
  def change
    add_reference :institute_users, :institute, index: true
  end
end
