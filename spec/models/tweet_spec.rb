require 'rails_helper'

RSpec.describe Tweet, :type => :model do
  subject(:tweet) {Tweet.new}
  describe "validations" do
    context "when invalid tweet" do
      it "validates presence of author" do

      end
    end
  end
end
