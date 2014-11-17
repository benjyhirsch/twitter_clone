json.(tweet, :id, :author_id, :content, :conversation_parent_id, :conversation_root_id, :image_url, :created_at, :updated_at)
json.author do 
  json.partial! 'api/users/user', user: tweet.author
end
json.num_retweets tweet.tweetings.length - 1
json.num_favorites tweet.favorites.length

if logged_in?
  json.retweeted tweet.author_id != current_user.id && (
    tweet.tweetings.any? { |tweeting| tweeting.user_id == current_user.id }
  )

  json.favorited tweet.favorites.any? { |favorite| favorite.user_id == current_user.id }
end