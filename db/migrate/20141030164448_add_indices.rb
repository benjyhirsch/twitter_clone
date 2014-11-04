class AddIndices < ActiveRecord::Migration
  def change
    add_index :favorites, :user_id
    add_index :favorites, :tweet_id
    add_index :favorites, [:user_id, :created_at], order: {created_at: :desc}

    add_index :retweets, :user_id
    add_index :retweets, :tweet_id
    add_index :retweets, [:user_id, :created_at], order: {created_at: :desc}


    add_index :follows, :follower_id
    add_index :follows, :followee_id
  end
end
