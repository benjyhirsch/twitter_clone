class Tweet < ActiveRecord::Base
  validates :author, presence: true
  validates :content, presence: true, length: {maximum: 140}

  belongs_to :author, class_name: "User"
  belongs_to :conversation_parent, class_name: "Tweet"
  belongs_to :conversation_root, class_name: "Tweet"
end
