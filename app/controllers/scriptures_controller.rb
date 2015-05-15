class ScripturesController < ApplicationController
  before_action :find_user
  
  def index
    @scriptures = Scripture.all
  end

  def show
    @scripture = @user.scriptures.find(params[:id])
  end
  
  def new
    @scripture = Scripture.new
  end
  
  private
  
  def find_user
    @user = params[:user_id].nil? ? current_user : User.find(params[:user_id])
  end
  
end
