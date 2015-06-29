Rails.application.routes.draw do

  devise_for :users, :controllers => { :sessions => "users/sessions", :registrations => "users/registrations" }
  
  resources :users do
    resources :profiles
    resources :scriptures
  end
  
  get 'home/welcome', as: :welcome
  get 'home/about', as: :about
  get 'home/services', as: :service
  get 'home/contact', as: :contact  
  get 'home/pictures', as: :pictures
  get 'home/scriptures', as: :scripture
  get 'home/bible', as: :bible
  get 'home/stories', as: :stories

  root :to => "home#index"
  
end