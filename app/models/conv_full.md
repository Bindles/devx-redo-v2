class Conversation < ApplicationRecord
  belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"
  has_many :messages, dependent: :destroy

  validates :user1, presence: true
  validates :user2, presence: true

  # Ensure no duplicate conversations between the same users
  validates :user1_id, uniqueness: { scope: :user2_id }

  def self.between(user1, user2)
    where(user1: user1, user2: user2).or(where(user1: user2, user2: user1)).first
  end
end

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: "User"

  validates :content, presence: true

  # Turbo Streams for real-time updates
  broadcasts_to :conversation
end

