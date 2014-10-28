class User < ActiveRecord::Base
  validates :username, :email, presence: true, uniqueness: true
  validates :full_name, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  before_validation :ensure_session_token

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

  private
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end
end
