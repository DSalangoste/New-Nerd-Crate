# Create a new category for special crates
special_category = Category.find_or_create_by!(name: 'Special') do |category|
  category.description = 'Special themed crates that combine multiple categories or offer unique items'
end

# Create the All-in-One crate
all_in_one_crate = CrateType.find_or_create_by!(name: 'All-in-One Crate') do |crate|
  crate.price = 150.00
  crate.description = 'A premium crate featuring a mix of anime, comics, and gaming items'
end

# Associate the All-in-One crate with the Special category
all_in_one_crate.categories << special_category unless all_in_one_crate.categories.include?(special_category)

# Create the Japanese Treats crate
japanese_treats_crate = CrateType.find_or_create_by!(name: 'Japanese Treats Crate') do |crate|
  crate.price = 60.00
  crate.description = 'A curated selection of Japanese snacks, candies, and treats'
end

# Associate the Japanese Treats crate with the Special category
japanese_treats_crate.categories << special_category unless japanese_treats_crate.categories.include?(special_category)

puts "Created new crates:"
puts "  - All-in-One Crate ($150.00)"
puts "  - Japanese Treats Crate ($60.00)"
puts "Created new category: Special" 