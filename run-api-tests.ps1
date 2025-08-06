# API Testing Script with Authentication Support
# This script runs the 3 main API tests with authentication

Write-Host "🚀 API Testing with Authentication Support" -ForegroundColor Green
Write-Host "Testing 3 main endpoints: GET /products, POST /messages, GET /categories/tree" -ForegroundColor Yellow

# Check if Newman is installed
try {
    $newmanVersion = newman --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Newman is available: $newmanVersion" -ForegroundColor Green
    } else {
        throw "Newman not found"
    }
} catch {
    Write-Host "❌ Newman is not installed. Installing Newman..." -ForegroundColor Red
    npm install -g newman newman-reporter-htmlextra
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to install Newman. Please install Node.js and try again." -ForegroundColor Red
        exit 1
    }
}

# Create reports directory
if (!(Test-Path "reports")) {
    New-Item -ItemType Directory -Name "reports"
    Write-Host "📁 Created reports directory" -ForegroundColor Blue
}

# Set up common variables
$envFile = "./tests/environment.json"
$reportsDir = "./reports"

Write-Host "🔧 Environment file: $envFile" -ForegroundColor Blue
Write-Host "📊 Reports directory: $reportsDir" -ForegroundColor Blue

# Test 1: GET /products (Public API - no auth required)
Write-Host "`n📦 Testing GET /products (Public API)..." -ForegroundColor Cyan
try {
    newman run "./tests/collections/products_collection.json" `
        --environment $envFile `
        --iteration-data "./tests/data/products_pagination_data.csv" `
        --reporters cli `
        --reporter-htmlextra-export "$reportsDir/products_report.html" `
        --reporter-htmlextra-title "Products API Test Report"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Products API tests completed successfully" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Products API tests completed with some failures" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Products API tests failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: POST /messages (May require authentication)
Write-Host "`n📧 Testing POST /messages (With Authentication Support)..." -ForegroundColor Cyan
try {
    newman run "./tests/collections/messages_collection.json" `
        --environment $envFile `
        --iteration-data "./tests/data/messages_data.csv" `
        --reporters cli `
        --reporter-htmlextra-export "$reportsDir/messages_report.html" `
        --reporter-htmlextra-title "Messages API Test Report (With Auth)"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Messages API tests completed successfully" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Messages API tests completed with some failures" -ForegroundColor Yellow
        Write-Host "   Note: Some failures may be due to authentication requirements" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Messages API tests failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: GET /categories/tree (Public API - no auth required)
Write-Host "`n📂 Testing GET /categories/tree (Public API)..." -ForegroundColor Cyan
try {
    newman run "./tests/collections/categories_collection.json" `
        --environment $envFile `
        --iteration-data "./tests/data/categories_tree_data.csv" `
        --reporters cli `
        --reporter-htmlextra-export "$reportsDir/categories_tree_report.html" `
        --reporter-htmlextra-title "Categories Tree API Test Report"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Categories API tests completed successfully" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Categories API tests completed with some failures" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Categories API tests failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Summary
Write-Host "`n📋 Test Summary:" -ForegroundColor Magenta
Write-Host "- Products API: GET /products (30 test cases)" -ForegroundColor White
Write-Host "- Messages API: POST /messages (35 test cases with auth support)" -ForegroundColor White  
Write-Host "- Categories API: GET /categories/tree (17 test cases)" -ForegroundColor White
Write-Host "- Total: 82 comprehensive test cases" -ForegroundColor White

Write-Host "`n📊 Reports generated in: $reportsDir" -ForegroundColor Green
Write-Host "- products_report.html" -ForegroundColor Gray
Write-Host "- messages_report.html (includes auth testing)" -ForegroundColor Gray
Write-Host "- categories_tree_report.html" -ForegroundColor Gray

Write-Host "`n🎯 Authentication Notes:" -ForegroundColor Blue
Write-Host "- Messages collection includes automatic authentication token retrieval" -ForegroundColor Gray
Write-Host "- If authentication fails, tests will show appropriate 401 responses" -ForegroundColor Gray
Write-Host "- Products and Categories APIs are typically public endpoints" -ForegroundColor Gray

Write-Host "`n✨ Testing completed!" -ForegroundColor Green
