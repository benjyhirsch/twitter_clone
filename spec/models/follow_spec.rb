require 'rails_helper'

RSpec.describe Follow, :type => :model do
  describe "validations" do
    it { is_expected.to validate_presence_of :follower }
    it { is_expected.to validate_presence_of :followee }

    it "validates uniqueness of follower/followee combination" do
      follower = User.create!({
        full_name: "Follower",
        username: "follower",
        email: "follower@example.com",
        password: "follower"
      })

      followee = User.create!({
        full_name: "Followee",
        username: "followee",
        email: "followee@example.com",
        password: "followee"
      })

      Follow.create!({follower: follower, followee: followee})
      expect(Follow.new({follower: follower, followee: followee})).not_to be_valid
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:follower).class_name("User") }
    it { is_expected.to belong_to(:followee).class_name("User") }
  end
end
