class Tweet < ActiveRecord::Base
  default_scope { order(created_at: :desc) }

  validates :author, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validates :conversation_root, presence: true
  before_validation :ensure_conversation_root

  belongs_to :author, class_name: "User"

  belongs_to :conversation_parent,
    class_name: "Tweet",
    inverse_of: :replies
  has_many :replies,
    class_name: "Tweet",
    foreign_key: "conversation_parent_id",
    inverse_of: :conversation_parent

  belongs_to :conversation_root,
    class_name: "Tweet",
    inverse_of: :conversation_descendants_as_root
  has_many :conversation_descendants_as_root,
    class_name: "Tweet", foreign_key: "conversation_root_id",
    inverse_of: :conversation_descendants_as_root

  has_many :conversation_relatives,
    through: :conversation_root,
    source: :conversation_descendants_as_root

  def conversation_parent=(conversation_parent)
    self.conversation_root_id = conversation_parent.conversation_root_id
    super
  end

  def conversation_parent_id=(conversation_parent_id)
    conversation_parent = Tweet.find(conversation_parent_id)
    self.conversation_parent = conversation_parent
  end

  def conversation_descendants
    @conversation_descendants ||= conversation_descendants_hash.keys.sort_by do |descendant|
      -1 * descendant.created_at.to_f
    end
  end

  def conversation_descendant_ids
    conversation_descendants.map(&:id)
  end

  def conversation_ancestors
    conversation_relatives.load.scoping do
      ancestors = []
      current_ancestor = self.conversation_parent

      while current_ancestor
        ancestors.unshift(current_ancestor)
        current_ancestor = current_ancestor.conversation_parent
      end

      ancestors
    end
  end

  def conversation_ancestor_ids
    conversation_ancestors.map(&:id)
  end

  private
  def ensure_conversation_root
    unless conversation_root || conversation_root_id
      self.conversation_root = self
    end
  end

  def conversation_descendants_hash
    return @conversation_descendants_hash if @conversation_descendants_hash

    conversation_relatives.load.scoping do
      hash = Hash.new
      queue = self.replies.to_a
      until queue.empty?
        current_descendant = queue.shift
        hash[current_descendant] = current_descendant.replies
        queue += current_descendant.replies
      end

      hash
    end
  end
end
