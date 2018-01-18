class InstituteUsersController < ApplicationController
  before_action :set_institute_user, only: [:show, :edit, :update, :destroy]

  # GET /institute_users
  # GET /institute_users.json
  def index
    @institute_users = InstituteUser.all
  end

  # GET /institute_users/1
  # GET /institute_users/1.json
  def show
  end

  # GET /institute_users/new
  def new
    @institute_user = InstituteUser.new
  end

  # GET /institute_users/1/edit
  def edit
  end

  # POST /institute_users
  # POST /institute_users.json
  def create
    @institute_user = InstituteUser.new(institute_user_params)

    respond_to do |format|
      if @institute_user.save
        format.html { redirect_to @institute_user, notice: 'Institute user was successfully created.' }
        format.json { render :show, status: :created, location: @institute_user }
      else
        format.html { render :new }
        format.json { render json: @institute_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /institute_users/1
  # PATCH/PUT /institute_users/1.json
  def update
    respond_to do |format|
      if @institute_user.update(institute_user_params)
        format.html { redirect_to @institute_user, notice: 'Institute user was successfully updated.' }
        format.json { render :show, status: :ok, location: @institute_user }
      else
        format.html { render :edit }
        format.json { render json: @institute_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /institute_users/1
  # DELETE /institute_users/1.json
  def destroy
    @institute_user.destroy
    respond_to do |format|
      format.html { redirect_to institute_users_url, notice: 'Institute user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_institute_user
      @institute_user = InstituteUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def institute_user_params
      params.fetch(:institute_user, {})
    end
end
