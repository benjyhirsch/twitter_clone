class RetweetsController < ApplicationController
  before_action :set_retweet, only: [:destroy]
  before_action :set_tweet, only: [:create]
  before_action :ensure_not_original_author

  def create
    tweet_id = params[:tweeting][:tweet_id]
    @retweet = Tweeting.new(user: current_user, tweet_id: tweet_id)
    if @retweet.save
      render json: @retweet
    else
      render json: @retweet.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @retweet = Tweeting.includes(:tweet).find(params[:id])
    if current_user.id == @retweet.user_id
      if @retweet.destroy
        render json: @retweet
      else
        render json: @retweet.errors, status: :forbidden
      end
    else
      render json @retweet, status: :forbidden
    end
  end

  private
  def set_retweet
    @retweet = Tweeting.includes(:tweet).find(params[:id])
  end

  def set_tweet
    @tweet = Tweet.find(params[:tweeting][:tweet_id])
  end

  def ensure_not_original_author
    author_id = @retweet ? @retweet.tweet.author_id : @tweet.author_id
    render nothing: true, status: :forbidden if !logged_in? || author_id == current_user.id
  end
end
