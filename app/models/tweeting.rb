class Tweeting < ActiveRecord::Base
  validates :user, :tweet, presence: true
  validates :tweet_id, uniqueness: { scope: :user_id }

  belongs_to :user, inverse_of: :tweetings
  belongs_to :tweet, inverse_of: :tweetings
end
