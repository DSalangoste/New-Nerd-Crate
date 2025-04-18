source "https://rubygems.org"

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
gem 'devise', '~> 4.9'
gem 'activeadmin', '~> 3.3.0'
gem 'sassc-rails', '~> 2.1'
gem 'sass-rails', '~> 6.0'
gem 'formtastic', '~> 5.0'
gem 'inherited_resources'
gem 'jquery-rails'

# Asset Pipeline
gem 'uglifier'
gem 'sprockets-rails'

# Pagination
gem 'kaminari'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem 'sqlite3'
end

group :development do
  gem "web-console"
end