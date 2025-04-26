admin = AdminUser.create!(
  email: 'admin@nerdcrate.com',
  password: 'admin123',
  password_confirmation: 'admin123'
)
puts "Admin user created: #{admin.email}" 