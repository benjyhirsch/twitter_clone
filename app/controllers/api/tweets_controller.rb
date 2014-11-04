class TweetsController < ApplicationController
  def create
    @tweet = Tweet.new(tweet_params.merge({author: current_user}))
    if (@tweet.save)
      redirect_to tweet_url(@tweet)
    else
      fail
    end
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  private
  def tweet_params
    params.require(:tweet).permit(:content, :conversation_parent_id)
  end
end
