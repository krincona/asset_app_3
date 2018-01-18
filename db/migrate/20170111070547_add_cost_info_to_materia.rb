class AddCostInfoToMateria < ActiveRecord::Migration
  def change
    add_column :materia, :total_hours, :decimal
    add_column :materia, :hourly_price, :decimal
    add_column :materia, :sale_price, :decimal
  end
end
