ActiveAdmin.register Student do #, as: "Estudiante" do

  #config.paginate = false

  config.sort_order = 'updated_at_desc'

  #active_admin_importable

  actions :all, :except => [:new,:edit,:destroy]

  menu  label: "Estudiantes", parent: "Usuarios"
  permit_params :name,:email,:school,:grade,:address,:calendar_schema,:fixed

=begin
  batch_action :cambiar_tipo_alumno, form: {
  tipo: %w[Fijo Esporadico]
  } do |ids,inputs|
    students = Student.find(ids)
    students.each do |student|
      if inputs[:tipo] == 'Fijo'
        student.update_attribute :fixed, true
      elsif inputs[:tipo] == 'Esporadico'
        student.update_attribute :fixed, false
      end
    end
    redirect_to collection_path, notice: "Tipo de Alumno(s) Modificada"
  end

  batch_action :generar_orden,  form: {
    tipo: %w[Fija Esporadica],
    estudiantes: (1..4).to_a,
    nueva: :checkbox,
    curso: :checkbox #:input_html => {:value => true}
    } do |ids,inputs|
    orders_return = {}
    students = Student.find(ids)
    students.each {|student| orders_return[student.id] = student.generate_order(current_admin_user.id, inputs)}
    no_generated = orders_return.select {|k,v| v!= 1 }
    if no_generated.empty?
      notice_text = "Ordenes Generadas sin fallos"
    else
      notice_text = "Error: Alumno(s) sin horario asignado"
    end
    redirect_to collection_path, notice: notice_text
  end

  batch_action :modificar_fechas, form: {
    inicia: :datepicker,
    termina: :datepicker
    } do |ids, inputs|
      students = Student.find(ids)
      students.each {|student| student.update_dates(inputs)}
      redirect_to collection_path, notice: "Fechas en Horarios Modificadas"
    end
=end




  index :title=> 'Estudiantes', download_links: [:csv]  do
    #selectable_column
    column 'Nombre', sortable: true    do |student|
      link_to student.name, admin_parent_path(student.parent.id)
    end
    column 'Colegio / Universidad', :school, sortable: true

    actions defaults: false do |student|
      link_to "Orden Nueva ", "#", id:"#{student.id}", class: 'modalOrder'# neworden_admin_student_path(student.id)# 
    end
=begin
    actions defaults: false do |student|
      if student.fixed
        link_to "Orden Predefinida", preload_admin_student_path(student)
      end
    end
=end
  end


  filter :name_cont, :label => 'Nombre'
  filter :parent_name_cont, :label => 'Acudiente'
  #filter :admin_user_email_cont, :label => 'Coordinador'
  filter :school_cont, :label => 'Colegio / Universidad'
  filter :grade, as: :select, :label => 'Grado'
  filter :calendar_schema, as: :select, :label => 'Calendario'
  filter :fixed, as: :select, collection: {"Fijo" => true,
    "Esporadico"=> false},:label => 'Tipo'

  sidebar :informacion_basica, only: :show do
    attributes_table_for student do
      row 'Fijo'       do student.is_fixed? end
      row 'Acudiente'  do
        link_to student.parent.name, admin_parent_path(student.parent.id)
      end
      row 'Telefono'   do student.parent.phone_main end
      row 'Colegio '   do student.school end
      row 'Calendario' do student.calendar_schema end
      row 'Curso'      do student.grade end
    end
  end

  # View - Show
  show :title => proc{|student| "#{student.name}"} do |f|

    if student.fixed
      panel 'Materias Fijas' do
        table_for student.materias do
          column "Materia", :name
          column "Resumen" do |materia|
            materia.schedule_hash_to_string
          end
          column "Tutor" do |materia|
            if materia.tutor.nil?
              "Pendiente"
            else
              materia.tutor.name
            end
          end
        end
      end
    end

    panel "Historico de Ordenes" do
    end

    active_admin_comments

  end

  action_item :preload  , only: :show do
    link_to "Orden Predefinida", preload_admin_student_path(resource)
  end
  action_item :neworden, only: :show do
    link_to 'Orden Nueva', neworden_admin_student_path(resource.id)
   end

  member_action :preload, method: :get do
    order = Order.preload_order(resource, current_admin_user.id)
    redirect_to edit_admin_order_path(order)
  end

  member_action :neworden, method: [:get,:post] do
    order = Order.create(renovate:params["sesiones fijas"],re_date:params["fecha final"], tarifa:params["tarifa"],student_id: resource.id, admin_user_id:current_admin_user.id)
    redirect_to edit_admin_order_path(order)
  end





  csv do
    column (:nombre) {|student| student.name}
    column (:email) {|student| student.email}
    column (:institucion) {|student| student.school}
    column (:grado) {|student| student.grade}
    column (:calendario) {|student| student.calendar_schema}
    column (:direccion) {|student| student.address}
    column (:telefono_alumno) {|student| student.phone}
    #column (:tipo) {|student| student.fixed}
    column (:acudiente_nombre) {|student| student.parent.name}
    column (:acudiente_email) {|student| student.parent.email}
    column (:acudiente_documento) {|student| student.parent.card_id_type+'-'+student.parent.card_id }
    column (:acudiente_telefono_fijo) {|student| student.parent.phone_main}
    column (:acudiente_telefono_celular) {|student| student.parent.phone_alt1}
    column (:acudiente_direccion) {|student| student.parent.address}
    column (:acudiente_subsidio) {|student| student.parent.subsidy_amount}
    column (:acudiente_alt_nombre) {|student| student.parent.name_alt}
    column (:acudiente_alt_email) {|student| student.parent.email_alt}
    column (:acudiente_alt_telefono) {|student| student.parent.phone_alt2}
    column (:acudiente_alt_direccion) {|student| student.parent.address_alt}
  end

end
