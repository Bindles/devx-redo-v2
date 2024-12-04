# app/controllers/conversations_controller.rb
class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index_all
    @active_conversations = Conversation
    .where("user1_id = :user_id OR user2_id = :user_id", user_id: current_user.id)
    .includes(:user1, :user2) # Preload associated users for better performance
    @all_friends = current_user.friends
  end

  def show_conversation
    @conversation = current_user.conversations.find(params[:id])
    @messages = @conversation.messages.includes(:sender).order(created_at: :asc)
    render partial: "chat_window", locals: { conversation: @conversation, messages: @messages }
  end

  def index
    # Get all conversations for the current user
    @conversations = Conversation
                      .where("user1_id = :user_id OR user2_id = :user_id", user_id: current_user.id)
                      .includes(:user1, :user2) # Preload associated users for better performance

    # @all_friends = current_user.friends

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

    # Friends without conversations
    all_friends = current_user.friends
    active_friend_ids = @conversations.map { |c| [ c.user1_id, c.user2_id ] }.flatten.uniq
    @friends_without_conversations = all_friends.where.not(id: active_friend_ids)
  end

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages.order(created_at: :asc)

    # Reset unread count for the current user
    @conversation.reset_unread_count_for(current_user)
    p "######################"
    Rails.logger.debug { @conversation.inspect } # Log data

    # This renders a partial to update the Turbo Frame
    # respond_to do |format|
    #   format.html # For direct visits
    #   format.turbo_stream { render partial: "conversations/conversation", locals: { conversation: @conversation } }
    # end
  end

  def new
    @user = User.find(params[:user_id]) # Assumes the friend ID is passed as a parameter
    @conversation = Conversation.new
    @message = @conversation.messages.build
  end

  # * FIX ELSES IN IF MESSAGE.SAVE
  def create
    user = User.find(params[:conversation][:user_id])
    @conversation = Conversation.between(current_user, user) || Conversation.create(user1: current_user, user2: user)

    # Create the initial message
    message = @conversation.messages.new(content: params[:conversation][:content], sender: current_user)

    if message.save
      @messages = @conversation.messages.order(:created_at)
      # Render the 'show' view inside the Turbo Frame
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(:showc, template: "conversations/show")
        end
        format.html { redirect_to conversation_path(@conversation), notice: "Conversation started with your message." }
      end
    else
      flash[:alert] = "Could not start conversation. Ensure the message content is valid."
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(:showc, partial: "conversations/new", locals: { conversation: @conversation, user: user })
        end
        format.html { redirect_to new_conversation_path(user_id: user.id) }
      end
    end
  end


  # def create
  #   user = User.find(params[:user_id])
  #   conversation = Conversation.between(current_user, user) || Conversation.create(user1: current_user, user2: user)
  #   redirect_to conversation_path(conversation)
  # end
end
