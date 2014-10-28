require 'rails_helper'

RSpec.describe User, :type => :model do
  subject(:user) { User.new }

  describe "validations" do
    context "when invalid user" do
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
    end
  end

  describe('#password=') do
    it "hashes and salts passwords" do
      user.password = "abcdef"
      other_user = User.new({password: "abcdef"})

      expect(user.password_digest.to_s)
        .not_to eq(other_user.password_digest.to_s)
    end
  end

  describe('::find_by_credentials') do
    before(:each) do
      user.full_name = "Full Name"
      user.username  = "username"
      user.email     = "user@example.com"
      user.password  = "abcdef"

      user.save!
    end

    it "finds correct user given valid credentials" do
      [ ["username", "abcdef"], ["user@example.com", "abcdef"] ]
      .each do |credentials|
        expect(User.find_by_credentials(*credentials).id).to eq(user.id)
      end
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:authored_tweets).class_name("Tweet").with_foreign_key(:author_id) }
  end
end
