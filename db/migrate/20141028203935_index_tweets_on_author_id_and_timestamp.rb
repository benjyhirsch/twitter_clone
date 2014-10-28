class IndexTweetsOnAuthorIdAndTimestamp < ActiveRecord::Migration
  def change
    add_index :tweets, :author_id
    add_index :tweets, :created_at, order: {created_at: "desc"}
    add_index :tweets, [:author_id, :created_at], order: {created_at: "desc"}
  end
end
