class CommentsController < ApplicationController
  before_action :set_commentable

  def create
    @commentable.comments.create!(
      params.require(:comment).permit(:content).merge(user: current_user)
    )
    redirect_to @commentable, notice: "Comment created"
  end

  private

  def set_commentable
    @commentable = Post.find(params[:post_id]) # Extend for other models if needed
  end
end
