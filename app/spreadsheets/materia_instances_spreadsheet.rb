class MateriaInstancesSpreadsheet
  attr_accessor :materia_instances

  def initialize materia_instances
    @materia_instances = materia_instances
  end


  def generate_xls
    book = Spreadsheet::Workbook.new
    sheet_instances    = book.create_worksheet name: "programacion"
    sheet_tutor     = book.create_worksheet name: "terceros"

    sheets = [sheet_instances,sheet_tutor]

    sheets[0].row(0).concat ["Programacion materias"]
    sheets[0].row(1).concat %w[#id #orden materia fecha estudiantes tutor alumno duracion valor_hora valor_subsidio valor_sesion]
    sheets[0].row(0).default_format = Spreadsheet::Format.new weight: :bold
    sheets[0].row(1).default_format = Spreadsheet::Format.new weight: :bold


    sheets[1].row(0).concat ["Solicitudes de reintegro de ingresos para terceros"]
    sheets[1].row(1).concat ["Por concepto de materias"]
    sheets[1].row(3).concat %w[Nombre Cedula #Orden Valor_Orden Subtotal Costo_Bancario Multas Total_Reintegro Fecha Cuenta]
    sheets[1].row(0).default_format = Spreadsheet::Format.new weight: :bold
    sheets[1].row(1).default_format = Spreadsheet::Format.new weight: :bold
    sheets[1].row(3).default_format = Spreadsheet::Format.new weight: :bold



    create_body sheets

    data_to_send = StringIO.new
    book.write data_to_send
    data_to_send.string
  end


  def create_body sheets
    tutors = {}


    instance_index = 2
    materia_instances.each do |instance|


      sheets[0].row(instance_index).concat [instance.id,instance.order.serial,instance.materia.name,instance.at_date,
      instance.students_number,instance.id,instance.student.name,instance.duration,instance.tutor_payable/instance.duration,
      instance.subsidy,instance.total_payable ]

      instance_index+=1
    end

    materia_instances.each do |instance|

      #month = instance.order.for_month
      serial = instance.order.serial
      tutor = instance.tutor
      #per_hour = tutor
=begin
      if instance.materia.univ
        per_hour = 23000
      else
        if instance.students_number == 1
          per_hour = tutor.nil? ? 18000 : tutor.hourly_rate
        elsif instance.students_number > 1
          per_hour = 23000
        end
      end
=end

      subtotal = instance.tutor_payable #instance.duration*per_hour + instance.subsidy

      tutors[:pending]={nombre:"Sin Asignar",cedula:"N/A",ordenes:{}}

      if !instance.tutor.nil?
        if !tutors.has_key? tutor.id
          tutors[tutor.id]={nombre:tutor.name,cedula:tutor.card_id,ordenes:{serial=>subtotal}}
        else
          ordenes = tutors[tutor.id][:ordenes]
          if !ordenes.has_key? serial
            ordenes[serial] = subtotal
          else
            ordenes[serial] += subtotal
          end
        end
      else
        ordenes = tutors[:pending][:ordenes]
        if !ordenes.has_key? serial
          ordenes[serial] = subtotal
        else
          ordenes[serial] += subtotal
        end
      end
    end

    tutor_index = 4
    tutors.each do |key,value|
      sheets[1].row(tutor_index).concat [value[:nombre],value[:cedula]," "," ",total_sum(value[:ordenes])]
      tutor_index += 1
      value[:ordenes].each do |key2,value2|
        sheets[1].row(tutor_index).concat [" "," ",key2,value2]
        tutor_index += 1
      end

    end
  end

  def total_sum subtotals
    total = 0
    subtotals.each {  |key,value| total+= value}
    return total
  end


end