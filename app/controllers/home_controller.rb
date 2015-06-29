class HomeController < ApplicationController
  
  def index
    if user_signed_in?
      redirect_to user_path(current_user.id)
    else
      redirect_to welcome_path
    end
  end
  
  def welcome
    @daily_title = "Title placeholder"        # Daily Heading Title
    @daily_scripture = "Scripture placeholder"    # random scripture
    @daily_image = "daily_image.jpg"        # filename of image
    
    render "welcome", layout: "home"
  end
end
