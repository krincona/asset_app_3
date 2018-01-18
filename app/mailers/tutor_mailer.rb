class TutorMailer < ActionMailer::Base
  add_template_helper(EmailHelper)
  default from: "contacto@asset-tutores.com",
          cc: "contacto@asset-tutores.com, jprincon@asset-tutores.com"


  def tutor_confirmation_notification(materia,tutor_id)
    @materia  = materia
    @tutor   = Tutor.find(tutor_id)
    @materia_instances = @materia.materia_instances.select {|inst| inst.tutor_id==@tutor.id }
    @student  = materia.order.student
    @greeting = "#{@tutor.name}"

    puts @tutor.email
    mail(to:@tutor.email, subject:"Confirmación Tutorias", 
      cc:["contacto@asset-tutores.com", "jprincon@asset-tutores.com"])
  end

end