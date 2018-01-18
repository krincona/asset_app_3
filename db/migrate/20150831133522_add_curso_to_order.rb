class AddCursoToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :curso, :boolean
  end
end
