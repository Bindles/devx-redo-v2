class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

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

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
