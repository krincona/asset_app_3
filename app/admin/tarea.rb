ActiveAdmin.register Tarea do

  menu false # priority: 2, label: 'Tareas'

  config.sort_order = 'due_date_asc'

  permit_params :id, :admin_user_id, :title, :is_done, :due_date, :status


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end

  filter :created_at, :label => 'Fecha creacion'
  filter :due_date, :label => 'Fecha Limite'
  filter :title_cont, :label => 'Titulo'
  filter :admin_user, :label => 'coordinador asignado'
  filter :status, :label => 'Estado', as: :select, collection: ["Pendiente", "Urgente", "Ok", "Archivada" ]

  batch_action :cambiar_estado, form:{
    estado: %w[Urgente Pendiente Ok ],

    }  do |ids,inputs|
    tareas = Tarea.find(ids)
    tareas.each do |tarea|
      tarea.update_attribute :status,inputs[:estado]
    end
    redirect_to collection_path, notice: "Estado Modificado"
  end

  batch_action :cambiar_fecha_limite, form: {
    fecha: :datepicker
  } do |ids,inputs|
    tareas = Tarea.find(ids)
    tareas.each {|tarea| tarea.update_attribute :due_date, inputs[:fecha]}
    redirect_to collection_path, notice: "Fecha Limite Modificada"
  end


  scope :hoy, default: true do |tarea|
    Tarea.where("due_date <= ? AND admin_user_id= ?  AND status <> ? ",Date.today, current_admin_user.id, "Ok")
  end

  scope :mañana do |tarea|
    Tarea.where("due_date= ? AND admin_user_id= ? ",Date.tomorrow, current_admin_user.id)
  end

  #scope -> {"Manaña"}, :due_tomorrow
  scope -> {"Todas"}, :all

  index download_links: false do
    selectable_column
    column   "Titulo" do |tarea|
      link_to(tarea.title, admin_tarea_path(tarea))
    end
    column "Fecha Creacion", :created_at
    column "Fecha Limite", :due_date
    column "Asignado a" do |tarea|
      if !tarea.admin_user.nil?
        tarea.admin_user.name
      else
        "Sin Asignar"
      end
    end
    column "Estado" do |tarea|
      case tarea.status
      when "Ok"
        status_tag  tarea.status, :ok
      when "Pendiente"
        status_tag  tarea.status, :warn
      when "Urgente"
        status_tag  tarea.status, :error
      when "Archivada"
        tarea.status
      end
    end
  end

  show :title => "Detalle Tarea" do
    columns do
      column span:4 do
        active_admin_comments
      end
      column span:2 do
        panel 'Resumen Tarea' do
          attributes_table_for tarea do
            row 'Fecha de Creacion' do tarea.created_at end
            row "Fecha Limite" do tarea.due_date end
            row "Asignado a" do tarea.admin_user end
            row "Estado" do tarea.status end
          end
        end
      end

    end
  end

  form :title => {:new => 'Nueva Tarea'} do |f|
    f.inputs do
      f.input :title, label:"Descripcion", required: true
      f.input :due_date, label:"Fecha Limite", as: :date_picker,
      :input_html => {:start => Date.today}
      f.input :admin_user, label: "Coordinador"
      f.actions
    end
  end
end
