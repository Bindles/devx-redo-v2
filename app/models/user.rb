class User < ApplicationRecord
  after_create :build_default_profile
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy
  has_many :posts
  # Automatically build a profile when a user is created


  private

  # Create a default profile for a new user
  def build_default_profile
    create_profile
  end
end
