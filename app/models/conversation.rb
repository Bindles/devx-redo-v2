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

  # Increment the unread count for the recipient
  def increment_unread_count_for(user)
    if user == user1
      update!(user2_unread_count: user2_unread_count + 1)
    elsif user == user2
      update!(user1_unread_count: user1_unread_count + 1)
    end
  end

  # Reset unread count for a specific user
  def reset_unread_count_for(user)
    if user == user1
      update!(user1_unread_count: 0)
    elsif user == user2
      update!(user2_unread_count: 0)
    end
  end

  def mark_as_read
    reset_unread_count
  end

  def unread_messages_count
    conversations.where(user1: self).sum(:user1_unread_count) +
      conversations.where(user2: self).sum(:user2_unread_count)
  end  

  def self.between(user1, user2)
    where("(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)",
          user1.id, user2.id, user2.id, user1.id).first
  end
end
