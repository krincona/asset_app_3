ActiveAdmin.register Tutor do
  menu label: "Tutores", parent: "Usuarios"

  #active_admin_importable

  config.sort_order = 'name_asc'

  batch_action :cuenta_de_cobro, form: {
    inicia: :datepicker,
    termina: :datepicker
  } do |ids, inputs|
    tutors = Tutor.find(ids)
    data= {}
    tutors.each {|tutor| data[tutor.name]=tutor.balance(inputs)}
    respond_to do |format|
      format.csv { send_data Tutor.balance_to_csv(data) }
    end
    redirect_to collection_path, notice: "Cuentas Generadas"
  end



  #Model
  permit_params :name, :card_id, :email, :password, :password_confirmation, :status,:non_fixed,
  :homephone, :cellphone, :university, :major, :grade, :category, :level,
  :specific_experience,:school_experience,:language_experience => [],
  :profile =>[],:tutor_slots_attributes =>  [:id,:day,:from_hour_hour,:from_hour_minute,
  :to_hour_hour,:to_hour_minute, :tutor_id,:_destroy]

  # New and Edit
  form only: :new do |f| 

    f.inputs "Informacion Personal" do
      f.input :name,  label: "Nombre Completo"
      f.input :card_id, label: "Cedula de Ciudadania"
      f.input :homephone, label: "Telefono Fijo"
      f.input :cellphone, label: "Telfono Celular"
      f.input :university, label: "Universidad"
      f.input :major, label: "Carrera"
      f.input :grade, label: "Semestre"
      if f.object.new_record?
        f.input :email, label: "Correo Electronico"
        f.input :password, label: "Contraseña"
        f.input :password_confirmation, label: "Confirmar Contraseña"
      end
    end

    f.inputs "Informacion Academica" do
      f.object.non_fixed ||= false
      f.input :status, label: "Activo"
      f.input :non_fixed, label: "Solo Esporadicas"
      f.input :category, as: :select, collection: [1,2,3], label:'Categoria'
      f.input :level, as: :select, collection: Tutor::Levels,
              label: 'Nivel'
      f.input :profile, as: :check_boxes,
              collection: TutoriaInstance::SUBJECTS,label: 'Materias'
      f.input :specific_experience,label: 'Experto dictando'
      f.input :school_experience,label: 'Colegios con los que ha trabajado'
      f.input :language_experience, as: :check_boxes, collection: ["Ingles","Frances"],label: 'Puede dictar tutorias en'
    end
    f.actions
  end

# Index

  scope :activos, :default => true
  scope :inactivos

  index :title=> 'Tutores', download_links: [:csv] do
    selectable_column
    column "Nombre", sortable: true do |tutor|
      link_to(tutor.name, admin_tutor_path(tutor))
    end
    column "Disponibilidad" do |t|
      if t.non_fixed
        status_tag "Esporadicas", :warn
      else
        status_tag "Espo/Fijas", :ok
      end
    end
    #column "Activo", :status
    #column "Universidad", :university
    column "Carrera", :major
    column "Telefono Celular", :cellphone
    column "Correo Electronico",:email
=begin
    column "Categoria" do |tutor|
      number_to_currency(Tutor::CATEGORY[tutor.category], :unit=>'$',
      :format => '%u%n',:precision=>0)
    end
=end
    column "Nivel" , :level
    #column "Bilingue?", :is_bilingual?
    #actions
  end

  filter :name_cont, :label => "Nombre"
  filter :profile_contains, as: :select, collection: TutoriaInstance::SUBJECTS,
         multiple: true, :label => "Materias"
  filter :non_fixed,  as: :select, collection: {"Esporadicas": true, "Espo/Fijas": false},:label => "Disponibilidad"
  #filter :category, as: :select, collection: [1,2,3], :label=> "Categoria"
  filter :level, as: :select, collection: Tutor::Levels, multiple: true,
         :label => 'Nivel'
  #filter :university_cont, :label => "Universidad"
  filter :major_cont , :label => "Carerra"

  show :title => proc{|tutor| "#{tutor.name}"} do
    columns do
      column do
        panel "Datos de contacto" do
          attributes_table_for tutor do
            row 'Activo' do 
              if tutor.status 
                status_tag "Si", :ok
              else
                status_tag "No", :error
              end
            end
            row 'Disponibilidad' do 
              if tutor.non_fixed 
                status_tag "Esporadicas", :warn
              else
                status_tag "Espo/Fijas", :ok
              end
            end 
            row 'Cedula de Ciudadania' do tutor.card_id end 
            
            row 'Correo Electronico' do tutor.email end
            row 'Telefono Fijo' do tutor.homephone end
            row 'Telefono Celular' do tutor.cellphone end
          end
        end
      end
      column span:2 do
        panel "Datos Academicos" do
          attributes_table_for tutor do
            row 'Carrera' do tutor.major end
            row 'Universidad' do tutor.university end
            row 'Experto dictando' do tutor.specific_experience end
            row 'Colegios con los que ha trabajado' do tutor.language_experience end
            row 'Puede dictar tutorias en' do tutor.school_experience end
          end
        end
      end 
    end    
  end

end
