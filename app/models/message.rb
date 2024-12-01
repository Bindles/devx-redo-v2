# app/models/message.rb
class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: "User"

  validates :content, presence: true

  # Turbo Streams for real-time updates
  broadcasts_to :conversation

  # after_create :update_conversation_unread_count
  # after_create :increment_unread_count

  # Increment unread count after a new message is created
  after_create :increment_unread_count_for_recipient

  private


# message.rb
def increment_unread_count_for_recipient
  conversation.update!(sender == conversation.user1 ? { user2_unread_count: conversation.user2_unread_count + 1 } : { user1_unread_count: conversation.user1_unread_count + 1 })
end


def increment_unread_count_for_recipientx
  recipient = (conversation.user1 == sender) ? conversation.user2 : conversation.user1
  conversation.update!(recipient == conversation.user1 ? { user1_unread_count: conversation.user1_unread_count + 1 } : { user2_unread_count: conversation.user2_unread_count + 1 })
end

  def increment_unread_count_for_recipientz
    recipient = (conversation.user1 = sender) ? conversation.user2 : conversation.user1
    conversation.increment_unread_count_for(recipient) if recipient
  end


  # Increment unread_count in the conversation after message creation
  def update_conversation_unread_count
    conversation.increment_unread_count
  end

  def increment_unread_count
    conversation = self.conversation
    recipient = self.receiver

    # Increment unread count for the recipient
    if recipient == conversation.user1
      conversation.update(user1_unread_count: conversation.user1_unread_count + 1)
    else
      conversation.update(user2_unread_count: conversation.user2_unread_count + 1)
    end
  end
end
