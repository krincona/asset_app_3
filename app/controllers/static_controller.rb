class StaticController < ApplicationController

  def board
    if user_signed_in? && current_user.role == 3
      @tutor = Tutor.find(current_user.user_role_id)
      @query = Materia.publicables.ransack(params[:q])
      @materias_publicables = @query.result
    else
      redirect_to static_price_path()
    end
  end


  def home
    if !user_signed_in?
      redirect_to user_session_path
    else
      #if current_user.role == 2 # Institute User
        #redirect_to students_path
      if current_user.role == 3 # Tutor
        redirect_to static_board_path
      elsif current_user.role == 1 # Parent
        redirect_to static_home_parent_path
      end
    end

  end
  def home_tutor
    if !tutor_signed_in?
      redirect_to tutor_session_path
    else
      redirect_to tutorias_path
    end
  end


  def home_parent
    if !current_user.user_role_id.nil?
      redirect_to parent_path(current_user.user_role_id)
    else
      redirect_to new_parent_path
    end
  end

  def help
  end
end
