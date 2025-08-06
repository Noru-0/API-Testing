#!/bin/bash

echo "🚀 Starting API Tests..."

# Start Docker services
echo "📦 Starting Docker containers..."
docker compose -f docker-compose.yml up -d --force-recreate

# Wait for services
echo "⏳ Waiting for services to be ready..."
sleep 30

# Setup database
echo "🗄️ Setting up database..."
docker compose exec laravel-api php artisan migrate --force
docker compose exec laravel-api php artisan db:seed --force

# Install Newman if not exists
if ! command -v newman &> /dev/null; then
    echo "📥 Installing Newman..."
    npm install -g newman newman-reporter-htmlextra
fi

# Ensure reports directory exists
mkdir -p reports

# Run Products API tests
echo "🧪 Running Products API tests..."
newman run tests/collections/products_collection.json \
    --environment tests/environment.json \
    --iteration-data tests/data/products_pagination_data.csv \
    --reporters cli,htmlextra \
    --reporter-htmlextra-export reports/products_api_report.html

# Run Messages API tests
echo "📧 Running Messages API tests..."
newman run tests/collections/messages_collection.json \
    --environment tests/environment.json \
    --iteration-data tests/data/messages_data.csv \
    --reporters cli,htmlextra \
    --reporter-htmlextra-export reports/messages_api_report.html

# Run Categories API tests
echo "📂 Running Categories API tests..."
newman run tests/collections/categories_collection.json \
    --environment tests/environment.json \
    --iteration-data tests/data/categories_pagination_data.csv \
    --reporters cli,htmlextra \
    --reporter-htmlextra-export reports/categories_api_report.html

echo "✅ All tests completed! Check the reports directory for detailed results."

# Cleanup (optional)
echo "🧹 Stopping Docker containers..."
docker compose down
