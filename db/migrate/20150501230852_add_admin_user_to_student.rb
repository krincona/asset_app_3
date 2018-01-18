class AddAdminUserToStudent < ActiveRecord::Migration
  def change
    add_reference :students, :admin_user, index: true
  end
end
