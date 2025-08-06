Write-Host "🚀 Starting API Tests..."

# Start Docker services
Write-Host "📦 Starting Docker containers..."
docker compose -f docker-compose.yml up -d --force-recreate

# Wait for services
Write-Host "⏳ Waiting for services to be ready..."
Start-Sleep -Seconds 30

# Setup database
Write-Host "🗄️ Setting up database..."
docker compose exec laravel-api php artisan migrate --force
docker compose exec laravel-api php artisan db:seed --force

# Define path to newman.cmd
$NEWMAN = Join-Path $env:APPDATA "npm\newman.cmd"

# Check if newman.cmd exists
if (-not (Test-Path $NEWMAN)) {
    Write-Host "📥 Installing Newman and HTML reporter..."
    npm install -g newman newman-reporter-htmlextra
}

# Ensure reports directory exists
if (-not (Test-Path -Path "reports")) {
    New-Item -ItemType Directory -Path "reports" | Out-Null
}

# Run Products API tests
Write-Host "🧪 Running Products API tests..."
& $NEWMAN run tests/collections/products_collection.json `
    --environment tests/environment.json `
    --iteration-data tests/data/products_pagination_data.csv `
    --reporters cli,htmlextra `
    --reporter-htmlextra-export reports/products_api_report.html

# Run Messages API tests
Write-Host "📧 Running Messages API tests..."
& $NEWMAN run tests/collections/messages_collection.json `
    --environment tests/environment.json `
    --iteration-data tests/data/messages_data.csv `
    --reporters cli,htmlextra `
    --reporter-htmlextra-export reports/messages_api_report.html

# Run Categories API tests
Write-Host "📂 Running Categories API tests..."
& $NEWMAN run tests/collections/categories_collection.json `
    --environment tests/environment.json `
    --iteration-data tests/data/categories_tree_data.csv `
    --reporters cli,htmlextra `
    --reporter-htmlextra-export reports/categories_tree_api_report.html

Write-Host "✅ All tests completed! Check the reports directory for detailed results."

# Cleanup
Write-Host "🧹 Stopping Docker containers..."
docker compose down
