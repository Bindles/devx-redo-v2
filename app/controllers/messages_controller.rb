# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, except: [ :index ]

  def create
    @message = @conversation.messages.new(message_params)
    @message.sender = current_user
    if @message.save
      # Real-time updates happen automatically via Turbo Streams
      redirect_to conversation_path(@conversation)
    else
      flash[:alert] = "Message could not be sent."
      render "conversations/show"
    end
  end

  def index
    # Fetch all conversations for the current user
    @conversations = Conversation.includes(:messages).where("user1_id = ? OR user2_id = ?", current_user.id, current_user.id)

    # Prepare a list of conversations with unread messages
    @messages_preview = @conversations.map do |conversation|
      {
        conversation: conversation,
        friend: conversation.user1 == current_user ? conversation.user2 : conversation.user1,
        unread_messages: conversation.messages.where(read: false).order(created_at: :asc).limit(2)
      }
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
