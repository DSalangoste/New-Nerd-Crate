#!/usr/bin/env ruby
require_relative '../config/environment'

puts "\nAdmin Users:"
puts "----------------------"
AdminUser.all.each do |admin|
  puts "Email: #{admin.email}"
  puts "Created at: #{admin.created_at}"
  puts "----------------------"
end

if AdminUser.count == 0
  puts "No admin users found in the database."
end 