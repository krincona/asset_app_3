class CreateExtraHorarios < ActiveRecord::Migration
  def change
    create_table :extra_horarios do |t|
      t.references :student, index: true

      t.timestamps
    end
  end
end
