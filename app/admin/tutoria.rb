ActiveAdmin.register Tutoria do
  menu false# label: "Oferta"

  permit_params :subject,:recurrence, :duration,:topic,:status, :students_number,
  :tutor_id,:sessions,:hours



  #View - Show
  index :title => "Tablero de Ofertas" do


  end

  show do
    panel "Detalle Tutoria" do
      attributes_table_for tutoria do
        row "Numero de Orden" do tutoria.order_id end
        row "Materia"
        row "Estudiante"
        row "Tutor"
        row "Duracion"
        row "Horario"

      end
    end
  end



end
