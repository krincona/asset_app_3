class AddUntilReDateToMateria < ActiveRecord::Migration[5.0]
  def change
    add_column :materia, :until_re_date, :date
  end
end
