class ParentsController < ApplicationController

  #custom controllers

  def parent_calendar
    @parent = Parent.find(current_user.user_role_id)
    @students = @parent.students
    @materia_instances = @parent.materia_instances

    respond_to do |format|
      format.html
      format.js
    end
  end


  def show
    @parent = Parent.find(current_user.user_role_id)
    @students = @parent.students
    #@materia_instances = @parent.students_materia_instances
    @order = Order.new
    @order.materias.build
    #@student = Student.find(params[:student_id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def index
    @parents = Parent.all
  end

  def edit
    @parent = Parent.find(params[:id])
  end

  def update
    @parent = Parent.find(params[:id])

    respond_to do |wants|
      if @parent.update_attributes(parent_params)
        flash[:notice] = 'Perfil Actualizado.'
        wants.html { redirect_to(@parent) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @parent.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new
    @parent = Parent.new
    @parent.students.build
  end

  def create
    @parent = Parent.new(parent_params)
    @parent.email = current_user.email
    @parent.user_id = current_user.id


    respond_to do |format|
      if @parent.save
        current_user.update_attribute :user_role_id, @parent.id
        format.html { redirect_to @parent, notice: '¡Has creado tu perfil!.' }
        format.json { render :show, status: :created, location: @parent }
      else
        format.html { render :new }
        format.json { render json: @parent.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_session
    @parent = Parent.find(params[:id])
    @students = @parent.students

    respond to do |format|
      format.html
      format.json {render json: @parent}
    end
  end

  def parent_params
    params.require(:parent).permit(:name,:email, :card_id, :payment,:address,
    :phone_alt1, :phone_alt2, :phone_main, :card_id_type, :subsidy_amount,
    :email_alt, :address_alt, :address_comment,
    students_attributes:[:id,:name, :email, :phone, :school, :grade, :address,
    :calendar_schema, :admin_user_id,:fixed,:_destroy])
  end
end