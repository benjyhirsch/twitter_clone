require 'rails_helper'

RSpec.describe User, :type => :model do
  subject(:user) { User.new }

  describe "validations" do
    context "when invalid user" do
      before(:each) { user.valid? }

      it "ensures a session_token" do
        expect(user.session_token).not_to be_nil
      end

      it "validates presence of username" do
        expect(user.errors[:username]).to include("can't be blank")
      end

      it "validates presence of email" do
        expect(user.errors[:email]).to include("can't be blank")
      end

      it "validates presence of password_digest" do
        expect(user.errors[:password_digest]).to include("can't be blank")
      end

      it "allows nil password" do
        expect(user.errors[:password]).to be_empty
      end

      it "validates length of password" do
        user.password = "abcde"
        user.valid?
        expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
      end

      let(:saved_user) do
        User.create!({
          username: "username",
          email:    "user@example.com",
          password: "abcdef"
        })
      end

      it "validates uniqueness of username" do
        user.username = saved_user.username
        user.valid?
        expect(user.errors[:username]).to include("has already been taken")
      end

      it "validates uniqueness of email" do
        user.email = saved_user.email
        user.valid?
        expect(user.errors[:email]).to include("has already been taken")
      end
    end

    context "when valid user" do
      it "should be able to save to database" do
        user.username = "username"
        user.email    = "user@example.com"
        user.password = "abcdef"

        user.save!

        expect(user.id).not_to be_nil
      end
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
