require 'rails_helper'

RSpec.describe User, :type => :model do
  subject(:user) { User.new }
  let(:other_user) do
    User.create({
      full_name: "Other Name",
      username: "othername",
      email: "other@example.com",
      password: "ghijkl"
    })
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :full_name }

    it { is_expected.to validate_presence_of :username }
    it { is_expected.to validate_uniqueness_of :username }

    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of :email }

    it { is_expected.to validate_presence_of :password_digest }
    it { is_expected.to ensure_length_of(:password).is_at_least 6 }
    it { is_expected.to allow_value(nil).for(:password) }

    it { is_expected.to validate_uniqueness_of :session_token }
  end

  context "when valid user" do
    before(:each) do
      user.full_name = "Full Name"
      user.username  = "username"
      user.email     = "user@example.com"
      user.password  = "abcdef"
    end

    it { is_expected.to be_valid }

    it "ensures it has a session_token" do
      user.valid?
      expect(user.session_token).not_to be_nil
    end


    describe('#password=') do
      it "hashes and salts passwords" do
        other_user = User.new({password: user.password})

        expect(user.password_digest.to_s)
          .not_to eq(other_user.password_digest.to_s)
      end
    end

    context "when persisted" do
      before(:each) { user.save! }

      describe('::find_by_credentials') do
        it "finds correct user given valid credentials" do
          [ ["username", "abcdef"], ["user@example.com", "abcdef"] ]
          .each do |credentials|
            expect(User.find_by_credentials(*credentials).id).to eq(user.id)
          end
        end
      end

      describe 'following' do

        before(:each) { user.follow!(other_user) }

        describe '#follow!' do
          it "adds follower to followee's followers" do
            expect(other_user.follower_ids).to include(user.id)
          end

          it "adds followee to follower's followees" do
            expect(user.followee_ids).to include(other_user.id)
          end
        end

        describe '#unfollow!' do
          before(:each) { user.unfollow!(other_user) }
          it "removes follower from followee's followers" do
            expect(other_user.follower_ids).not_to include(user.id)
          end

          it "removes followee from follower's followees" do
            expect(user.followee_ids).not_to include(other_user.id)
          end
        end
      end

      describe '#profile_feed' do
        let!(:tweet) { user.tweets.create!(content: "tweet")}
        let!(:tweet_to_retweet) {other_user.tweets.create!(content: "tweeting this!")}

        before(:each) do
          user.retweet!(tweet_to_retweet)
        end

        # it "includes tweets" do
        #   expect(user.feed_profile)
        # end

        it "includes retweets"

        it "is sorted by the order *this user* tweeted or retweeted"
      end
    end
  end
end
