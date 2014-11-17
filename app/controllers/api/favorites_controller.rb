class Api::FavoritesController < ApplicationController
  before_action :ensure_logged_in

  def create
    @favorite = Favorite.new(user: current_user, tweet_id: params[:tweet_id])
    if @favorite.save
      render json: @favorite
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @favorite = Favorite.find_by(user: current_user, tweet_id: params[:tweet_id])
    if @favorite && @favorite.destroy
      render json: @favorite
    else
      render json: @favorite.errors, status: :forbidden
    end
  end

  private
  def ensure_logged_in
    unless logged_in?
      render nothing: true, status: :forbidden
    end
  end
end
