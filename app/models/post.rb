class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  # before_action :authenticate_user! #not sure if needed

  # * BROADCASTING POSTS
  after_create_commit do
    update_posts_count
    broadcast_append_to :posts_list, target: "posts", partial: "posts/post", locals: { post: self }
  end
  after_update_commit do
    broadcast_replace_to :posts_list, target: self, partial: "posts/post", locals: { post: self }
  end
  after_destroy_commit do
    update_posts_count
    broadcast_remove_to :posts_list, target: self
  end


  def update_posts_count
    # broadcast_update_to :posts_list, target: 'posts_count', html: Post.count
    broadcast_update_to :posts_list, target: "posts_count", html: Post.count
  end


  def recent_comments(limit = 3)
    comments.order(created_at: :desc).limit(limit)
  end
end
