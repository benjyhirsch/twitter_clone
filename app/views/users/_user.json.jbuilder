json.(user, :id, :username, :full_name, :email, :created_at, :updated_at, :website, :location)
json.num_tweets user.tweetings.length
json.num_followers user.followers.length
json.num_followees user.followees.length