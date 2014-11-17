class Api::RetweetsController < ApplicationController
  before_action :set_tweet
  before_action :ensure_not_original_author

  def create
    @retweet = Tweeting.new(user: current_user, tweet_id: params[:tweet_id])
    if @retweet.save
      render json: @retweet
    else
      render json: @retweet.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @retweet = Tweeting.find_by(user: current_user, tweet_id: params[:tweet_id])
    if @retweet && @retweet.destroy
      render json: @retweet
    else
      render nothing: true, status: :forbidden
    end
  end

  private
  def set_tweet
    @tweet = Tweet.find(params[:tweet_id])
  end

  def ensure_not_original_author
    redirect_to root_url if !logged_in? || current_user.id == @tweet.author_id
  end
end
