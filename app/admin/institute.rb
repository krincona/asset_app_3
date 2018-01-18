ActiveAdmin.register Institute do
  menu label: "Colegios", parent: "Usuarios"


  #Model
  permit_params :name,:calendar_schema,:address, :pbx, 
  :institute_users_attributes => [:id,:name,:user_id, :contact_phone,:position,:institute_id,:email,:card_id,:_destroy]

  index :title => 'Colegios Activos', download_links: [:csv] do

    selectable_column
    column "ID", :id
    column "Nombre" do |c|
     link_to(c.name, admin_institute_path(c))
   end
    column "Calendario", :calendar_schema
    column "Direccion", :address
    column "Telefono", :pbx

  end

  filter :name, :label => 'Nombre'
  filter :calendar_schema,as: :select, :label => 'Calendario'

  # View - New + Edit

  form :title =>  {:new=>'Nuevo Colegio'} do |f|
    f.inputs "Datos de Contacto" do
      f.input :name, label: "Nombre", required: true
      f.input :calendar_schema, as: :select, collection: ["A","B","Uni"], label: "Calendario", required: true
      f.input :pbx, label:"Telefono principal"
      f.input :address, label: "Direccion"
    end    
    f.inputs do
      f.has_many :institute_users, :allow_destroy => true, :heading => "Agregar Funcionario", :new_record => true do |cf|
        cf.input :name, label: "Nombre"
        cf.input :card_id, label: "Documento Identidad"
        cf.input :email, label: "Correo Electronico"
        cf.input :contact_phone, label: "Telefono Contacto"
        cf.input :position, label: "Cargo/Titulo"
      end
    end
    f.actions
  end

  show  do
    columns do
      column do
        panel "Informacion Basica" do
          attributes_table_for institute do
            row 'Nombre' do institute.name end
            row 'Calendario' do institute.calendar_schema end
            row 'Telefono Principal' do institute.pbx  end
            row 'Direccion' do institute.address end
          end
        end 
      end
      column span:2 do
        panel "Datos Funcionarios" do 
          table_for institute.institute_users do
            column "Nombre", :name
            column "Documento Identidad", :card_id
            column "Correo Electronico", :email
            column "Telefono Contacto", :contact_phone
            column "Cargo/Titulo", :position
          end
        end
      end      
    end 
    panel 'Alumnos Activos' do
      table_for institute.students do
        column "Nombre", :name
        column "Curso", :grade        
        column "Acudiente" do |student|
          student.parent.name 
        end
      end
    end
  end
end