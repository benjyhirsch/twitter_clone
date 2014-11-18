Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:show, :create, :update, :destroy] do
      resource :follow, only: [:create, :destroy]
    end

    resource :session, only: [:create, :destroy, :show]
    resource :feed, only: [:show]

    resources :tweets, only: [:show, :create, :destroy] do
      resource :favorite, only: [:create, :destroy]
      resource :retweet, only: [:create, :destroy]
    end
  end


  resources :users
  resource :session, only: [:new, :create, :destroy]
  resource :feed, only: [:show]

  resources :tweets, only: [:index, :show, :create, :destroy]
  resources :follows, only: [:create, :destroy]
  resources :retweets, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]

  root 'root#root'
end