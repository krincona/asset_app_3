class ParentMailer < ActionMailer::Base
  add_template_helper(EmailHelper)
  default from: "contacto@asset-tutores.com",
          cc: "contacto@asset-tutores.com, jprincon@asset-tutores.com"


  def parent_reserved_notification(order)

    @order = order
    @student = order.student
    @parent = @student.parent
    #@admin = @order.admin_user
    @greeting = " #{@parent.name} y #{@student.name}"

    mail(to: @parent.email, subject: "Orden de Tutorias Reservada",
         cc: ["contacto@asset-tutores.com", "jprincon@asset-tutores.com", "asistencia@asset-tutores.com"])
  end


  def parent_confirmation_notification(order)
    @order    = order
    @student  = order.student
    @parent   = @student.parent
    @admin    = @order.admin_user
    @greeting = " #{@parent.name} y #{@student.name}"


    mail(to: @parent.email, subject: "Orden de Tutorias Confirmada",
      cc: ["contacto@asset-tutores.com", "jprincon@asset-tutores.com","asistencia@asset-tutores.com"] )
  end

end
