#!/usr/bin/env bash
# exit on error
set -o errexit

echo "==== DEBUG INFORMATION ===="
echo "RAILS_ENV: $RAILS_ENV"
echo "RACK_ENV: $RACK_ENV"
echo "DATABASE_URL is set: $(if [ -z "$DATABASE_URL" ]; then echo "no"; else echo "yes"; fi)"
echo "RAILS_MASTER_KEY is set: $(if [ -z "$RAILS_MASTER_KEY" ]; then echo "no"; else echo "yes"; fi)"
echo "Current directory: $(pwd)"
echo "Ruby version: $(ruby -v)"
echo "Rails version: $(bundle exec rails -v)"
echo "PostgreSQL version: $(psql --version)"
echo "=========================="

echo "1. Installing dependencies..."
bundle install
echo "Bundle install completed ✓"

echo "2. Checking database configuration..."
bundle exec rails runner "puts ActiveRecord::Base.connection_config.inspect"
echo "Database config check completed ✓"

echo "3. Precompiling assets..."
bundle exec rake assets:precompile
echo "Asset precompilation completed ✓"

echo "4. Creating database..."
bundle exec rake db:create
echo "Database creation completed ✓"

echo "5. Loading schema..."
bundle exec rake db:schema:load
echo "Schema load completed ✓"

echo "6. Running migrations..."
bundle exec rake db:migrate
echo "Migrations completed ✓"

if [ "$FIRST_DEPLOY" = "1" ]; then
  echo "7. Seeding database..."
  bundle exec rake db:seed
  echo "Database seeding completed ✓"
fi

echo "==== BUILD COMPLETED ====" 