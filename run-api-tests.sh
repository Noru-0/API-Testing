#!/bin/bash

# API Testing Script - Data-Driven Testing for 3 Main Endpoints
# This script runs comprehensive tests for Products, Messages, and Categories APIs

echo "🚀 API Automation Testing - Data-Driven Approach"
echo "Testing 3 main endpoints with comprehensive test scenarios"

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
ENV_FILE="./tests/collections/environment.json"
REPORTS_DIR="./reports"

echo "🔧 Environment file: $ENV_FILE"
echo "📊 Reports directory: $REPORTS_DIR"

# Test 1: GET /products - Data-driven testing with 28 test cases
echo ""
echo "📦 Testing GET /products (Data-Driven - 28 test cases)..."
newman run "./tests/collections/products-data-driven-collection.json" \
    --environment "$ENV_FILE" \
    --iteration-data "./tests/data/products-test-data.csv" \
    --reporters cli,htmlextra \
    --reporter-htmlextra-export "$REPORTS_DIR/products-data-driven-report.html" \
    --reporter-htmlextra-title "Products API Data-Driven Test Report"

if [ $? -eq 0 ]; then
    echo "✅ Products API tests completed successfully"
else
    echo "⚠️ Products API tests completed with some failures"
fi

# Test 2: POST /messages - Data-driven testing with 25 test cases  
echo ""
echo "📧 Testing POST /messages (Data-Driven - 25 test cases)..."
newman run "./tests/collections/messages-data-driven-collection.json" \
    --environment "$ENV_FILE" \
    --iteration-data "./tests/data/messages-test-data.csv" \
    --reporters cli,htmlextra \
    --reporter-htmlextra-export "$REPORTS_DIR/messages-data-driven-report.html" \
    --reporter-htmlextra-title "Messages API Data-Driven Test Report"

if [ $? -eq 0 ]; then
    echo "✅ Messages API tests completed successfully"
else
    echo "⚠️ Messages API tests completed with some failures"
fi

# Test 3: GET /categories/tree - Data-driven testing with 28 test cases
echo ""
echo "📂 Testing GET /categories/tree (Data-Driven - 28 test cases)..."
newman run "./tests/collections/categories-tree-data-driven-collection.json" \
    --environment "$ENV_FILE" \
    --iteration-data "./tests/data/categories-tree-test-data.csv" \
    --reporters cli,htmlextra \
    --reporter-htmlextra-export "$REPORTS_DIR/categories-tree-data-driven-report.html" \
    --reporter-htmlextra-title "Categories Tree API Data-Driven Test Report"

if [ $? -eq 0 ]; then
    echo "✅ Categories Tree API tests completed successfully"
else
    echo "⚠️ Categories Tree API tests completed with some failures"
fi

# Summary
echo ""
echo "📋 Test Summary - Data-Driven Testing Results:"
echo "- Products API: GET /products (28 comprehensive test scenarios)"
echo "- Messages API: POST /messages (25 validation & security test scenarios)"
echo "- Categories Tree API: GET /categories/tree (28 hierarchy & filtering scenarios)"
echo "- Total: 81 data-driven test cases covering all edge cases"

echo ""
echo "📊 HTML Reports generated in: $REPORTS_DIR"
echo "- products-data-driven-report.html"
echo "- messages-data-driven-report.html"
echo "- categories-tree-data-driven-report.html"

echo ""
echo "🎯 Test Coverage:"
echo "- Basic functionality testing"
echo "- Input validation & security testing"
echo "- Edge cases & error handling"
echo "- Performance & boundary testing"
echo "- Unicode & special character support"

echo ""
echo "✨ Data-driven testing completed!"
echo "📈 Check HTML reports for detailed test results and metrics"