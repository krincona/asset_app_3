ActiveAdmin.register Order do
  menu priority: 1, label: "Ordenes"

  actions :all, :except => [:new,:destroy]
  batch_action :destroy, false

  config.sort_order = 'serial_desc'

  #config.paginate = false



# Model
  permit_params :student_id, :status, :re_date, :renovate, :for_month, :students_number, :tarifa, 
  :payment_ref, :init_cost,:active,:serial, :payment_date, :payment_dateline,:admin_user_id,
  :materias_attributes=> [:id, :until_re_date, :univ, :student_id,:name, :topic, :weekly,:order_id,:students_number,:_destroy, 
  :materia_instances_attributes=> [:id,:duration, :materia_id, :order_id, :parent_id, :at_date,:at_time, :tutor_id,:_destroy]]


  batch_action :confirmar,form: {
  detalle:  :textarea,
  fecha: :datepicker
  } do |ids, inputs|
    orders = Order.find(ids)
    serials = []
    orders.each { |order| order.confirm(inputs) }
    redirect_to collection_path, notice: 'Ordenes Confirmadas7'
  end


  batch_action :caducar, confirm: "Esta seguro?"  do |ids|
    orders = Order.find(ids)
    orders.each do |order|
      order.update_attribute :status,6
      order.materias.each  {|mat| mat.destroy}
    end
    redirect_to collection_path
  end

# Index

  index :title => 'Ordenes Activas', download_links: [:csv] do

    selectable_column
    column "ID"  do |o|
      if o.student.nil?
        link_to(o.serial, edit_admin_order_path(o))
      else
        link_to(o.serial, admin_order_path(o))
      end
    end
    column "Estudiante" do |o|
      if o.student.nil?
        "Sin alumno"
      else
        o.student.name
      end
    end
    column 'Coordinador', sortable: true do |o|
      unless o.admin_user.nil?
        o.admin_user.name
      else
        "Papá"
      end
    end
    column "Estado", sortable: false do |o|
      o.reload
      case o.status
        when 1
          status_tag o.status_name, :default
        when 3
          status_tag o.status_name, :warn
        when 2
          total = o.materias.count
          on_offer = o.materias.select {|m| m.materia_status_id ==2}.count
          status_tag "#{o.status_name} (#{on_offer}/#{total})", :error
        when 4
          status_tag o.status_name, :warn
        when 5
          status_tag o.status_name, :ok
        when 6
          status_tag o.status_name, :default
        end
    end

    column "Limite Pago", :payment_dateline, sortable: true

    column "Limite Repro", :re_dateline, sortable: true

    column "# Horas", :hours #:total_hours_all
=begin
    column "Subtotal"  do |o|
     number_to_currency(o.subtotal_sale_price,:unit => '$', :precision => 0, :format => '%u%n' )#(o.monthly_total_cost + o.subsidy_total,:unit => '$', :precision => 0, :format => '%u%n' )
    end

    column "Subsidio" do |o|
     number_to_currency(o.subsidy,:unit => '$', :precision => 0, :format => '%u%n' )
    end
=end
    column "Costo Total"  do |o|
     number_to_currency(o.sale_price,:unit => '$', :precision => 0, :format => '%u%n' )#(o.monthly_total_cost + o.subsidy_total,:unit => '$', :precision => 0, :format => '%u%n' )
    end

    column "Costo por Hora" do |o|
      number_to_currency(o.hourly_price, :unit=> '$', :precision => 0, :format => '%u%n')
    end

  end

  filter :serial, as: :numeric,:label => 'Consecutivo'
  filter :student_name_cont,  :label => 'Estudiante'
  filter :admin_user,:label => 'Coordinador'
  #filter :for_month, :label => 'Mes', as: :select,collection:I18n.t(:'date.month_names').select {|month| !month.nil?}.map(&:upcase)
  filter :status, as: :select, collection: OrderStatus.all , :label => 'Estado de la Orden'

  #filter :renovate, :label => 'Renovaciones Automaticas'
  filter :created_at, :label => 'Fecha de  Creacion'
  filter :re_dateline, :label => 'Fecha Limite Reprogramación'
  filter :payment_dateline, :label => 'Fecha Limite Pago'
  filter :payment_date, :label => 'Fecha de Pago'


