#!/usr/bin/env ruby
require_relative '../config/environment'

puts "\nCrate Types and Prices:"
puts "----------------------"
CrateType.all.each do |ct|
  puts "#{ct.name}: $#{'%.2f' % ct.price}"
end
puts "----------------------\n" 