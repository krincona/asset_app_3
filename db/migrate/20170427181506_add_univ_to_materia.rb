class AddUnivToMateria < ActiveRecord::Migration[5.0]
  def change
    add_column :materia, :univ, :boolean
  end
end
