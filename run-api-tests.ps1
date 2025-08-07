Write-Host "🚀 Starting API Tests..."

# # Start Docker services
# Write-Host "📦 Starting Docker containers..."
# docker compose -f docker-compose.yml up -d --force-recreate

# # Wait for services
# Write-Host "⏳ Waiting for services to be ready..."
# Start-Sleep -Seconds 30

# # Setup database
# Write-Host "🗄️ Setting up database..."
# docker compose exec laravel-api php artisan migrate --force
# docker compose exec laravel-api php artisan db:seed --force

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

# Run Products API tests - Data-driven testing with 28 test cases
Write-Host "🧪 Running Products API tests (Data-Driven - 28 test cases)..."
& $NEWMAN run tests/collections/products-data-driven-collection.json `
    --environment tests/collections/environment.json `
    --iteration-data tests/data/products-test-data.csv `
    --reporters cli,htmlextra `
    --reporter-htmlextra-export reports/products-data-driven-report.html `
    --reporter-htmlextra-title "Products API Data-Driven Test Report"

# Run Messages API tests - Data-driven testing with 25 test cases
Write-Host "📧 Running Messages API tests (Data-Driven - 25 test cases)..."
& $NEWMAN run tests/collections/messages-data-driven-collection.json `
    --environment tests/collections/environment.json `
    --iteration-data tests/data/messages-test-data.csv `
    --reporters cli,htmlextra `
    --reporter-htmlextra-export reports/messages-data-driven-report.html `
    --reporter-htmlextra-title "Messages API Data-Driven Test Report"

# Run Categories API tests - Data-driven testing with 28 test cases
Write-Host "📂 Running Categories API tests (Data-Driven - 28 test cases)..."
& $NEWMAN run tests/collections/categories-tree-data-driven-collection.json `
    --environment tests/collections/environment.json `
    --iteration-data tests/data/categories-tree-test-data.csv `
    --reporters cli,htmlextra `
    --reporter-htmlextra-export reports/categories-tree-data-driven-report.html `
    --reporter-htmlextra-title "Categories Tree API Data-Driven Test Report"

Write-Host "✅ All tests completed! Check the reports directory for detailed results."

# Cleanup
Write-Host "🧹 Stopping Docker containers..."
docker compose down
