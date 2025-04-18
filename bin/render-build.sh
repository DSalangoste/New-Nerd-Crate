#!/usr/bin/env bash
# exit on error
set -o errexit

# Debug info
echo "RAILS_ENV: $RAILS_ENV"
echo "RACK_ENV: $RACK_ENV"
echo "DATABASE_URL is set: $(if [ -z "$DATABASE_URL" ]; then echo "no"; else echo "yes"; fi)"

# Install dependencies
bundle install

# Cleanup any old assets
bundle exec rake assets:clobber

# Compile assets
bundle exec rake assets:precompile

# Database setup
echo "Setting up database..."
bundle exec rake db:prepare
bundle exec rake db:migrate

# If this is the first deploy, seed the database
if [ "$FIRST_DEPLOY" = "1" ]; then
  echo "First deploy, seeding database..."
  bundle exec rake db:seed
fi 