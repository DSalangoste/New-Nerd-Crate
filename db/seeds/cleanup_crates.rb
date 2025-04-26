# Remove crates without size designations
puts "Removing crates without size designations..."

# Find all crates that don't have a size designation (don't contain " - Small", " - Medium", or " - Large")
regular_crates = CrateType.where("name NOT LIKE '% - Small' AND name NOT LIKE '% - Medium' AND name NOT LIKE '% - Large'")

if regular_crates.any?
  puts "Found #{regular_crates.count} regular crates to remove:"
  regular_crates.each do |crate|
    puts "  - #{crate.name}"
    crate.destroy
  end
  puts "Regular crates removed successfully."
else
  puts "No regular crates found to remove."
end 