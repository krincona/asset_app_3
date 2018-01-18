ActiveAdmin.register Horario do

  menu false
  actions :all  , :except => [:new,:destroy]
  permit_params  :id, :student_id, :from, :to,
  :materias_attributes =>[:id,:duration,:name, :at_time,:ocurrence,:student_id,
    :tutor_id,:_destroy, :horario_id, :topic, :wdays=>[]]

  show :title => proc{|horario| "Horario #{horario.student.name}"} do
    columns do
      column do
        panel 'Periodo' do
          attributes_table_for horario do
            row 'Inicia'  do horario.from end
            row 'Termina' do horario.to   end
          end
        end
      end
      column span:3 do
        panel 'Resumen por Materia' do
          table_for horario.materias do
            column "Materia", :name
            column "Dias Semana", :wdays_to_string
            column "Hora" do |subject|
              I18n.l subject.at_time, format: " %I:%M %p"
            end
            column "Duracion", :duration
            column "Tutor" do |subject|
              if subject.tutor.nil?
                "Pendiente"
              else
                subject.tutor.name
              end
            end
            #column "Ocurrencia", :ocurrence
          end
        end
      end
    end
    panel 'Tutorias Programadas'  do
    end
  end

  filter :student_name_cont,  :label => 'Estudiante'
  filter :materia_name_cont, :label => 'Materia'
  form do |f|
    f.inputs "Periodo" do
      f.input :from, label: "Inicia",as: :date_picker
      f.input :to, label: "Termina", as: :date_picker
    end
    f.inputs do
      f.has_many :materias,  :allow_destroy => true,
      :heading => "Agregar Materia", :new_record => true do |cf|
        cf.input :name, label:"Materia", as: :select,
          collection: TutoriaInstance::SUBJECTS, required: true
        cf.input :wdays, label:"Dias Semana", as: :select, multiple: true,
          collection: I18n.t(:"date.day_names")
        cf.input :at_time, label:"Hora"#, as: :time_picker, :input_html => {:step => :quarter_hour}
        cf.input :duration, as: :number, label: "Duración",
        :input_html => {:min => 1.5,:step=>0.5}
        cf.input :topic, as: :text, label: "Temas / Observaciones", :input_html => {size: '50px'}
        cf.input :tutor, as: :select, collection: Tutor.activos, label: "Tutor"
        cf.actions
      end
    end
    f.actions
  end



end