# View - New + Edit,
  form :title => proc{|order| "Orden ##{order.serial}" }   do |f|
  

    columns do
      column span:2 do        
        f.inputs "Informacion Basica" do
          
          if f.object.new_record?
            f.input :student_id, required: true , :input_html=>{value:"#{Student.find(params[:student_id]).id}" }
            f.input :admin_user_id, as: :hidden, required: true, :input_html=>{value:"#{current_admin_user.id}"}
          else
            if object.materias.empty?
              object.materias.build
            end
            h4 "Estudiante: " + object.student.name , :class =>"label"
              
              
            if object.renovate
              h4 "Sesiones Fijas hasta: " + (I18n.l object.re_date, format: "%A %B %d, %Y") 
            else
              h4 "Sesiones Esporadicas" 
            end
          end
        end
      end
      column span:2 do
        f.inputs "Informacion de Pagos" do
          f.input :payment_ref, label: "Referencia de Pago", :input_html => {size: '50px'}
          f.input :payment_date, as: :datepicker, label: "Fecha de Pago"
        end
      end
    end

    if object.cerrado
        new_val = false
        tarifa = ""
    else 
      new_val = true
      tarifa  = " - " + object.tarifa
    end

    f.inputs "Materias" + tarifa do
      
      f.input :students_number, as: :number, label: " #Estudiantes", required: true, :input_html => {:min => 1,:step=>1,:max=>4}
      f.has_many :materias, :allow_destroy => false,:heading => "Agregar Tutoria", :new_record => new_val do |materia|
        
        materia.input :student_id, as: :hidden, :input_html=>{value:"#{object.student_id}" }
        if object.renovate
          materia.input :weekly, as: :hidden, :input_html=>{value:"#{object.renovate}" }
          materia.input :until_re_date, as: :hidden, :input_html=>{value:"#{object.re_date}" }
        end
        materia.input :name, as: :select, collection: object.subjects,label: 'Materia', required: true, include_blank: false
        materia.input :students_number, as: :hidden, label: " #Estudiantes", :input_html=>{value:"#{object.students_number}" }

        materia.input :topic, as: :text, label: "Temas", required: true, :input_html => {size: '50px'}
        if !object.cerrado
          materia.input :_destroy, :as=>:boolean,:required=> false, :label=>'Borrar Materia'
        end
       materia.has_many :materia_instances, :heading=>"Sesiones", :new_record=> new_val do |instance|

         instance.object.order_id = object.id
         instance.input :order_id, as: :hidden
         
         instance.object.parent_id = object.student.parent.id
         instance.input :parent_id, as: :hidden



        if instance.object.new_record?
          instance.object.duration = 1.5
          instance.object.at_date  = Date.today + 2.days
          instance.object.at_time  = Time.now.change(:hour => 16)
          instance.object.order_id = object.id
        end
        instance.input :order_id, as: :hidden 
        if object.cerrado
          instance.input :duration, label:"Duración", input_html: {disabled: true}
        else
          instance.input :duration , as: :number, label: "Duración" , :input_html => {:min => 1.5,:step=>0.5,:max=>3.0}, required: true
        end
        instance.input :at_date  , as: :datepicker ,label: "Fecha"    , :input_html => {:start => Date.today}, required: true
        instance.input :at_time, as: :time_picker, label:"Hora",:input_html => {:step => :quarter_hour}, required: true
        instance.input :tutor_id, as: :select, collection: Tutor.activos, label: "Tutor"
        if !object.cerrado
          instance.input :_destroy, as: :boolean, required: false, :label=>'Borrar Sesion'
        end
       end
     end
    end
    f.actions
  end



