class TutoriaMailer < ActionMailer::Base
  add_template_helper(EmailHelper)
  default from: "contacto@asset-tutores.com", 
          cc: "contacto@asset-tutores.com, asistencia@asset-tutores.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.tutoria_mailer.parent_reserved_notification.subject
  #
  def parent_reserved_notification(order)

    @order = order
    @student = order.student
    @parent = @student.parent
    @admin = order.admin_user
    @greeting = " #{@parent.name} y #{@student.name}"

    mail(to: @parent.email, subject: "Orden de Tutorias Reservada", 
         cc: [@admin.email,"contacto@asset-tutores.com", "asistencia@asset-tutores.com"])
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.tutoria_mailer.tutor_reserved_notification.subject
  #
  def tutor_reserved_notification
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.tutoria_mailer.parent_confirmation_notification.subject
  #
  def parent_confirmation_notification(order)
    @order    = order
    @student  = order.student
    @parent   = @student.parent
    @admin    = order.admin_user
    @greeting = " #{@parent.name} y #{@student.name}"


    mail(to: @parent.email, subject: "Orden de Tutorias Confirmada", 
      cc: [@admin.email,"contacto@asset-tutores.com", "asistencia@asset-tutores.com"] )
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.tutoria_mailer.tutor_confirmation_notification.subject
  #
  def tutor_confirmation_notification(tutoria)
    @tutoria  = tutoria
    @tutor    = tutoria.tutor
    @student  = tutoria.student
    @admin    = tutoria.order.admin_user
    @greeting = "#{@tutor.name}"


    mail(to: @tutor.email, subject: "Confirmacion Tutorias", cc: @admin.email )
  end
end
