class CommentsController < ApplicationController
  before_action :set_commentable
  include Pagy::Backend

  def create
    @comment = @commentable.comments.create!(
      params.require(:comment).permit(:content).merge(user: current_user)
    )
    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Comment created" }
      format.turbo_stream
    end
  end

  private

  def set_commentable
    @commentable = Post.find(params[:post_id]) # Extend for other models if needed
  end
end
