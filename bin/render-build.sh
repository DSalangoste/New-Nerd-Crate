#!/usr/bin/env bash
# exit on error
set -o errexit

# Debug info
echo "Starting build process..."
echo "RAILS_ENV: $RAILS_ENV"
echo "DATABASE_URL is set: $(if [ -z "$DATABASE_URL" ]; then echo "no"; else echo "yes"; fi)"

# Basic setup
bundle install
bundle exec rake assets:precompile

# Database setup
echo "Setting up database..."
bundle exec rake db:create
bundle exec rake db:schema:load
bundle exec rake db:migrate

# If this is the first deploy, seed the database
if [ "$FIRST_DEPLOY" = "1" ]; then
  echo "First deploy, seeding database..."
  bundle exec rake db:seed
fi 