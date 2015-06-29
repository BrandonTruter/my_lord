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
    @profile = Profile.new
  end
  
  def create
    @profile = Profile.new(profile_params)
    @profile.user = @user.id
    
    if @profile.save
      
      redirect_to user_profile_path(@user.id, @profile.id)
    else
      render :new
    end
  end

  def edit
  end

  def update
  end
  
  private
  
  def find_user
    @user = params[:user_id].nil? ? current_user : User.find(params[:user_id])
  end
  
  protected

  def profile_params
    params.require(:scripture).permit(:middle_name, :language, :phone, :gender, :date_of_birth, :qualifications, :net_salary, :company, :position, :occupation, :married, :family_size, :spouse_first_name, :spouse_last_name, :spouse_occupation, :street_number, :street_name, :suburb, :city, :province, :postal_code)
  end
  
end
