class User < ActiveRecord::Base
  validates :username, :email, :session_token, presence: true, uniqueness: true
  validates :full_name, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  before_validation :ensure_session_token

  has_many :tweets,
    class_name: "Tweet",
    foreign_key: :author_id,
    dependent: :destroy,
    inverse_of: :author

  has_many :follows_as_follower,
    class_name: "Follow",
    foreign_key: :follower_id,
    inverse_of: :follower,
    dependent: :destroy
  has_many :followees, through: :follows_as_follower, source: :followee

  has_many :follows_as_followee,
    class_name: "Follow",
    foreign_key: :followee_id,
    inverse_of: :followee,
    dependent: :destroy
  has_many :followers, through: :follows_as_followee, source: :follower

  has_many :tweetings, inverse_of: :user
  has_many :root_tweetings,
    -> { joins("INNER JOIN tweets ON tweets.id = tweetings.tweet_id AS tweets")
          .where("tweets.conversation_root_id=tweets.id") },
    class_name: "Tweeting",
    inverse_of: "user"

  has_many :tweets_and_replies, through: :tweetings, source: :tweet
  has_many :tweets, through: :root_tweetings

  has_many :favorites, inverse_of: :user
  has_many :favorited_tweets, through: :favorites, source: :tweet


  def self.generate_session_token
    loop do
      token = SecureRandom.urlsafe_base64
      return token if User.where(session_token: token).empty?
    end
  end

  def self.find_by_credentials(username_or_email, password)
    user = User.find_by_username(username_or_email) ||
           User.find_by_email(username_or_email)
    user && user.password_digest == password ? user : nil
  end

  attr_reader :password

  def feed_tweetings
    Tweeting.where(user: followees + [self])
  end

  def feed
    feed_tweetings.includes(tweet: :tweetings, tweet: :favorites).map(&:tweet)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def password_digest
    super ? BCrypt::Password.new(super) : nil
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    save!
  end

  def follow!(other_user)
    follows_as_follower.create!({followee_id: other_user.id}) unless followed?(other_user)
  end

  def unfollow!(other_user)
    follow = follows_as_follower.find_by(followee_id: other_user.id)
    follow.destroy! if follow
  end

  def followed?(other_user)
    follows_as_follower.any? { |follow| follow.followee_id = other_user.id }
  end

  def retweet!(tweet)
    tweetings.create!({tweet_id: tweet.id}) unless tweeted?(tweet)
  end

  def unretweet!(tweet)
    tweeting = tweetings.find_by(tweet_id: tweet.id)
    tweeting.destroy! if tweeting
  end

  def favorite!(tweet)
    favorites.create!({tweet_id: tweet.id}) unless favorited?(tweet)
  end

  def unfavorite!(tweet)
    favorite = favorites.find_by(tweet_id: tweet.id)
    favorite.destroy! if favorite
  end

  def tweeted?(tweet)
    tweetings.any? { |tweeting| tweeting.tweet_id = tweet.id }
  end

  def favorited?(tweet)
    favorites.any? { |favorite| favorite.tweet_id = tweet.id }
  end

  private
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end
end
