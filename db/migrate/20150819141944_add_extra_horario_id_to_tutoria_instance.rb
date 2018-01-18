class AddExtraHorarioIdToTutoriaInstance < ActiveRecord::Migration
  def change
    add_reference :tutoria_instances, :extra_horario, index: true
  end
end
