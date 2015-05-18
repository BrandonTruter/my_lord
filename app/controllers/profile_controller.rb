class ProfileController < ApplicationController
  before_action :find_user
  
  def index
    if @user.profile.nil?
      redirect_to new_user_profile_path(@user.id)
    else
      redirect_to user_profile_path(@user.id, @user.profile.id)
    end
  end
  
  def show
    # @profile = @user.profile.empty? ? @user.profile.new : @user.profile.find(params[:id])
    @profile = @user.profile.find(params[:id])
  end  

  def new
    # @profile = @user.profile.new
    @profile = Profile.new
  end
  
  def create
    # @profile = @user.profile.
  end

  def edit
  end

  def update
  end
  
  private
  
  def find_user
    @user = params[:user_id].nil? ? current_user : User.find(params[:user_id])
  end

  # def profile_params
    # params.require(:scripture).permit(:title, :reference, :verse)
  # end
end
