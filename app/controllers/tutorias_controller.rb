class TutoriasController < ApplicationController

  def show
    @tutoria = Tutoria.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tutoria }
    end

  end


  def index
    @tutor = Tutor.find(current_user.user_role_id)
    @query = Tutoria.where("status = 'avaible' ").ransack(params[:q])
    @avaible_tutorias = @query.result
  end

  def relist
    @query = Tutoria.where("status = 'avaible' ").ransack(params[:q])
    @avaible_tutorias = @query.result
    render :partial => "tutorias/list"
  end

  def postulate
    @tutor = Tutor.find(current_user.user_role_id)
    @tutoria = Tutoria.find(params[:id])
    @tutoria.update_postulate(@tutor.id)
    @tutoria.order.student.update_materia(@tutoria.subject,@tutor.id)
    #order = Order.find(@tutoria.order_id)
    #order.update_postulate(current_tutor.id)
    redirect_to tutorias_path, notice: "Tutoria Reservada"

  end


end
