require 'rails_helper'

RSpec.describe Favorite, :type => :model do
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

    favoriter = User.create!({
      full_name: "Favoriter",
      username: "favoriter",
      email: "favoriter@example.com",
      password: "favoriter"
    })

    Favorite.create!({user: favoriter, tweet: tweet})
    expect(Favorite.new({user: favoriter, tweet: tweet})).not_to be_valid
  end

  describe "associations" do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to :tweet }
  end
end
