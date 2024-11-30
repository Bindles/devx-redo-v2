class User < ApplicationRecord
  after_create :build_default_profile   # Automatically build a profile when a user is created
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy

  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy
  has_many :conversations_as_user1, class_name: "Conversation", foreign_key: "user1_id", dependent: :destroy
  has_many :conversations_as_user2, class_name: "Conversation", foreign_key: "user2_id", dependent: :destroy
  has_many :posts
  # friend =>
  # Users that this user has added as friends
  has_many :friendships
  has_many :friends, through: :friendships, source: :friend

  # Users who have added this user as a friend
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user



  private

  # Create a default profile for a new user
  def build_default_profile
    create_profile
  end
end
