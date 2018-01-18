class TutorsController < ApplicationController

  def profile
    @tutor = Tutor.find(params[:id])
  end

  def account
    @tutor = Tutor.find(params[:id])
    @materia_instances = @tutor.payable_materia_instances
    if @materia_instances.empty?
      redirect_to static_home_path, notice: "No tienes horas pendientes por cobrar"
    end
  end

  def account_acceptance
    @tutor = Tutor.find(current_user.user_role_id)
    @tutor.payable_materia_instances.each {|inst| inst.tutor_payable_acceptance}
    redirect_to static_home_path, notice: "Relacion de horas enviada"
  end

  def show
    if user_signed_in?
      @tutor = Tutor.find(params[:id])
      @mytutoria_instances = @tutor.materia_instances

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @tutor }
      end

    else
      redirect_to root_path
    end
  end
=begin
  def recal
    @tutor = Tutor.find(current_tutor.id)
    @mytutoria_instances = @tutor.tutoria_instances

    render :partial => "tutors/calendar"

  end
=end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_session
    @tutor = Tutor.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def session_params
    params.require(:session).permit(:name, profile:[] )
  end
end
