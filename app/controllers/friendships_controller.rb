# app/controllers/friendships_controller.rb
class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Get the current user's friends
    @friends = current_user.friends

    # Get all users except the current user and their existing friends
    @all_users = User.where.not(id: [ current_user.id ] + @friends.pluck(:id))

    if params[:query].present?
      @users = User.where("username LIKE ?", "%#{params[:query]}%")
    else
      @users = []
    end
  end

  def create
    # Add a new friend
    friend = User.find(params[:friend_id])
    if current_user.friends << friend
      redirect_to friendships_path, notice: "#{friend.email} added as a friend."
    else
      redirect_to friendships_path, alert: "Unable to add friend."
    end
  end

  def destroy
    @friendship = current_user.friendships.find_by(friend_id: params[:id])
    if @friendship&.destroy
      flash[:notice] = "Friend removed successfully."
    else
      flash[:alert] = "Unable to remove friend."
    end
    redirect_to friendships_path # or friendship_path ?
  end

  # Action to search for users by username
  def search
    @users = User.where("username LIKE ?", "%#{params[:username]}%")
  end
end
