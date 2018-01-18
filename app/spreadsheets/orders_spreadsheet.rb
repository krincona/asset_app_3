class OrdersSpreadsheet
  attr_accessor :orders

  def initialize orders
    @orders = orders
  end

  def generate_xls
    book = Spreadsheet::Workbook.new
    sheet_order    = book.create_worksheet name: "ordenes"
    sheet_tutor    = book.create_worksheet name: "pagos_tutores"
    
    sheets = [sheet_order,sheet_tutor]

    create_body sheets

    data_to_send = StringIO.new
    book.write data_to_send
    data_to_send.string
  end

  def create_body sheets
    # Header row with specific format
    

    sheets[0].row(0).concat ["Comprobantes de ingreso"]
    sheets[0].row(1).concat %w[Consecutivo ReferenciaPago FechaPago Estado Estudiante Cliente DocumentoCliente Horas ValorHora CreacionPlan Subsidio Tutoria Total ServicioCoord Impuesto TotalFinal ]
    sheets[0].row(0).default_format = Spreadsheet::Format.new weight: :bold
    sheets[0].row(1).default_format = Spreadsheet::Format.new weight: :bold
=begin
    sheets[1].row(0).concat ["Solicitudes de reintegro de ingresos para terceros"]
    sheets[1].row(1).concat ["Por concepto de tutorias dictadas en el mes de "]
    sheets[1].row(3).concat %w[Nombre Cedula Periodo #Orden Valor_Orden Subtotal Costo_Bancario Multas Total_Reintegro Fecha Cuenta]
    sheets[1].row(0).default_format = Spreadsheet::Format.new weight: :bold
    sheets[1].row(1).default_format = Spreadsheet::Format.new weight: :bold
    sheets[1].row(3).default_format = Spreadsheet::Format.new weight: :bold
=end

    #tutors = {}


    order_index = 2

    orders.each do |order|
      sheets[0].row(order_index).concat [order.serial, order.payment_ref,order.payment_date, order.status,order.student.name, 
        order.student.parent.name, order.student.parent.card_id, order.total_hours_all,order.hourly_cost,order.init_cost_value,
        order.subsidy_total,order.tutors_total_amount,order.tutors_total_amount  + order.subsidy_total, order.coord_service,
        order.tax,order.monthly_total_cost + order.subsidy_total]
      order_index += 1
    end
=begin
    Tutoria.payable_tutorias.each do |tutoria|
      if !tutoria.tutor.nil?
        serial = order.serial
        tutor = tutoria.tutor
        per_hour = Tutor::CATEGORY[tutor.category]
        subtotal = tutoria.hours*per_hour + tutoria.sessions*tutoria.student.parent.subsidy_amount
        month = I18n.l tutoria.first_session , format: "%B %Y"

        if !tutors.has_key? tutor.id
          tutors[tutor.id]={nombre:tutor.name,cedula:tutor.card_id,periodo:month,ordenes:{serial=>subtotal}}
        else
          ordenes = tutors[tutor.id][:ordenes]
          if !ordenes.has_key? order.serial
            ordenes[order.serial] = subtotal
          else
            ordenes[order.serial] += subtotal
          end
        end
      end
    end
      

    tutor_index = 4
    tutors.each do |key,value|
      sheets[1].row(tutor_index).concat [value[:nombre],value[:cedula],value[:periodo]," "," ",total_sum(value[:ordenes])]
      tutor_index += 1
      value[:ordenes].each do |key2,value2|
        sheets[1].row(tutor_index).concat [" "," "," ",key2,value2]
        tutor_index += 1
      end

    end
=end
  end

  def total_sum subtotals
    total = 0
    subtotals.each {  |key,value| total+= value}
    return total
  end
end