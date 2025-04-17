# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# Create default pages
Page.find_or_create_by!(slug: 'about') do |page|
  page.title = 'About NerdCrate'
  page.content = <<~CONTENT
    Welcome to NerdCrate - Your Ultimate Destination for Curated Geek Culture!

    At NerdCrate, we're passionate about bringing the best of geek and pop culture directly to your doorstep. Each month, our team of dedicated nerds carefully curates a selection of exclusive collectibles, merchandise, and surprises from your favorite fandoms.

    Our mission is to create an exciting unboxing experience that brings joy to fellow nerds and collectors around the world. Whether you're a fan of gaming, comics, sci-fi, or anime, we've got a crate that's perfect for you.

    Join our growing community of passionate collectors and experience the thrill of receiving a mystery box filled with exclusive items you'll love!
  CONTENT
end

Page.find_or_create_by!(slug: 'contact') do |page|
  page.title = 'Contact Us'
  page.content = <<~CONTENT
    We'd Love to Hear From You!

    Have questions about your subscription? Need help with an order? Or just want to share your excitement about your latest crate? We're here to help!

    Customer Support Hours:
    Monday - Friday: 9:00 AM - 6:00 PM EST

    Email: support@nerdcrate.com
    Phone: (555) 123-4567

    Follow us on social media:
    - Twitter: @NerdCrate
    - Instagram: @NerdCrateOfficial
    - Facebook: /NerdCrateOfficial

    For business inquiries:
    partnerships@nerdcrate.com
  CONTENT
end