# class Comment < ApplicationRecord
#   belongs_to :user
#   belongs_to :commentable, polymorphic: true

#   # Include RecordIdentifier for `dom_id`
#   # include ActionView::RecordIdentifier

#   # Existing broadcasting to the commentable (e.g., Post:42)
#   broadcasts_to :commentable, inserts_by: :prepend

#   # Additional broadcasting to a shared channel for all comments
#   # after_create_commit -> { broadcast_to [ :posts, :comments ], target: "comments_for_#{commentable.id}" }
#   # Broadcast to the specific post's comments frame
#   # broadcasts_to ->(comment) { [ :posts, comment.commentable ] }, inserts_by: :prepend
# end
# 
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  # Include RecordIdentifier for `dom_id`
  include ActionView::RecordIdentifier

  # Broadcast changes to the global :comments_list stream for the specific commentable
  after_create_commit do
    broadcast_prepend_to(:posts_list, target: dom_id(commentable, :comments), partial: "comments/comment", locals: { comment: self })
    broadcast_prepend_to(:posts_list, target: dom_id(commentable, :commentsx), partial: "comments/comment", locals: { comment: self })
  end

  after_update_commit do
    broadcast_replace_to(:posts_list, target: dom_id(self), partial: "comments/comment", locals: { comment: self })
  end

  after_destroy_commit do
    broadcast_remove_to(:posts_list, target: dom_id(self))
  end
end
