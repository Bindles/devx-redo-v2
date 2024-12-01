class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Get all conversations for the current user
    @conversations = Conversation
                      .where("user1_id = :user_id OR user2_id = :user_id", user_id: current_user.id)
                      .includes(:user1, :user2) # Preload associated users for better performance

    # Filter conversations for search results if query is provided
    @searched_conversations = []
    if params[:query].present?
      query = "%#{params[:query]}%"
      @searched_conversations = Conversation.joins(
        "INNER JOIN users AS user1s ON user1s.id = conversations.user1_id
         INNER JOIN users AS user2s ON user2s.id = conversations.user2_id"
      ).where(
        "(user1s.username LIKE :query AND conversations.user2_id = :user_id) OR
         (user2s.username LIKE :query AND conversations.user1_id = :user_id)",
        query: query, user_id: current_user.id
      )
    end
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
