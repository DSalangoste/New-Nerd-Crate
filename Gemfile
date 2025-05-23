source "https://rubygems.org"
ruby "3.3.7"

# Core Rails gems
gem "rails", "~> 7.1.0"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem 'image_processing', '~> 1.2'

# Database and Caching
gem "pg", "~> 1.1"  # PostgreSQL adapter
gem 'redis', '~> 4.0'  # Required for Action Cable

# Authentication & Admin
gem 'sassc-rails', '~> 2.1'
gem 'activeadmin', '~> 3.3.0'
gem 'devise', '~> 4.9'
gem 'sass-rails', '~> 6.0'
gem 'formtastic', '~> 5.0'
gem 'inherited_resources'
gem 'jquery-rails'
gem 'bootstrap', '~> 5.3.0'

# Asset Pipeline
gem 'uglifier'
gem 'terser'
gem 'sprockets-rails'

# Pagination
gem 'kaminari'

# Payment processing
gem 'stripe'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem 'sqlite3'
end

group :development do
  gem "web-console"
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
end