class CreateTareas < ActiveRecord::Migration
  def change
    create_table :tareas do |t|
      t.references :admin_user, index: true
      t.string :title
      t.boolean :is_done
      t.date :due_date

      t.timestamps
    end
  end
end
