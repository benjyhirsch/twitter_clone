require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "validations" do
    context "when invalid user" do
      subject(:user) { User.new }
      before(:each) { user.valid? }

      it "should ensure a session_token" do
        expect(user.session_token).not_to be_nil
      end

      it "should validate presence of username" do
        expect(user.errors[:username]).to include("can't be blank")
      end

      it "should validate presence of email" do
        expect(user.errors[:email]).to include("can't be blank")
      end

      it "should validate presence of password_digest" do
        expect(user.errors[:password_digest]).to include("can't be blank")
      end

      it "should allow_nil password" do
        expect(user.errors[:password]).to be_empty
      end

      it "should validate length of password" do
        user.password = "abcde"
        user.valid?
        expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
      end
    end

    context "when valid user" do
      subject(:user) do
        User.new({
          username: "username",
          email:    "user@example.com",
          password: "abcdef"
        })
      end

      it { is_expected.to be_valid }
    end
  end

  describe('#password=') do
    it "should hash and salt passwords" do
      one_user = User.new({
        username: "user1",
        email:    "oneuser@example.com",
        password: "abcdef"
      })

      other_user = User.new({
        username: "user2",
        email:    "otheruser@example.com",
        password: "abcdef"
      })

      expect(one_user.password_digest.to_s)
        .not_to eq(other_user.password_digest.to_s)
    end
  end
end
