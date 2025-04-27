namespace :storage do
  desc "Purge all Active Storage attachments"
  task purge_all: :environment do
    puts "Purging all Active Storage attachments..."
    ActiveStorage::Attachment.all.each do |attachment|
      puts "Purging attachment for #{attachment.record_type} ##{attachment.record_id}"
      attachment.purge
    end
    puts "Done!"
  end
end 