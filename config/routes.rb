Rails.application.routes.draw do
  resources :users
  resources :tweets
  resource :session, only: [:new, :create, :destroy]
  root 'sessions#new'
end
