# Create admin user if it doesn't exist
admin_email = 'admin@nerdcrate.com'
admin_password = 'Admin123!'

unless AdminUser.exists?(email: admin_email)
  AdminUser.create!(
    email: admin_email,
    password: admin_password,
    password_confirmation: admin_password
  )
  puts "Admin user created successfully!"
  puts "Email: #{admin_email}"
  puts "Password: #{admin_password}"
else
  puts "Admin user already exists!"
end 