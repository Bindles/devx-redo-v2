class FeedsController < ApplicationController
  def index
    @posts = Post.all
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
end
