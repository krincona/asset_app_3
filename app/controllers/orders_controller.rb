class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]



  def find_tutor
    order = Order.find(params[:id])
    order.publish_materias
    #order.send_status_email

    respond_to do |format|
      format.html{redirect_to static_home_parent_path(order),notice: "¡Eso es todo! Ahora solo debes esperar la confirmación en tu email y podras revisar tus tutorias en el calendario "}
      format.js
      #format.json { render json: @materias }
    end

  end


  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @parent = Parent.find(current_user.user_role_id)
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(student_id:params[:student_id], tarifa:params[:tarifa])

    respond_to do |format|
      if @order.save
        format.html { redirect_to order_materias_path(@order), notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:student_id,:tarifa, :status, :re_date, :for_month,:payment_ref,
                    :payment_dateline, :init_cost, :renovate, :serial, :active, :admin_user_id,
                    :payment_date, :curso, materias_attributes:[:id,:name, :wdays, :at_time, :ocurrence,:student_id,
                    :duration,:horario_id,:topic,:tutor_id,:order_id,:at_date,:_destroy])
    end
end
