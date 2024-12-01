# app/models/conversation.rb
class Conversation < ApplicationRecord
  belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"

  has_many :messages, dependent: :destroy
  # may not need under
  validates :user1, presence: true
  validates :user2, presence: true

  # Ensure no duplicate conversations between the same users
  validates :user1_id, uniqueness: { scope: :user2_id }

  # Increment unread_count
  def increment_unread_count
    update!(unread_count: unread_count + 1)
  end

  # Reset unread_count to 0
  def reset_unread_count
    update!(unread_count: 0)
  end

  def mark_as_read
    reset_unread_count
  end
end
