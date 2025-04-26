#!/usr/bin/env ruby
require_relative '../config/environment'

admin_email = 'admin@nerdcrate.com'
admin_password = SecureRandom.hex(12) # Generate a secure random password

admin = AdminUser.find_or_create_by!(email: admin_email) do |user|
  user.password = admin_password
  user.password_confirmation = admin_password
end

if admin.persisted?
  puts "\nAdmin user created/updated successfully!"
  puts "----------------------------------------"
  puts "Email: #{admin_email}"
  puts "Password: #{admin_password}"
  puts "----------------------------------------"
  puts "Please save these credentials securely."
  puts "You can change the password after logging in."
else
  puts "Failed to create admin user."
end 