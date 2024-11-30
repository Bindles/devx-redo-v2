class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  broadcasts_to :commentable
  # after_create_commit { Rails.logger.debug "Broadcasting to #{commentable}" }
end
