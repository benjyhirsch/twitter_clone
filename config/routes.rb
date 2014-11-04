Rails.application.routes.draw do
  resources :users
  resource :session, only: [:new, :create, :destroy]
  resource :feed, only: [:show]

  resources :tweets, only: [:index, :show, :create, :destroy]
  resources :follows, only: [:create, :destroy]
  resources :retweets, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]

  root 'feeds#show'
end
