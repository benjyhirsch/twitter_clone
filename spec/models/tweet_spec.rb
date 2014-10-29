require 'rails_helper'

RSpec.describe Tweet, :type => :model do
  subject(:tweet) {Tweet.new}

  context "when invalid tweet" do
    it { is_expected.to validate_presence_of :author }
    it { is_expected.to validate_presence_of :content }

    it { is_expected.to ensure_length_of(:content).is_at_most 140 }
  end

  context "when valid tweet" do
    let(:user) do
      User.create!({
        full_name: "Full Name",
        username: "username",
        email: "user@example.com",
        password: "password"
      })
    end

    before(:each) do
      tweet.author = user
      tweet.content = "a" * 140
      tweet.save!
    end

    context "when saving" do
      it "saves to the database" do
        expect(tweet).to be_persisted
      end

      it "assigns the appropriate conversation_root" do

        child = user.reply(tweet)
        child.content += "b" * 130
        child.save!

        grandchild = user.reply(child)
        grandchild.content += "c" * 130
        grandchild.save!

        [tweet, child, grandchild].each do |t|
          expect(t.conversation_root_id).to eq(tweet.id)
        end
      end
    end


    describe "associations" do
      it { is_expected.to belong_to(:author).class_name("User") }
      it { is_expected.to belong_to(:conversation_parent).class_name("Tweet") }
      it { is_expected.to have_many(:replies).class_name("Tweet").with_foreign_key("conversation_parent_id")}
      it { is_expected.to belong_to(:conversation_root).class_name("Tweet") }
      it { is_expected.to have_many(:conversation_descendants_as_root).class_name("Tweet").with_foreign_key(:conversation_root_id)}
      it { is_expected.to have_many(:conversation_relatives).through(:conversation_root).source(:conversation_descendants_as_root)}
    end

    describe "conversation" do
      context "when no replies" do
        it "does not name any descendants" do
          expect(tweet.conversation_descendants).to be_empty
        end

        it "does not name any ancestors" do
          expect(tweet.conversation_ancestors).to be_empty
        end
      end

      context "when it has a direct reply" do
        let!(:child) do
          child = user.reply(tweet)
          child.content += "b" * 130
          child.save!
          child
        end

        it "has only that child as a descendant when no others" do
          expect(tweet.conversation_descendant_ids).to eq([child.id])
        end

        it "is the sole ancestor of that child" do
          expect(child.conversation_ancestor_ids).to eq([tweet.id])
        end

        context "when another child" do
          let!(:sibling) do
            sibling = user.reply(tweet)
            sibling.content += "c" * 130
            sibling.save!
            sibling
          end

          it "has both children as descendants in reverse chronological order" do
            expect(tweet.conversation_descendant_ids).to eq([sibling.id, child.id])
          end

          it "does not name siblings as descendants of each other" do
            [child, sibling].each do |sib|
              expect(sib.conversation_descendants).to be_empty
            end
          end

          it "is the sole ancestor of each sibling" do
            [child, sibling].each do |sib|
              expect(sib.conversation_ancestor_ids).to eq([tweet.id])
            end
          end

          context "when another generation" do
            let!(:grandchild) do
              grandchild = user.reply(child)
              grandchild.content += "d" * 130
              grandchild.save!
              grandchild
            end

            it "has grandchild as descendant" do
              expect(tweet.conversation_descendant_ids).to eq([grandchild.id, sibling.id, child.id])
            end

            it "does not name ancestors as descendants" do
              expect(child.conversation_descendant_ids).to eq([grandchild.id])
              expect(grandchild.conversation_descendants).to be_empty
            end

            it "does not name nephew as descendant" do
              expect(sibling.conversation_descendants).to be_empty
            end

            it "names parent and grandparent and not uncle as ancestors" do
              expect(grandchild.conversation_ancestor_ids).to eq([tweet.id, child.id])
            end

            it "does not name descendants as ancestors" do
              expect(child.conversation_ancestor_ids).to eq([tweet.id])
            end

            it "does not name nephew as ancestor" do
              expect(sibling.conversation_ancestor_ids).to eq([tweet.id])
            end
          end
        end
      end
    end
  end
end
