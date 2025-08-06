# API Testing Collections and Data

Thư mục này chứa các collection Postman và dữ liệu để test **3 API endpoints chính** cho sprint5.

## Cấu trúc thư mục

```
tests/
├── environment.json                    # Environment variables chung
├── collections/                        # Postman collections
│   ├── products_collection.json        # Collection cho GET /products
│   ├── messages_collection.json        # Collection cho POST /messages
│   └── categories_collection.json      # Collection cho GET /categories/tree
└── data/                               # Data files cho data-driven testing
    ├── products_pagination_data.csv    # Test data cho products
    ├── messages_data.csv               # Test data cho messages
    └── categories_tree_data.csv        # Test data cho categories tree
```

## 🎯 API Endpoints được test

### 1. **GET /api/products** 
- Retrieve all products với pagination support
- Test data: `products_pagination_data.csv` (**30 test cases**)
- Techniques: EP, BVA, Negative, Combinatorial, Edge Cases

### 2. **POST /api/messages**
- Send new contact message
- Test data: `messages_data.csv` (**35 test cases**)
- Techniques: EP, BVA, Negative, Combinatorial, Edge Cases, Security

### 3. **GET /api/categories/tree**
- Retrieve categories tree structure (including subcategories)  
- Test data: `categories_tree_data.csv` (**17 test cases**)
- Techniques: EP, BVA, Negative, Combinatorial, Edge Cases, Performance

## 🧪 **Kỹ thuật Testing được áp dụng**

### 📊 **Equivalence Partitioning (EP)**
- **Products**: Valid pagination ranges, normal/medium/large values
- **Messages**: Valid complete data, special characters, different content lengths  
- **Categories**: Basic requests, filtered requests, full tree requests

### 🎯 **Boundary Value Analysis (BVA)**
- **Products**: Min/max page numbers (0,1,999,999999), limit boundaries (0,1,100,101)
- **Messages**: Min/max field lengths (first_name, last_name, email, subject, message)
- **Categories**: Empty/null filters, depth parameters, parameter boundaries

### ❌ **Negative Testing**
- **Products**: Invalid data types (strings as numbers), special characters, SQL injection
- **Messages**: Missing required fields, invalid email formats, XSS attempts, SQL injection
- **Categories**: Invalid filters, malformed parameters, security validation

### 🔄 **Combinatorial Testing**  
- **Products**: Multiple parameter combinations (page+limit), valid+invalid combinations
- **Messages**: Multiple missing fields, field interaction testing
- **Categories**: Multiple filter combinations, parameter interaction testing

### 🚨 **Edge Cases & Security**
- **Unicode/Emoji support**: International characters, emoji in content
- **Performance testing**: Large data, concurrent requests, response times
- **Security validation**: XSS prevention, SQL injection protection
- **Data integrity**: ID uniqueness, parent-child relationships

## Environment Variables

File `environment.json` chứa các biến môi trường:
- `base_url`: http://localhost:8091/api
- `api_timeout`: 10000
- `content_type`: application/json

## Data-Driven Testing

### **Products Data (30 test cases):**
- **Equivalence Partitioning**: Valid normal/medium/large pagination values
- **Boundary Value Analysis**: Min/max page (0,1,999,999999), limit (0,1,100,101) 
- **Negative Testing**: Invalid data types (string pages/limits), special characters
- **Combinatorial**: Valid+invalid parameter combinations, multiple scenarios
- **Edge Cases**: Empty parameters, extremely large values

### **Messages Data (35 test cases):**
- **Equivalence Partitioning**: Valid complete messages, long content, special chars
- **Boundary Value Analysis**: Min/max field lengths for all required fields
- **Negative Testing**: Missing fields, invalid email formats, empty strings
- **Security Testing**: XSS attempts, SQL injection, malicious input
- **Combinatorial**: Multiple missing fields, field interaction scenarios
- **Edge Cases**: Unicode characters, emoji content, mixed languages

### **Categories Data (17 test cases):**
- **Equivalence Partitioning**: Basic tree, filtered tree, full tree requests
- **Boundary Value Analysis**: Empty/null filters, depth parameters
- **Negative Testing**: Invalid filters, malformed parameters, security validation
- **Combinatorial**: Multiple filter combinations, parameter interactions
- **Performance**: Response time benchmarks, system stability tests
- **Edge Cases**: Unicode support, concurrent requests, special characters

## Cách sử dụng

1. **Import Environment**: Import file `environment.json` vào Postman
2. **Import Collections**: Import các file collection từ thư mục `collections/`
3. **Set up Data Files**: Khi chạy collection, chọn data file tương ứng từ thư mục `data/`
4. **Run Tests**: Chạy collection với data file để thực hiện data-driven testing

## Test Cases

Mỗi collection bao gồm **advanced test validations**:
- ✅ **Status Code Validation** (200, 201, 400, 422) với technique-specific logic
- ⏱️ **Response Time Validation** (< 2-5s depending on test type)
- 📄 **Content-Type Validation** (application/json)
- 🏗️ **Response Structure Validation** với field-level checking
- 📊 **Data Validation** specific cho từng endpoint và technique
- ❌ **Error Handling** cho invalid inputs với detailed error structure
- 🔒 **Security Validation** (XSS, SQL injection, sensitive data exposure)
- 🎯 **Technique-Specific Tests**:
  - **EP**: Equivalence class consistency validation
  - **BVA**: Boundary value acceptance/rejection logic
  - **Negative**: Comprehensive error validation and security checks
  - **Combinatorial**: Parameter interaction and dependency testing
  - **Edge**: Unicode, performance, and stability testing

## Notes

- Tất cả API endpoints được prefix với `/api`
- Base URL có thể được thay đổi trong environment variables
- Collections hỗ trợ cả positive và negative test cases
- **Data files bao gồm 82 total test cases** với comprehensive coverage:
  - **30 test cases** cho Products pagination testing
  - **35 test cases** cho Messages validation testing  
  - **17 test cases** cho Categories tree testing
- **Testing techniques đầy đủ**: EP, BVA, Negative, Combinatorial, Edge Cases, Security
- **Advanced validations**: Field-level validation, security testing, performance monitoring
- **Comprehensive logging**: Detailed test results với technique và performance metrics
- Focus vào 3 endpoints chính: GET /products, POST /messages, GET /categories/tree
