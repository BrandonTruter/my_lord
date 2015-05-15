Rails.application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: "users/registrations" }
  
  get 'home/welcome' => 'home#welcome', as: :welcome

  root :to => "home#index"
end