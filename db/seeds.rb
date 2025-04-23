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

# Create default static pages
StaticPage.find_or_create_by!(slug: 'about') do |page|
  page.title = 'About NerdCrate'
  page.content = <<~CONTENT
    <p>Welcome to NerdCrate - The #1 Canadian-based company for Curated Geek Culture!</p>

    <p>At NerdCrate, we're passionate about bringing the best of geek and pop culture directly to your doorstep. Each month, our team of dedicated nerds carefully curates a selection of exclusive collectibles, merchandise, and surprises from your favorite fandoms.</p>

    <p>Our mission is to create an exciting unboxing experience that brings joy to fellow nerds and collectors around the world. Whether you're a fan of gaming, comics, sci-fi, or anime, we've got a crate that's perfect for you.</p>

    <p>Join our growing community of passionate collectors and experience the thrill of receiving a mystery box filled with exclusive items you'll love!</p>
  CONTENT
end

StaticPage.find_or_create_by!(slug: 'contact') do |page|
  page.title = 'Contact Us'
  page.content = <<~CONTENT
    <p>We'd Love to Hear From You!</p>

    <p>Have questions about your subscription? Need help with an order? Or just want to share your excitement about your latest crate? We're here to help!</p>

    <h3>Customer Support Hours:</h3>
    <p>Monday - Friday: 9:00 AM - 6:00 PM EST</p>

    <h3>Contact Information:</h3>
    <ul class="list-unstyled">
      <li><strong>Email:</strong> support@nerdcrate.com</li>
      <li><strong>Phone:</strong> (555) 123-4567</li>
    </ul>

    <h3>Social Media:</h3>
    <ul class="list-unstyled">
      <li><a href="https://twitter.com/NerdCrate" class="text-decoration-none">Twitter: @NerdCrate</a></li>
      <li><a href="https://instagram.com/NerdCrateOfficial" class="text-decoration-none">Instagram: @NerdCrateOfficial</a></li>
      <li><a href="https://facebook.com/NerdCrateOfficial" class="text-decoration-none">Facebook: /NerdCrateOfficial</a></li>
    </ul>

    <h3>Business Inquiries:</h3>
    <p>partnerships@nerdcrate.com</p>
  CONTENT
end

# Load all seed files from db/seeds
Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
  load seed
end