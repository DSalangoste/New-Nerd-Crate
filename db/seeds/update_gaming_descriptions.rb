# Update Gaming Crate descriptions to remove "monthly"
puts "Updating Gaming Crate descriptions..."

# Find all Gaming Crates
gaming_crates = CrateType.where("name LIKE 'Gaming Crate%'")

gaming_crates.each do |crate|
  # Remove "monthly" from the description if it exists
  if crate.description.include?("monthly")
    old_description = crate.description
    new_description = crate.description.gsub("monthly ", "")
    crate.update(description: new_description)
    puts "  - Updated '#{crate.name}' description:"
    puts "    From: '#{old_description}'"
    puts "    To:   '#{new_description}'"
  end
end

puts "Gaming Crate descriptions updated successfully." 