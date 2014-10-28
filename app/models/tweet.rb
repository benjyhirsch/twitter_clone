class Tweet < ActiveRecord::Base
  belongs_to :author, class_name: "User"
  validates :author, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
