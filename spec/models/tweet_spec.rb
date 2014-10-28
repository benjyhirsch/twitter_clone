require 'rails_helper'

RSpec.describe Tweet, :type => :model do
  subject(:tweet) {Tweet.new}
  describe "validations" do
    context "when invalid tweet" do
      before(:each) { tweet.valid? }

      it "validates presence of author" do
        expect(tweet.errors[:author]).to include("can't be blank")
      end

      it "validates presence of content" do
        expect(tweet.errors[:content]).to include("can't be blank")
      end

      it "validates length of content" do
        tweet.content = "a" * 141
        tweet.valid?
        expect(tweet.errors[:content]).to include("is too long (maximum is 140 characters)")
      end
    end
  end
end