# View - Show
  show :title => proc{|order| "Orden ##{order.serial}" }  do
    h3 "Detalle Financiero"
    columns do
      column do
        panel 'Informacion Basica' do
          attributes_table_for order do
            row 'Estudiante' do link_to order.student.name, admin_student_path(order.student.id) end
            row 'Acudiente' do link_to order.student.parent.name, admin_parent_path(order.student.parent.id) end
            row 'Orden fija?' do
              if order.renovate
                "Si"
              else
                "No"
              end
            end
            if !order.tarifa.nil?
              row 'Tarifa' do order.tarifa end
            end
            row 'Estado'  do order.status_name end
            row 'Fecha Limite de Reprogramación' do order.re_dateline end
            row 'Fecha Limite de Pago' do order.payment_dateline end
            row 'Referencia de Pago' do
              if order.payment_ref.nil?
                "No Ingresada"
              else
                order.payment_ref
              end
            end
            row 'Fecha de Pago' do
              if order.payment_date.nil?
                "No Ingresada"
              else
                I18n.l order.payment_date, format: "%a %B %d, %Y"
              end
            end
          end
        end
      end
      column span:2 do
        tarifa = order.tarifa.nil? ?  " " : " - " +order.tarifa
        panel 'Resumen Costo por Materia' + tarifa do
          table_for order.materias.sort_by &:name do
            column "Materia", :name
            column "# Estudiantes" do |materia|
              materia.order.students_number
            end
            column "Estado" do |materia|
              materia.materia_status.name
            end
            column "Horas", :total_hours
            #column "Costo" do |materia|
             # number_to_currency(materia.reload.sale_price,:unit => '$', :precision => 0, :format => '%u%n' )
            #end
          end
        end
        panel 'Resumen Costo Total' do
          table_for order do
            column "Horas", :hours
            column "Costo por hora" do
             number_to_currency(order.hourly_price,:unit => '$', :precision => 0, :format => '%u%n')
            end
            #column "Creación" do
              #number_to_currency(order.creation_cost,:unit => '$', :precision => 0, :format => '%u%n')
            #end
            column "Subtotal" do
              number_to_currency(order.reload.subtotal_sale_price,:unit => '$', :precision => 0, :format => '%u%n' )
            end
            column "Descuento" do
              number_to_currency(order.reload.discount,:unit => '$', :precision => 0, :format => '%u%n')
            end
            column "Subsidio" do
              number_to_currency(order.subsidy,:unit => '$', :precision => 0, :format => '%u%n')
            end
            column "Total" do
              number_to_currency(order.sale_price,:unit => '$', :precision => 0, :format => '%u%n')
            end

          end
        end
      end
    end

    h3 "Detalle Logistico"
    panel "Sesiones" do
      table_for order.materia_instances do |inst|
        column "Materia" do |inst|
          inst.materia.name
        end
        column "Estado" do |inst|
          inst.materia_instance_status.name
        end
        column "Tutor", :tutor_status
        column "Fecha" do |inst|
          I18n.l inst.at_date, format: "%a %B %d, %Y"
        end
        column "Hora" do |inst|
          I18n.l inst.at_time, format: " %I:%M %p"
        end
        column "Duración", :duration
      end
    end
    active_admin_comments
  end

  action_item :resend, only: :show do
    link_to 'Enviar Correo', resend_admin_order_path(resource)
  end

  member_action :resend, method: :get do
    resource.resend_emails
    redirect_to resource_path(resource), notice:" Confirmacion de reserva enviada"
  end



  controller do
=begin
    def edit
      if resource.materias.empty?
        materias = resource.materias.build
        #materias.materia_instances.build
      end

    end
=end
    def apply_pagination(chain)
        chain = super unless formats.include?(:json) || formats.include?(:xls)
        chain
    end
  end

# csv
  csv  do
    column (:consecutivo) {|order| order.serial} #check
    column (:referencia_de_pago) {|order| order.payment_ref} #check
    column (:fecha_de_pago) {|order| order.payment_date} #check
    column (:estado)  {|order| order.status_name} #check
    column (:estudiante) {|order| order.student.name unless order.student.nil?} #check
    column (:cliente) {|order| order.student.parent.name unless order.student.nil?} #check
    column (:documento_cliente) {|order|  "#{order.student.parent.card_id_type} - #{order.student.parent.card_id}" unless order.student.nil? }#check
    column (:cantidad_horas) {|order| order.hours.to_f }#check
    column (:descuento) {|order| order.discount.to_f}#check
    column (:valor_hora) {|order| order.hourly_price.to_f}#check
    #column (:costo_creacion_plan) {|order| order.creation_cost.to_f}#check
    column (:valor_tutores_subsidio) {|order| order.subsidy.to_f}#check
    column (:valor_tutores_tutorias) {|order| order.subtotal_tutoria.to_f }#check
    column (:valor_tutores_total) {|order| order.subtotal_tutoria.to_f  + order.subsidy.to_f}#check
    column (:valor_serv_coord) {|order| order.subtotal_admin.to_f}#check
    column (:valor_impuesto) {|order| order.tax.to_f}#check
    column (:valor_total) {|order| order.sale_price.to_f}#check
  end
end
