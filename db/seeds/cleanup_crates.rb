# Remove crates without size designations (except Special category crates)
puts "Removing crates without size designations..."

# Get the Special category
special_category = Category.find_by(name: 'Special')

# Find all crates that don't have a size designation and are not in the Special category
regular_crates = CrateType.joins(:categories)
                         .where("categories.name != 'Special'")
                         .where("crate_types.name NOT LIKE '% - Small' AND crate_types.name NOT LIKE '% - Medium' AND crate_types.name NOT LIKE '% - Large'")
                         .distinct

if regular_crates.any?
  puts "Found #{regular_crates.count} non-special crates to remove:"
  regular_crates.each do |crate|
    puts "  - #{crate.name}"
    crate.destroy
  end
  puts "Regular crates removed successfully."
else
  puts "No regular crates found to remove."
end 