# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141117205506) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "favorites", force: true do |t|
    t.integer  "user_id"
    t.integer  "tweet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["tweet_id"], name: "index_favorites_on_tweet_id", using: :btree
  add_index "favorites", ["user_id", "created_at"], name: "index_favorites_on_user_id_and_created_at", order: {"created_at"=>:desc}, using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "follows", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followee_id"], name: "index_follows_on_followee_id", using: :btree
  add_index "follows", ["follower_id"], name: "index_follows_on_follower_id", using: :btree

  create_table "tweetings", force: true do |t|
    t.integer  "user_id"
    t.integer  "tweet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tweetings", ["tweet_id"], name: "index_tweetings_on_tweet_id", using: :btree
  add_index "tweetings", ["user_id", "created_at"], name: "index_tweetings_on_user_id_and_created_at", order: {"created_at"=>:desc}, using: :btree
  add_index "tweetings", ["user_id"], name: "index_tweetings_on_user_id", using: :btree

  create_table "tweets", force: true do |t|
    t.integer  "author_id"
    t.text     "content"
    t.integer  "conversation_parent_id"
    t.integer  "conversation_root_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
  end

  add_index "tweets", ["author_id", "created_at"], name: "index_tweets_on_author_id_and_created_at", order: {"created_at"=>:desc}, using: :btree
  add_index "tweets", ["author_id"], name: "index_tweets_on_author_id", using: :btree
  add_index "tweets", ["created_at"], name: "index_tweets_on_created_at", order: {"created_at"=>:desc}, using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.string   "session_token"
    t.string   "location"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
    t.string   "avatar_url"
    t.string   "header_image_url"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

end
