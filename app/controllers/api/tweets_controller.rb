class Api::TweetsController < ApplicationController
  def create
    @tweet = Tweet.new(tweet_params.merge({author: current_user}))
    if (@tweet.save)
      render json: @tweet
    else
      render json: @tweet.errors, status: :unprocessable_entity
    end
  end

  def show
    @tweet = Tweet.includes(:author, :conversation_parent).find(params[:id])
  end

  private
  def tweet_params
    params.require(:tweet).permit(:content, :conversation_parent_id, :image_url)
  end
end
