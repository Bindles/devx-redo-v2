# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'httparty'

# Method to fetch relevant image URLs from ImgBB
def fetch_images
  url = "https://nick-bindles.imgbb.com/"
  response = HTTParty.get(url)

  # Extract image URLs using regex
  image_urls = response.body.scan(/<img[^>]+src="([^"]+)"/).flatten

  # Keep only URLs that contain "https://i.ibb.co/"
  relevant_images = image_urls.select { |url| url.include?("https://i.ibb.co/") }

  relevant_images
rescue StandardError => e
  puts "Error fetching images: #{e.message}"
  []
end

# Fetch the relevant images
relevant_images = fetch_images

# Ensure we have at least one image
if relevant_images.any?
  ('b'..'e').each do |letter|
    email = "user#{letter}@a.com"
    user = User.create(email: email, password: "passwo")

    # Pick a random image from the relevant images
    avatar_url = relevant_images.sample

    profile = user.create_profile(bio: "Bio for user #{letter.upcase}", avatar_url: avatar_url)
    puts "Created #{user.email} with bio: '#{profile.bio}' and avatar: '#{profile.avatar_url}'"
  end
else
  puts "No relevant images found"
end
