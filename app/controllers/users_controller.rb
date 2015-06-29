class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @page_title = "#{@user.middle_name} Page"
  end
  
  def destroy
    if params[:id] == "sign_out"
      redirect_to destroy_user_session_path
    else
      @user = User.find(params[:id])
      @user.destroy

      redirect_to :back
    end
  end
  
end
