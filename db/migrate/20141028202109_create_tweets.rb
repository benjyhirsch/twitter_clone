class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :author_id
      t.text :content
      t.integer :conversation_parent_id
      t.integer :conversation_root_id

      t.timestamps
    end
  end
end
