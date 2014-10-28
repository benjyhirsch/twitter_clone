require 'rails_helper'

RSpec.describe Tweet, :type => :model do
  subject(:tweet) {Tweet.new}
  describe "validations" do
    context "when invalid tweet" do
      it { is_expected.to validate_presence_of :author }
      it { is_expected.to validate_presence_of :content }

      it { is_expected.to ensure_length_of(:content).is_at_most 140 }
    end

    context "when valid tweet" do
      it "can save to database" do
        user = User.create!({
          full_name: "Full Name",
          username: "username",
          email: "user@example.com",
          password: "password"
        })

        tweet.author_id = user.id
        tweet.content = "a" * 140
        tweet.save

        expect(tweet).to be_persisted
      end
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:author).class_name("User") }
    it { is_expected.to belong_to(:conversation_parent).class_name("Tweet") }
    it { is_expected.to belong_to(:conversation_root).class_name("Tweet") }
  end
end
