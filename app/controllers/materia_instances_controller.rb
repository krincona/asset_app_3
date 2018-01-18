class MateriaInstancesController < ApplicationController
  before_action :set_materia_instance, only: [:show, :edit, :update, :destroy]

  # GET /materia_instances
  # GET /materia_instances.json
  def index
    @materia_instances = MateriaInstance.all
  end

  # GET /materia_instances/1
  # GET /materia_instances/1.json
  def show
    @student = @materia_instance.materia.order.student
  end

  # GET /materia_instances/new
  def new
    @materia_instance = MateriaInstance.new
  end

  # GET /materia_instances/1/edit
  def edit
  end

  # POST /materia_instances
  # POST /materia_instances.json
  def create
    @materia_instance = MateriaInstance.new(materia_instance_params)

    respond_to do |format|
      if @materia_instance.save
        format.html { redirect_to @materia_instance, notice: 'Materia instance was successfully created.' }
        format.json { render :show, status: :created, location: @materia_instance }
      else
        format.html { render :new }
        format.json { render json: @materia_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /materia_instances/1
  # PATCH/PUT /materia_instances/1.json
  def update
    respond_to do |format|
      if @materia_instance.update(materia_instance_params)
        format.html { redirect_to @materia_instance, notice: 'Materia instance was successfully updated.' }
        format.json { render :show, status: :ok, location: @materia_instance }
      else
        format.html { render :edit }
        format.json { render json: @materia_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /materia_instances/1
  # DELETE /materia_instances/1.json
  def destroy
    @materia_instance.destroy
    respond_to do |format|
      format.html { redirect_to materia_instances_url, notice: 'Materia instance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_materia_instance
      @materia_instance = MateriaInstance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def materia_instance_params
      params.fetch(:materia_instance, {})
    end
end
