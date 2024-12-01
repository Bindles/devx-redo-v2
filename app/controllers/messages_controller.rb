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
    @messages_preview = current_user
                         .conversations
                         .includes(:messages)  # Eager load messages
                         .map do |conversation|
                           # Ensure we're getting the correct friend and unread messages
                           friend = conversation.user1 == current_user ? conversation.user2 : conversation.user1

                           # Fetch unread messages based on your logic (messages where created_at > conversation.updated_at)
                           unread_messages = conversation.messages
                                                         .where("created_at > ?", conversation.updated_at)
                                                         .where.not(sender: current_user)

                           # Prepare the preview data
                           {
                             conversation: conversation,
                             friend: friend,
                             unread_messages: unread_messages
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
