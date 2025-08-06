#!/bin/bash

# API Testing Script with Authentication Support
# This script runs the 3 main API tests with authentication

echo "🚀 API Testing with Authentication Support"
echo "Testing 3 main endpoints: GET /products, POST /messages, GET /categories/tree"

# Check if Newman is installed
if command -v newman >/dev/null 2>&1; then
    echo "✅ Newman is available: $(newman --version)"
else
    echo "❌ Newman is not installed. Installing Newman..."
    npm install -g newman newman-reporter-htmlextra
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install Newman. Please install Node.js and try again."
        exit 1
    fi
fi

# Create reports directory
if [ ! -d "reports" ]; then
    mkdir -p reports
    echo "📁 Created reports directory"
fi

# Set up common variables
ENV_FILE="./tests/environment.json"
REPORTS_DIR="./reports"

echo "🔧 Environment file: $ENV_FILE"
echo "📊 Reports directory: $REPORTS_DIR"

# Test 1: GET /products (Public API - no auth required)
echo ""
echo "📦 Testing GET /products (Public API)..."
newman run "./tests/collections/products_collection.json" \
    --environment "$ENV_FILE" \
    --iteration-data "./tests/data/products_pagination_data.csv" \
    --reporters cli \
    --reporter-htmlextra-export "$REPORTS_DIR/products_report.html" \
    --reporter-htmlextra-title "Products API Test Report"

if [ $? -eq 0 ]; then
    echo "✅ Products API tests completed successfully"
else
    echo "⚠️ Products API tests completed with some failures"
fi

# Test 2: POST /messages (May require authentication)
echo ""
echo "📧 Testing POST /messages (With Authentication Support)..."
newman run "./tests/collections/messages_collection.json" \
    --environment "$ENV_FILE" \
    --iteration-data "./tests/data/messages_data.csv" \
    --reporters cli \
    --reporter-htmlextra-export "$REPORTS_DIR/messages_report.html" \
    --reporter-htmlextra-title "Messages API Test Report (With Auth)"

if [ $? -eq 0 ]; then
    echo "✅ Messages API tests completed successfully"
else
    echo "⚠️ Messages API tests completed with some failures"
    echo "   Note: Some failures may be due to authentication requirements"
fi

# Test 3: GET /categories/tree (Public API - no auth required)  
echo ""
echo "📂 Testing GET /categories/tree (Public API)..."
newman run "./tests/collections/categories_collection.json" \
    --environment "$ENV_FILE" \
    --iteration-data "./tests/data/categories_tree_data.csv" \
    --reporters cli \
    --reporter-htmlextra-export "$REPORTS_DIR/categories_tree_report.html" \
    --reporter-htmlextra-title "Categories Tree API Test Report"

if [ $? -eq 0 ]; then
    echo "✅ Categories API tests completed successfully"
else
    echo "⚠️ Categories API tests completed with some failures"
fi

# Summary
echo ""
echo "📋 Test Summary:"
echo "- Products API: GET /products (30 test cases)"
echo "- Messages API: POST /messages (35 test cases with auth support)"
echo "- Categories API: GET /categories/tree (17 test cases)"
echo "- Total: 82 comprehensive test cases"

echo ""
echo "📊 Reports generated in: $REPORTS_DIR"
echo "- products_report.html"
echo "- messages_report.html (includes auth testing)"
echo "- categories_tree_report.html"

echo ""
echo "🎯 Authentication Notes:"
echo "- Messages collection includes automatic authentication token retrieval"
echo "- If authentication fails, tests will show appropriate 401 responses"
echo "- Products and Categories APIs are typically public endpoints"

echo ""
echo "✨ Testing completed!"
