Write-Host " Starting API Login Tests..."

# Start Docker services
Write-Host " Starting Docker containers..."
docker compose -f docker-compose.yml up -d --force-recreate

# Wait for services
Write-Host " Waiting for services to be ready..."
Start-Sleep -Seconds 30

# Setup database
Write-Host " Setting up database..."
docker compose exec laravel-api php artisan migrate --force
docker compose exec laravel-api php artisan db:seed --force

# Check if Newman is installed
if (-not (Get-Command newman -ErrorAction SilentlyContinue)) {
    Write-Host " Installing Newman..."
    npm install -g newman newman-reporter-htmlextra
}

# Ensure reports directory exists
if (-not (Test-Path -Path "reports")) {
    New-Item -ItemType Directory -Path "reports"
}

# Run tests
Write-Host " Running API tests..."
newman run tests/api/Login_API_Tests.postman_collection.json `
    --environment tests/api/environment.json `
    --iteration-data tests/api/user_account.csv `
    --reporters cli `


# Cleanup
Write-Host " Stopping Docker containers..."
docker compose down
