class TutoriaInstancesController < ApplicationController

	def show
	    @tutoria = TutoriaInstance.find(params[:id])
	    @tutor = Tutor.find(@tutoria.tutor)

	    respond_to do |format|
	      format.html # show.html.erb
	      format.json { render json: @tutoria }
    end

    def event_params
  		params.require(:event).permit(topic,:tutor_id,:tutoria_id,:duration,:order_id,:status,:student_id,:subject,:serial,:student_number,
                    :at_date,:at_time,:recurrence,:copy,:extra_horario_id, schedule_attributes: Schedulable::ScheduleSupport.param_names)
	end

  end
end
