#!/bin/bash
set -e

# Load environment variables
if [ -f .env ]; then
  source .env
fi

# Ensure required environment variables are set
required_vars=(
  "DATABASE_USER"
  "DATABASE_PASSWORD"
  "DATABASE_NAME"
  "RAILS_MASTER_KEY"
)

for var in "${required_vars[@]}"; do
  if [ -z "${!var}" ]; then
    echo "Error: $var is not set"
    exit 1
  fi
done

# Pull latest changes
git pull origin main

# Build and deploy containers
docker-compose -f docker-compose.production.yml build
docker-compose -f docker-compose.production.yml up -d

# Run database migrations
docker-compose -f docker-compose.production.yml exec web bundle exec rails db:migrate

echo "Deployment completed successfully!" 