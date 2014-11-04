class RenameRetweetsAsTweetings < ActiveRecord::Migration
  def change
    rename_table :retweets, :tweetings
  end
end
