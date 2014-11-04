class RetweetsController < ApplicationController
  before_action :set_retweet, only: [:destroy]
  before_action :set_tweet, only: [:create]
  before_action :ensure_not_original_author

  def create
    tweet_id = params[:tweeting][:tweet_id]
    @retweet = Tweeting.new(user: current_user, tweet_id: tweet_id)
    @retweet.save
    redirect_to tweet_url(tweet_id)
  end

  def destroy
    @retweet = Tweeting.includes(:tweet).find(params[:id])
    if current_user.id == @retweet.user_id
      @retweet.destroy
      redirect_to tweet_url(@retweet.tweet)
    else
      redirect_to tweet_url(@retweet.tweet)
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
    redirect_to root_url if !logged_in? || author_id == current_user.id
  end
end
