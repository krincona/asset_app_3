class MateriasController < ApplicationController

  #custom controllers
  def tutor_postulation
    @tutor   = Tutor.find(current_user.user_role_id)
    @materia = Materia.find(params[:id])

    if @materia.postulation_updates(@tutor.id)
      message = "¡Super! La tutoria fue reservada en tu calendario"
    else
      message = "Estas cosas pasan. Otro tutor ya tomó esta tutoria."
    end
    respond_to do |format|
      format.html {redirect_to static_board_path, :notice=> message}
    end

  end

  #standard controllers
  def new
    @order = Order.find(params[:order_id])
    @materia = @order.materias.build
    @materia.name = params["name"]
    @materia_instance = @materia.materia_instances.build
    @url = order_materias_path

    respond_to do |format|
      format.html
      format.js
      #format.json { render json: @materias }
    end
  end

  def create
    @order = Order.find(params[:order_id])
    @materia = @order.materias.create(materia_params)
    @materia.student_id = @order.student_id

    respond_to do |format|
      if @materia.save
        @order.calc_serial
        format.html {redirect_to order_materias_path(@materia.order,@materia), :notice=> 'Materia Agregada'} # show.html.erb
        format.js
      #format.json { render json: @materia }
      else
        format.html {render :action=> "new"}
        format.js
      end

    end
  end

  def index
    @parent = Parent.find(current_user.user_role_id)
    @order = Order.find(params[:order_id])
    @materias = @order.materias

    respond_to do |format|
      format.html
      format.js
      #format.json { render json: @materias }
    end
  end

  def edit
    @order   = Order.find(params[:order_id])
    @materia = @order.materias.find(params[:id])
    @url     = order_materia_path(@materia.order,@materia)

    respond_to do |format|
      format.html # show.html.erb
      format.js
      #format.json { render json: @materia }
    end
  end

  def update
    @order = Order.find(params[:order_id])
    @materia = @order.materias.find(params[:id])

    respond_to do |format|
      if  @materia.update(materia_params)
        @order.calc_serial
        format.html {redirect_to([@materia.order, @materia], :notice => 'Materia Actualizada')}
        format.js
      else
        format.html {render :action => "edit"}
      end
    end
  end

  def show
    order = Order.find(params[:order_id])
    @materia = order.materias.find(params[:id])


    respond_to do |format|
      format.html # show.html.erb
      format.js

      #format.json { render json: @materia }
    end
  end

  def destroy
    order = Order.find(params[:order_id])
    @materia = order.materias.find(params[:id])
    @materia.destroy
    order.save!

    respond_to do |format|
      format.html {redirect_to(order_materias_path(order))}
    end
  end

  private

    def materia_params
      params.require(:materia).permit(:id,:name, :topic, :order_id,:weekly, :_destroy, :students_number,
        materia_instances_attributes: [:id,:tutor_id,:duration,:at_date,
        :at_time,:materia_id,:_destroy])
    end

=begin
  def index
    @query = Materia.where("TUTOR_ID IS null").ransack(params[:q])
    @avaible_materias = @query.result
  end

  def relist
    @query = Materia.where("TUTOR_ID IS null").ransack(params[:q])
    @avaible_materias = @query.result
    render :partial => "materias/list"
  end

  def postulate
    @materia = Materia.find(params[:id])
    @materia.update_postulate(current_tutor.id)
    redirect_to materias_path, notice: "Materia Reservada"

  end
=end
end
