require 'rails_helper'

RSpec.describe Tweeting, :type => :model do
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :tweet }

  it "validates uniqueness of user/tweet combination" do
    tweeter = User.create!({
      full_name: "Tweeter",
      username: "tweeter",
      email: "tweeter@example.com",
      password: "tweeter"
    })

    tweet = tweeter.tweets.create!({
      content: "tweeting this!"
    })

    tweetinger = User.create!({
      full_name: "Retweeter",
      username: "retweeter",
      email: "retweeter@example.com",
      password: "retweeter"
    })

    Tweeting.create!({user: tweetinger, tweet: tweet})
    expect(Tweeting.new({user: tweetinger, tweet: tweet})).not_to be_valid
  end

  describe "associations" do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :tweet }
  end
end
