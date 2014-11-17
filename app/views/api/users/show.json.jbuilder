json.partial! 'api/users/user', user: @user
json.followers do
  json.partial! 'api/users/user', collection: @user.followers, as: :user
end

json.followees do
  json.partial! 'api/users/user', collection: @user.followees, as: :user
end

json.tweets do
  json.partial! 'api/tweets/tweet', collection: @user.tweets, as: :tweet
end