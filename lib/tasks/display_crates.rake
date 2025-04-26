namespace :crates do
  desc "Display all crate types and their prices"
  task display: :environment do
    puts "\nCrate Types and Prices:"
    puts "----------------------"
    CrateType.all.each do |ct|
      puts "#{ct.name}: $#{'%.2f' % ct.price}"
    end
    puts "----------------------\n"
  end
end 