#!/usr/bin/env ruby
require_relative '../config/environment'

# Find or create the Comics category
comics_category = Category.find_or_create_by!(name: 'Comics') do |category|
  category.description = 'Comic books, graphic novels, and superhero merchandise'
end

# Create the Comic Crate - Small
crate_type = CrateType.find_or_create_by!(name: 'Comic Crate - Small') do |ct|
  ct.price = 30.00
  ct.description = 'Comic books and superhero merchandise (Small)'
end

# Associate the crate type with the Comics category
crate_type.categories << comics_category unless crate_type.categories.include?(comics_category)

puts "Created Comic Crate - Small: $#{'%.2f' % crate_type.price}" 