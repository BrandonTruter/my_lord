class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to user_path(current_user)
    else
      redirect_to welcome_path
    end
  end
  
  def welcome
    render 'welcome'
  end
end
