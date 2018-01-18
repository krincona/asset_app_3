class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  
  def calendar
     @student = Student.find(params[:id])
     #@mytutoria_instances = @student.tutoria_instances
    
  end


  # GET /students
  # GET /students.json
  def index
    if user_signed_in?
      if current_user.role != 2
        redirect_to root_path
      else
        @institute_user = InstituteUser.find_by user_id: current_user.id
        @institute = Institute.find(@institute_user.institute_id)
        #@students = Student.all

        @query = Student.where("institute_id = ?", @institute.id).ransack(params[:q])
        @institute_students = @query.result 
      end
    else
      redirect_to root_path
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
    @student = Student.find(params[:id])
    @horario = @student.horario
    if @student.horario.materias.empty?
      redirect_to edit_horario_path(@horario)
    end
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
      @student = Student.find(params[:id])
      @horario = @student.horario
      @horario.materias.build
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params[:student]
    end
end
