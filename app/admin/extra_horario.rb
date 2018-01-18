ActiveAdmin.register ExtraHorario do
  menu false
  actions :all  , :except => [:destroy]

  #Model
  permit_params :student_id, :tutoria_instances_attributes=> [:id, :topic,
  :tutor_id,:duration, :order_id,:status, :student_id, :subject,:serial,
  :student_number, :at_date,:at_time, :recurrence, :extra_horario_id,
  :_destroy]


  form do |f|
    f.inputs do
      f.has_many :tutoria_instances, :allow_destroy => true,
      :heading => "Agregar Tutoria", :new_record => true do |cf|
        #if cf.object.new_record?
          #cf.input :recurrence, as: :select, collection: TutoriaInstance::RECURRENCE, label: "Ocurrencia", required: true
        #end
        cf.input :subject, as: :select, collection: TutoriaInstance::SUBJECTS,
          label: 'Materia', required: true
       #cf.input :student_number, as: :number, label: "Numero de Estudiantes",:input_html => {:min => 1, :max => 5, :step=>1, :value => 1}
       cf.input :tutor, label: 'Tutor'
       cf.input :at_date, as: :date_picker, label: "Fecha",
       :input_html => {:start => Date.today}
       cf.input :at_time, as: :time_picker, label: "Hora",
       :input_html => {:step => :quarter_hour}
       cf.input :duration, as: :number, label: "Duración",
       :input_html => {:min => 1.5,:step=>0.5}
       cf.input :topic, as: :text, label: "Temas / Observaciones", :input_html => {size: '50px'}
       cf.actions
      end
    end
    f.actions

  end

  # View - Show
  show :title => proc{|extra_horario| "(Sesiones Esporadicas) #{extra_horario.student.name}"} do
    panel 'Tutorias Esporadicas' do
      table_for extra_horario.tutoria_instances do
        column "Materia", :subject
        column "Fecha", :at_date
        column "Hora" do |extra|
          I18n.l extra.at_time, format: " %I:%M %p"
        end
        column "Duración", :duration
        column "Estado" do |extra|
          if extra.status == 'avaible'
            'En Oferta'
          elsif extra.status == 'reserved'
            'Reservada'
          else
            'Null'
          end
        end
        column "Tutor" do |extra|
          if extra.tutor.nil?
            "Sin asignar"
          else
            extra.tutor.name
          end
        end
      end
    end
  end


end
