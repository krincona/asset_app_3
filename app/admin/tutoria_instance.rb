ActiveAdmin.register TutoriaInstance do
  menu false #priority:4, label: 'Programacion'
  actions :all  , :except => [:new,:destroy,:show]

  config.sort_order = 'at_date_asc'

  permit_params :topic, :tutor_id, :tutoria_id, :duration,
  :order_id, :status, :student_id, :subject, :serial, :student_number,
  :at_date,:at_time, :recurrence

  index :title=> 'Sesiones Programadas',  download_links: [:xls] do
    #column "Codigo", :id
    selectable_column
    column 'Orden' do |s|
      s.serial
    end
    column "Materia", :subject, sortable: false
    column "Alumno" , sortable: false do |s|
      if s.student.nil?
        "Sin Alumno"
      else
        link_to s.student.name, admin_parent_path(s.student.parent.id)
      end
    end
    column "Tutor"  , sortable: false do |s|
      if s.tutor.nil?
        "Pendiente"
      else
        s.tutor.name
      end
    end
    column "Fecha" , :at_date, sortable: true
    column "Hora", sortable: true do |s|
      I18n.l s.at_time, format: " %I:%M %p"
    end
    column "Duracion", :duration, sortable: false
    actions
  end

  filter :order_serial_eq  , :label => "Orden"
  filter :student_name_cont, :label => 'Estudiante'
  filter :tutor_name_cont  , :label => 'Tutor'
  filter :subject          , :label => 'Materia'  , as: :select , collection: TutoriaInstance::SUBJECTS
  filter :at_date      , :label => 'Fecha'

  form :title => {:new=>'Sesión de Tutoria'}  do |f|
    f.inputs do
     f.input :subject, as: :select, collection: TutoriaInstance::SUBJECTS,
        label: 'Materia', required: true
     f.input :student_number, as: :number, label: "Numero de Estudiantes",
      :input_html => {:min => 1, :max => 5, :step=>1, :value => 1}
     f.input :tutor, label: 'Tutor'
     f.input :at_date, as: :date_picker, label: "Fecha",
      :input_html => {:start => Date.today}
     f.input :at_time, as: :time_picker, label: "Hora",
      :input_html => {:step => :quarter_hour}
     f.input :duration, as: :number, label: "Duración",
      :input_html => {:min => 1.5,:step=>0.5}
     f.input :topic, as: :text, label: "Temas / Observaciones",
      :input_html => {size: '100px'}
    f.actions

    end
  end

  controller do

    def apply_pagination(chain)
        chain = super unless formats.include?(:json) || formats.include?(:xls)
        chain
    end


    def index
      index! do |format|
        format.xls {
          spreadsheet = TutoriaInstancesSpreadsheet.new @tutoria_instances
          send_data spreadsheet.generate_xls, filename: "programacion.xls"
        }
      end
    end
  end

=begin
  csv do
    column (:id) {|tutoria| tutoria.id}
    column (:orden) do |tutoria|
      if !tutoria.order.nil?
        tutoria.order.serial
      else
        "--Dato Vacio--"
      end
    end
    column (:materia) {|tutoria| tutoria.subject}
    column (:fecha) {|tutoria| tutoria.at_date}
    column (:numero_estudiantes) {|tutoria| tutoria.student_number}
    column (:tutor) do |tutoria|
      if !tutoria.tutor.nil?
        tutoria.tutor.name
      else
        "--Dato Vacio--"
      end
    end

    column (:alumno) do |tutoria|
      if !tutoria.student.nil?
        tutoria.student.name
      else
        "--Dato Vacio--"
      end
    end
    column (:duracion) {|tutoria| tutoria.duration}
    column (:valor_hora) {|tutoria| tutoria.cost_per_hour}
    column (:valor_subsidio) {|tutoria| tutoria.subsidy_per_session}
    column (:valor_sesion) {|tutoria| tutoria.cost_per_session}
  end
=end
end
