class FavoritesController < ApplicationController
  def create
    tweet_id = params[:favorite][:tweet_id]
    @favorite = Favorite.new(user: current_user, tweet_id: tweet_id)
    @favorite.save
    redirect_to tweet_url(tweet_id)
  end

  def destroy
    @favorite = Favorite.includes(:tweet).find(params[:id])
    if current_user.id == @favorite.user_id
      @favorite.destroy
      redirect_to tweet_url(@favorite.tweet)
    else
      redirect_to tweet_url(@favorite.tweet)
    end
  end
end
