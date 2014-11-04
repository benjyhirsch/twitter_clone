json.partial! 'users/user', user: @user
json.tweets partial: 'tweets/tweet', collection: @user.tweets, as: :tweet
json.tweets_and_replies partial: 'tweets/tweet', collection: @user.tweets_and_replies, as: :tweet
json.followers partial: 'users/user', collection: @user.followers, as: :user
json.followees partial: 'users/user', collection: @user.followees, as: :user