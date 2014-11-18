json.(user, :id, :username, :full_name, :email, :created_at, :updated_at, :website, :location)
json.avatar_url user.avatar_url || image_url('avatar.png')
json.header_image_url user.header_image_url || image_url('header_image.png')
json.num_tweets user.tweetings.length
json.num_followers user.followers.length
json.num_followees user.followees.length
json.num_favorites user.favorites.length