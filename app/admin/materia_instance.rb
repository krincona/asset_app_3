ActiveAdmin.register MateriaInstance do

menu priority:2, label: 'Programacion'
  actions :all  , :except => [:new,:edit,:destroy,:show]

  config.sort_order = 'at_date_desc'

  permit_params :tutor_id, :materia_id, :duration, :materia_instance_status_id, :at_date,:at_time, :order_id, :parent_id

  index :title=> 'Sesiones Programadas',  download_links: [:xls] do
    #column "Codigo", :id
    selectable_column
    column 'Orden' do |inst|
      link_to inst.materia.order.serial, admin_order_path(inst.materia.order.id)
    end
    column "Materia" do |inst|
      inst.materia.name
    end
    column "Alumno" , sortable: false do |inst|
      if inst.student.nil?
        "Sin Alumno"
      else
        link_to inst.student.name, admin_student_path(inst.student.id)
      end
    end
    column "Tutor"  , sortable: false do |inst|
      if inst.tutor.nil?
        "Pendiente"
      else
        inst.tutor.name
      end
    end
    column "Fecha", sortable: true do |inst|
      I18n.l inst.at_date, format: "%a %B %d, %Y"
    end

    column "Hora", sortable: true do |inst|
      I18n.l inst.at_time, format: " %I:%M %p"
    end
    column "Duracion", :duration, sortable: false
    actions
  end

  filter :materia_order_serial_eq  , :label => "Orden"
  filter :materia_student_name_cont, :label => 'Estudiante'
  filter :tutor_name_cont  , :label => 'Tutor'
  #filter :subject          , :label => 'Materia'  , as: :select , collection: TutoriaInstance::SUBJECTS
  filter :at_date      , :label => 'Fecha'


  csv do
    column (:orden)   {|inst| inst.order_id}
    column (:materia) {|inst| inst.materia.name}
    #column (:alumno)  {|inst| inst.student.name unless inst.student.nil?}
    column (:tutor)   {|inst| inst.tutor.name unless inst.tutor.nil?}
    column (:fecha)   {|inst| I18n.l inst.at_date, format: "%a %B %d, %Y"}
    column (:hora)    {|inst| I18n.l inst.at_time, format: " %I:%M %p"}
    column (:duración){|inst| inst.duration}
    column (:mes)     {|inst| inst.at_date.month}
    column (:tipo)    {|inst| inst.tipo}
    column (:tarifa)  {|inst| inst.tarifa}

  end 


  controller do

    def apply_pagination(chain)
        chain = super unless formats.include?(:json) || formats.include?(:xls)
        chain
    end


    def index
      index! do |format|
        format.xls {
          spreadsheet = MateriaInstancesSpreadsheet.new @materia_instances
          send_data spreadsheet.generate_xls, filename: "programacion.xls"
        }
      end
    end
  end


end
