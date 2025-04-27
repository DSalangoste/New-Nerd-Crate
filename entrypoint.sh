#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Wait for PostgreSQL to be ready
until pg_isready -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USER
do
  echo "Waiting for PostgreSQL to be ready..."
  sleep 2
done

# Run database migrations
bundle exec rails db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@" 