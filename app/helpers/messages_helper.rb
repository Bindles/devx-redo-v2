module MessagesHelper
  def message_alignment_class(message, conversation)
    message.sender == conversation.user1 ? "message-left" : "message-right"
  end
end
