class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  # before_action :authenticate_user! #not sure if needed

  def recent_comments(limit = 3)
    comments.order(created_at: :desc).limit(limit)
  end
end
