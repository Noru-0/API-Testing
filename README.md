# API TESTING WITH POSTMAN, NEWMAN & GITHUB ACTIONS

## Mục tiêu
- Làm quen với kiểm thử API bằng Postman.
- Thực hiện kiểm thử data-driven với file CSV.
- Tích hợp kiểm thử tự động với Newman và GitHub Actions.

---

## 1. Cấu trúc thư mục

```
api-automation-practice/
├── .github/
│   └── workflows/
│       └── api-test.yml         # File workflow GitHub Actions
├── sprint5/
│   └── API/                     # Laravel API source code
├── tests/
│   ├── environment.json         # Environment Postman chung
│   ├── collections/             # Postman collections
│   │   ├── products_collection.json
│   │   ├── messages_collection.json
│   │   └── categories_collection.json
│   ├── data/                    # Data files cho data-driven testing
│   │   ├── products_pagination_data.csv
│   │   ├── products_search_data.csv
│   │   ├── products_by_id_data.csv
│   │   ├── messages_data.csv
│   │   ├── messages_by_id_data.csv
│   │   ├── categories_pagination_data.csv
│   │   ├── categories_search_data.csv
│   │   └── categories_by_id_data.csv
│   └── README.md                # Hướng dẫn sử dụng tests
├── run-api-tests.sh             # Script chạy tất cả tests (bash)
├── run-api-tests.ps1            # Script chạy tất cả tests (powershell)
├── run-individual-tests.sh      # Script chạy tests riêng lẻ (bash)
├── run-individual-tests.ps1     # Script chạy tests riêng lẻ (powershell)
└── README.md                    # File hướng dẫn này
```

---

## 2. Các API Endpoints được test

### 🛍️ Products API
- **GET /api/products** - Retrieve all products (có pagination)
- **GET /api/products/search** - Search products
- **GET /api/products/{id}** - Get product by ID

### 📧 Messages API  
- **POST /api/messages** - Send new contact message
- **GET /api/messages** - Get all messages
- **GET /api/messages/{id}** - Get message by ID

### 📂 Categories API
- **GET /api/categories** - Retrieve all categories (có pagination)
- **GET /api/categories/tree** - Get categories tree (including subcategories)
- **GET /api/categories/search** - Search categories
- **GET /api/categories/tree/{id}** - Get category by ID

---

## 3. Cách sử dụng

### 3.1. Khởi động ứng dụng

```bash
# Khởi động các container Docker
docker compose up -d

# Chờ khoảng 60 giây để các service khởi động hoàn tất

# Tạo database và dữ liệu mẫu
docker compose exec laravel-api php artisan migrate:fresh --seed --force

# Kiểm tra ứng dụng: http://localhost:8091 (API), http://localhost:8092 (UI)
```

### 3.2. Chạy tất cả tests

**Linux/Mac:**
```bash
chmod +x run-api-tests.sh
./run-api-tests.sh
```

**Windows PowerShell:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\run-api-tests.ps1
```

### 3.3. Chạy tests riêng lẻ

**Linux/Mac:**
```bash
chmod +x run-individual-tests.sh
./run-individual-tests.sh products    # Chỉ test Products API
./run-individual-tests.sh messages    # Chỉ test Messages API
./run-individual-tests.sh categories  # Chỉ test Categories API
./run-individual-tests.sh all         # Test tất cả (default)
```

**Windows PowerShell:**
```powershell
.\run-individual-tests.ps1 products    # Chỉ test Products API
.\run-individual-tests.ps1 messages    # Chỉ test Messages API
.\run-individual-tests.ps1 categories  # Chỉ test Categories API
.\run-individual-tests.ps1 all         # Test tất cả (default)
```

### 3.4. Import vào Postman

1. Import file `tests/environment.json`
2. Import các collection từ thư mục `tests/collections/`
3. Chạy collection với data file tương ứng từ thư mục `tests/data/`

---

## 4. Data-driven Testing

Mỗi collection sử dụng CSV files để thực hiện data-driven testing với nhiều test scenarios:

- ✅ **Positive test cases** - Valid data, expected success
- ❌ **Negative test cases** - Invalid data, expected failures  
- 🔍 **Edge cases** - Boundary values, special characters
- 📊 **Pagination testing** - Different page sizes and numbers
- 🔎 **Search testing** - Various search terms and patterns

---

## 5. GitHub Actions CI/CD

### 5.1. Thiết lập Secrets

Trong GitHub repository settings, tạo các secrets:
- `APP_KEY` - Laravel application key
- `DB_DATABASE` - Database name
- `DB_USERNAME` - Database username  
- `DB_PASSWORD` - Database password
- `JWT_SECRET` - JWT secret key

### 5.2. Workflow tự động

File `.github/workflows/api-test.yml` sẽ:
1. Khởi động Docker containers
2. Setup Laravel application
3. Chạy tất cả API tests với Newman
4. Tạo HTML reports
5. Upload reports lên Artifacts
6. Cleanup resources

---

## 6. Reports & Results

Sau khi chạy tests, check các file báo cáo trong thư mục `reports/`:

- `products_pagination_report.html`
- `products_search_report.html`  
- `products_by_id_report.html`
- `messages_report.html`
- `messages_by_id_report.html`
- `categories_pagination_report.html`
- `categories_search_report.html`
- `categories_by_id_report.html`

---

## 7. 🔧 Khắc phục sự cố

**Nếu lệnh tạo database bị lỗi:**
```bash
# Cài đặt PHP dependencies
docker compose run --rm composer

# Chạy lại database setup
docker compose exec laravel-api php artisan migrate:fresh --seed --force
```

**Các lỗi thường gặp:**
- ❌ `Class not found` → Chạy `docker compose run --rm composer`
- ❌ `Database connection failed` → Kiểm tra file .env và chờ
- ❌ `Permission denied` → Chạy `chmod +x *.sh`

---

**Chúc các bạn testing thành công! 🚀**