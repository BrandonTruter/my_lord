class ScripturesController < ApplicationController
  before_action :find_user
  
  def index
    @page_title = "My Scriptures"
    @scriptures = @user.scriptures.all
    @daily_verse = @user.scriptures.last.daily_verse unless @user.scriptures.empty?
  end

  def show
    @scripture = @user.scriptures.find(params[:id])
    @scripture = @user.scriptures.last if @scripture.nil? && !@user.scriptures.empty?
    @page_title = "Scripture: #{@scripture.title}"
  end
  
  def new
    @page_title = "New Scriptures"
    @scripture = @user.scriptures.new
  end
  
  def create
    @scripture = @user.scriptures.new(scripture_params)
    
    if @scripture.save
      redirect_to user_scriptures_path(@user.id), :notice => "Successfully saved scripture: #{@scripture.title}"
    else
      render :new
    end
  end
  
  def edit
    @scripture = @user.scriptures.find(params[:id])
    @page_title = "Editing Scripture: #{@scripture.title}"
  end
  
  def update
    @scripture = @user.scriptures.find(params[:id])
    old_title = @scripture.title
    
    if @scripture.update(scripture_params)
        
      flash_message = "Successfully updated scripture: #{@scripture.title}"  
      flash_message = "Successfully updated ( #{old_title} ) scripture to ( #{@scripture.title} )" unless old_title == @scripture.title
      
      redirect_to user_scriptures_path(@user.id), :notice => flash_message
    else
      render :edit
    end
  end
  
  private
  
  def find_user
    @user = params[:user_id].nil? ? current_user : User.find(params[:user_id])
  end

  def scripture_params
    params.require(:scripture).permit(:title, :reference, :verse)
  end
  
end
