def find_commentable
  return unless params[:commentable_type] && params[:commentable_id]

  params[:commentable_type].constantize.find(params[:commentable_id])
end
