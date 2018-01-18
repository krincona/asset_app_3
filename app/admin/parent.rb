ActiveAdmin.register Parent do #, as: "Acudiente" do

  #active_admin_importable

  menu label: "Acudientes", parent: "Usuarios"

  #config.sort_order = 'name_asc'
  config.sort_order = 'updated_at_desc'

  config.per_page = 30



    permit_params :name,:card_id, :card_id_type, :email, :phone_main, :student_id,
  :payment, :address, :phone_alt1, :phone_alt2, :subsidy_amount, :address_comment,
  :email_alt, :name_alt,
  :students_attributes  => [:id,:name, :email, :phone, :school, :grade, :address,
  :calendar_schema, :admin_user_id,:fixed,:_destroy]

# Index

  index :title => 'Acudientes', download_links: false do
    selectable_column
    column 'Nombre', sortable: true do |parent|
      link_to(parent.name, admin_parent_path(parent))
    end
    column 'Correo Electronico', :email
    column 'Telefono Fijo', :phone_main
    column 'Celular', :phone_alt1
    column 'Subsidio' do |parent|
      number_to_currency(parent.subsidy_amount,:unit => '$', :precision => 0, :format => '%u%n' )
    end
    #column 'Estudiantes', :number_of_students
    #actions

  end

  filter :name_cont,  :label => 'Nombre'
  filter :email_cont, :label => 'Correo Electronico'
  filter :phone_main_cont, :label => 'Telefono Fijo  '
  filter :phone_alt1_cont, :label => 'Celular'




# New and Edit
  form :title => {:new=>'Nuevo Acudiente'} do |f|
    f.inputs "Informacion Basica" do
      f.semantic_errors *f.object.errors.keys
      if f.object.new_record?
        f.object.subsidy_amount = 0
        f.object.card_id_type = 'c.c.'
      end
      f.input :name, label: 'Nombre Completo', required: true
      f.input :card_id, as: :string, label: 'Documento de Identidad', required: true
      f.input :card_id_type, as: :select, collection: ['c.c.','c.e.','nit','Pasaporte','Otro'], required: true, label:"Tipo Documento de Indentidad"
      f.input :email, label: 'Correo Electronico', required: true
      f.input :address, label: 'Direccion Facturacion', required: true
      f.input :address_comment, label: 'Comentarios Direccion',  :input_html => { :size =>'10px'}

      f.input :subsidy_amount, as: :number, label: 'Subsido de Transporte',
      required: true, :input_html => {:min => 0, :max => 10000,:step=>1000}
      f.input :phone_main, label: 'Telefono Fijo', required: true
      f.input :phone_alt1, label: 'Celular', required: true
      #f.input :payment, as: :hidden, :input_html => {:check => true}
      #f.input :phone_alt2, label: 'Telefono Alternativo'
    end
    f.inputs "Informacion Acudiente Alternativo" do
      f.input :name_alt, label: "Nombre"
      f.input :email_alt,label: "Correo Electronico"
      f.input :phone_alt2, label: 'Telefono Alternativo'

    end

    f.inputs do
      f.has_many :students, :allow_destroy => true, :heading => "Agregar Estudiante Nuevo", :new_record => true do |cf|
        cf.input :name,  label: 'Nombre Completo', required: true
        cf.input :email, label:  'Correo Electronico'
        cf.input :phone, label: 'Celular'
        #cf.input :address, label: 'Direccion', required: true
        cf.input :school, label: 'Institucion', required: true
        cf.input :grade,  label: 'Grado', required: true
        cf.input :calendar_schema, as: :select, collection: ["A","B","S"], label: 'Calendario', required: true
        cf.input :fixed, label:"Fijo?"
        #cf.input :admin_user_id, as: :hidden,:input_html => {:value => current_admin_user.id}
      end
    end
    f.actions
  end

#Show

  show :title => proc{|parent| parent.name} do
    attributes_table do
      row (:documento_identidad) {|parent| " #{parent.card_id_type} - #{parent.card_id} "}
      row (:correo_electronico) {|parent| parent.email}
      row (:direccion) {|parent| parent.address}
      row (:telefono_celular) {|parent| parent.phone_alt1}
      row (:telefono_fijo) {|parent| parent.phone_main}
      row (:subsidio) {|parent| number_to_currency(parent.subsidy_amount,:unit => '$', :precision => 0, :format => '%u%n' )}
    end

    panel 'Contacto Alternativo' do
      attributes_table_for resource do
        row 'Nombre' do resource.name_alt end
        row 'Correo Electronico' do resource.email_alt end
        row 'Telefono' do resource.phone_alt2 end
      end
    end

    panel 'Estudiantes' do
      table_for resource.students  do
        #column 'Nombre' do |student|
          #link_to student.name, admin_student_path(student.id)
        #end
        column 'Nombre', :name
        column 'Email', :email
        column 'Celular', :phone
        column 'Institucion', :school
        column 'Grado', :grade
        column 'Calendario', :calendar_schema
        #column 'Estado'
        #column 'Hora Activa'
      end

    end

    active_admin_comments

  end

  controller do
    def edit
      @page_title = "Añadir Acudiente"
    end
  end


end
