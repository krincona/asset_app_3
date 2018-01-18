class AddActiveToMateria < ActiveRecord::Migration
  def change
    add_column :materia, :active, :boolean
  end
end
