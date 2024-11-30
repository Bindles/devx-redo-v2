class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: "User"

  validates :content, presence: true

  # Turbo Streams for real-time updates
  broadcasts_to :conversation
end
