# app/models/message.rb
class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: "User"

  validates :content, presence: true

  # Turbo Streams for real-time updates
  broadcasts_to :conversation # <= THIS MAGIC LINE TAKES CARE OF SHOW

  # after_create :update_conversation_unread_count
  # after_create :increment_unread_count

  # Increment unread count after a new message is created
  after_create :increment_unread_count_for_recipient

  after_create_commit :broadcast_unread_message_count

  after_create :broadcast_unread_count_to_conversation

  after_create_commit do
    broadcast_update_to :posts_list, target: "posts_count", html: Conversation.find(conversation_id).user2_unread_count
    #   broadcast_append_to :posts_list, target: "posts", partial: "posts/post", locals: { post: self }
  end

  private

  def broadcast_unread_count_to_conversation
    # Determine the recipient of the message
    recipient = conversation.user1 == sender ? conversation.user2 : conversation.user1

    # Broadcast the updated unread count for the conversation
    Turbo::StreamsChannel.broadcast_update_to(
      "user_conversations_#{recipient.id}",
      target: "unread_messages_#{conversation.id}",
      partial: "conversations/unread_message_count",
      locals: { conversation: conversation, current_user: recipient }
    )
  end

  def broadcast_unread_message_count
    recipient = conversation.user1 == sender ? conversation.user2 : conversation.user1
    Turbo::StreamsChannel.broadcast_update_to(
      "navbar_#{recipient.id}", # Stream name specific to the recipient
      target: "unread_messages_count", # The ID of the target element in the navbar
      partial: "shared/unread_messages_count", # Partial to render
      locals: { unread_count: recipient.unread_messages_count } # Pass updated count
    )
    Turbo::StreamsChannel.broadcast_update_to(
      "x_#{recipient.id}", # Stream name specific to the recipient
      target: "xunread_messages_count", # The ID of the target element in the navbar
      partial: "shared/unread_messages_count", # Partial to render
      locals: { unread_count: recipient.unread_messages_count } # Pass updated count
    )
  end


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
