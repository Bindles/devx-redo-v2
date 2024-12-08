class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  # Existing broadcasting to the commentable (e.g., Post:42)
  broadcasts_to :commentable

  # Additional broadcasting to a shared channel for all comments
  # after_create_commit -> { broadcast_to [ :posts, :comments ], target: "comments_for_#{commentable.id}" }
  # Broadcast to the specific post's comments frame
  broadcasts_to ->(comment) { [ :posts, comment.commentable ] }, inserts_by: :append
end
