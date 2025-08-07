#!/bin/bash

echo "🚀 Starting API Tests..."

# Step 1: Start Docker services
echo "📦 Starting Docker containers..."
docker compose -f docker-compose.yml up -d --force-recreate

# Step 2: Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 30

# Step 3: Setup database (migration & seed)
echo "🗄️ Setting up database..."
docker compose exec laravel-api php artisan migrate --force
docker compose exec laravel-api php artisan db:seed --force

# Step 4: Check if Newman is installed
if ! command -v newman &> /dev/null
then
    echo "📥 Installing Newman and HTML Extra Reporter..."
    npm install -g newman newman-reporter-htmlextra
fi

# Step 5: Create reports directory
REPORTS_DIR="reports"
if [ ! -d "$REPORTS_DIR" ]; then
    mkdir -p "$REPORTS_DIR"
    echo "📁 Created reports directory"
fi

# Common variables
ENV_FILE="./tests/collections/environment.json"

# Step 6: Run Products API Tests (28 test cases)
echo "🧪 Running Products API tests (Data-Driven - 28 test cases)..."
newman run "./tests/collections/products-data-driven-collection.json" \
    --environment "$ENV_FILE" \
    --iteration-data "./tests/data/products-test-data.csv" \
    --reporters cli,htmlextra \
    --reporter-htmlextra-export "$REPORTS_DIR/products-data-driven-report.html" \
    --reporter-htmlextra-title "Products API Data-Driven Test Report"

# Step 7: Run Messages API Tests (25 test cases)
echo "📧 Running Messages API tests (Data-Driven - 25 test cases)..."
newman run "./tests/collections/messages-data-driven-collection.json" \
    --environment "$ENV_FILE" \
    --iteration-data "./tests/data/messages-test-data.csv" \
    --reporters cli,htmlextra \
    --reporter-htmlextra-export "$REPORTS_DIR/messages-data-driven-report.html" \
    --reporter-htmlextra-title "Messages API Data-Driven Test Report"

# Step 8: Run Categories API Tests (28 test cases)
echo "📂 Running Categories API tests (Data-Driven - 28 test cases)..."
newman run "./tests/collections/categories-tree-data-driven-collection.json" \
    --environment "$ENV_FILE" \
    --iteration-data "./tests/data/categories-tree-test-data.csv" \
    --reporters cli,htmlextra \
    --reporter-htmlextra-export "$REPORTS_DIR/categories-tree-data-driven-report.html" \
    --reporter-htmlextra-title "Categories Tree API Data-Driven Test Report"

# Step 9: Shutdown Docker containers
echo "🧹 Stopping Docker containers..."
docker compose down

# Step 10: Summary
echo ""
echo "✅ All tests completed!"
echo "📊 Reports saved in: $REPORTS_DIR"
echo "- products-data-driven-report.html"
echo "- messages-data-driven-report.html"
echo "- categories-tree-data-driven-report.html"
