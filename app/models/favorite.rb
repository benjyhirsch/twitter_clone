class Favorite < ActiveRecord::Base
  validates :user, :tweet, presence: true
  validates :tweet_id, uniqueness: { scope: :user_id }

  belongs_to :user, inverse_of: :favorites
  belongs_to :tweet, inverse_of: :favorites
end
