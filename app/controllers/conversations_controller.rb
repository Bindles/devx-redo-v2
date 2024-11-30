class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = Conversation.where("user1_id = ? OR user2_id = ?", current_user.id, current_user.id)
  end

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages.order(created_at: :asc)
  end

  def create
    user = User.find(params[:user_id])
    conversation = Conversation.between(current_user, user) || Conversation.create(user1: current_user, user2: user)
    redirect_to conversation_path(conversation)
  end
end
