#!/usr/bin/env ruby
require_relative '../config/environment'

admin_email = 'admin@nerdcrate.com'
new_password = 'admin123'

admin = AdminUser.find_by(email: admin_email)

if admin
  admin.password = new_password
  admin.password_confirmation = new_password
  
  if admin.save
    puts "\nAdmin password updated successfully!"
    puts "----------------------------------------"
    puts "Email: #{admin_email}"
    puts "New Password: #{new_password}"
    puts "----------------------------------------"
  else
    puts "Failed to update admin password."
    puts "Errors: #{admin.errors.full_messages.join(', ')}"
  end
else
  puts "Admin user not found with email: #{admin_email}"
end 