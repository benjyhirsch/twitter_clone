json.(tweet, :author_id, :content, :conversation_parent_id, :conversation_root_id, :created_at, :updated_at)
json.author tweet.author, :full_name, :username
json.num_retweets tweet.tweetings.length - 1
json.num_favorites tweet.favorites.length

if logged_in?
  json.retweeted tweet.author_id != current_user.id && tweet.tweetings.any? { user_id == current_user.id }
  json.favorited tweet.favorites.any? { user_id == current_user.id }
end