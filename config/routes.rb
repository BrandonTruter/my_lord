Rails.application.routes.draw do
  
  # get 'profile/show'
  # get 'profile/edit'
  # get 'profile/update'
  # get 'scriptures/new'
  # get 'scriptures/show'

  devise_for :users, :controllers => { :sessions => "users/sessions", :registrations => "users/registrations" }
  
  resources :users do
    resources :profile
    resources :scriptures
  end
  
  get 'home/welcome', as: :welcome

  root :to => "home#index"
  
end