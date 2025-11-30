# Spree V2 Backend API

A comprehensive e-commerce backend API built with Ruby on Rails 8.0, providing a full-featured platform for managing products, orders, users, and payments.

## 🚀 Features

- **Authentication & Authorization**
  - JWT-based authentication with refresh tokens
  - User registration and email confirmation
  - Password reset functionality
  - Role-based access control (RBAC)
  - Google OAuth2 integration

- **Product Management**
  - Product CRUD operations with variants
  - Product attributes and attribute values
  - Product images with S3 storage
  - Category management with hierarchical structure
  - Elasticsearch-powered product search

- **Order Management**
  - Order creation and tracking
  - Order status management
  - Order items with snapshots
  - Refund and return request handling

- **Shopping Cart**
  - Add/remove items from cart
  - Update cart quantities
  - Cart persistence

- **Payment Integration**
  - Stripe payment processing
  - Stripe webhook handling
  - Payment session management

- **Admin Panel**
  - Comprehensive admin API endpoints
  - User management
  - Product and category administration
  - Order management
  - Promotion management

- **API Documentation**
  - Interactive Swagger UI
  - Complete API documentation
  - Request/response schemas

## 🛠 Tech Stack

- **Framework**: Ruby on Rails 8.0.2
- **Database**: PostgreSQL (development/production), SQLite3 (test)
- **Authentication**: Devise + JWT
- **Authorization**: Pundit
- **Search**: Elasticsearch
- **Background Jobs**: Sidekiq
- **Caching**: Redis
- **File Storage**: AWS S3
- **Payment**: Stripe
- **API Documentation**: RSwag (Swagger/OpenAPI)
- **Testing**: RSpec

## 📋 Prerequisites

- Ruby 3.2.2 or higher
- PostgreSQL 12+ (for development/production)
- Redis (for caching and background jobs)
- Elasticsearch (for product search)
- Node.js (for asset compilation)
- AWS S3 account (for file storage)
- Stripe account (for payments)

## 🔧 Installation

### 1. Clone the repository

```bash
git clone <repository-url>
cd spree-v2-backend
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Set up environment variables

Create a `.env` file in the root directory:

```bash
# Database
POSTGRES_USER=your_postgres_user
POSTGRES_PASSWORD=your_postgres_password
POSTGRES_HOST=localhost
POSTGRES_PORT=5432

# JWT
JWT_SECRET_KEY=your_jwt_secret_key_here

# Redis
REDIS_URL=redis://localhost:6379/0

# AWS S3
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_REGION=us-east-1
AWS_BUCKET=your_bucket_name

# Stripe
STRIPE_SECRET_KEY=your_stripe_secret_key
STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
STRIPE_WEBHOOK_SECRET=your_stripe_webhook_secret

# Email (Gmail)
GMAIL_USERNAME=your_email@gmail.com
GMAIL_APP_PASSWORD=your_app_password

# Google OAuth
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
```

### 4. Set up the database

```bash
# Create database
rails db:create

# Run migrations
rails db:migrate

# (Optional) Seed database
rails db:seed
```

### 5. Set up Elasticsearch

Make sure Elasticsearch is running on your system:

```bash
# macOS
brew install elasticsearch
brew services start elasticsearch

# Linux
sudo systemctl start elasticsearch

# Or using Docker
docker run -d -p 9200:9200 -p 9300:9300 elasticsearch:8.0.0
```

### 6. Start Redis

```bash
# macOS
brew services start redis

# Linux
sudo systemctl start redis

# Or using Docker
docker run -d -p 6379:6379 redis:latest
```

## 🚀 Running the Application

### Development Server

```bash
rails server
```

The API will be available at `http://localhost:3000`

### Background Jobs (Sidekiq)

In a separate terminal:

```bash
bundle exec sidekiq
```

Sidekiq web UI will be available at `http://localhost:3000/sidekiq` (if configured)

## 📚 API Documentation

### Swagger UI

Once the server is running, access the interactive API documentation at:

```
http://localhost:3000/api-docs
```

The Swagger UI provides:
- Complete API endpoint documentation
- Interactive API testing
- Request/response schemas
- Authentication support

### API Endpoints Overview

#### Authentication (`/api/auth`)
- `POST /api/auth` - User registration
- `POST /api/auth/sign_in` - User login
- `POST /api/auth/sign_out` - User logout
- `POST /api/auth/refresh` - Refresh access token
- `POST /api/auth/reset_password` - Request password reset
- `PATCH /api/auth/reset_password` - Reset password
- `POST /api/auth/confirm_email` - Confirm email
- `POST /api/auth/resend_confirmation` - Resend confirmation email

#### Client Endpoints (`/api/client`)
- `GET /api/client/products` - List products (with search/filter)
- `GET /api/client/products/:id` - Get product details
- `GET /api/client/categories` - List categories
- `GET /api/client/cart` - Get cart items
- `POST /api/client/cart` - Add item to cart
- `PATCH /api/client/cart` - Update cart items
- `DELETE /api/client/cart/:id` - Remove item from cart
- `GET /api/client/orders` - List user orders
- `POST /api/client/orders` - Create order
- `PATCH /api/client/orders/:id` - Update order
- `GET /api/client/user_profiles` - Get user profile
- `PATCH /api/client/user_profiles` - Update user profile

#### Admin Endpoints (`/api/admin`)
- `GET /api/admin/products` - List all products
- `POST /api/admin/products` - Create product
- `PATCH /api/admin/products/:id` - Update product
- `DELETE /api/admin/products/:id` - Delete product
- `POST /api/admin/products/:id/restore` - Restore deleted product
- `GET /api/admin/categories` - List categories
- `GET /api/admin/orders` - List all orders
- `GET /api/admin/me` - Get current admin user

#### Payment (`/api/payment`)
- `POST /api/payment/stripe` - Create Stripe payment session
- `POST /api/payment/repaid_stripe` - Repay with Stripe
- `POST /api/payment/stripe/web_hook` - Stripe webhook handler

## 🧪 Testing

### Run all tests

```bash
bundle exec rspec
```

### Run specific test file

```bash
bundle exec rspec spec/models/product_spec.rb
```

### Generate Swagger documentation

```bash
RAILS_ENV=test bundle exec rake rswag:specs:swaggerize
```

## 📁 Project Structure

```
spree-v2-backend/
├── app/
│   ├── controllers/
│   │   ├── api/
│   │   │   ├── admin/          # Admin API controllers
│   │   │   ├── auth/           # Authentication controllers
│   │   │   └── client/         # Client API controllers
│   │   └── concerns/           # Shared controller concerns
│   ├── models/                 # ActiveRecord models
│   ├── serializers/            # API response serializers
│   ├── services/               # Business logic services
│   ├── forms/                  # Form objects for validation
│   ├── policies/               # Pundit authorization policies
│   ├── jobs/                   # Background jobs
│   └── middlewares/            # Custom middleware
├── config/
│   ├── routes.rb               # API routes
│   ├── initializers/           # Rails initializers
│   └── environments/           # Environment configurations
├── db/
│   ├── migrate/                # Database migrations
│   └── schema.rb               # Database schema
├── spec/
│   ├── requests/               # API request specs (Swagger)
│   ├── models/                 # Model specs
│   └── factories/              # FactoryBot factories
└── swagger/                    # Generated Swagger documentation
```

## 🔐 Authentication

The API uses JWT (JSON Web Tokens) for authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your_jwt_token>
```

### Getting a Token

1. Register a new user: `POST /api/auth`
2. Login: `POST /api/auth/sign_in`
3. Use the returned `access_token` in subsequent requests
4. Refresh token when expired: `POST /api/auth/refresh`

## 🔄 Background Jobs

The application uses Sidekiq for background job processing:

- Email sending (confirmation, password reset)
- Product synchronization with Stripe
- Data updates to Redis
- Order auto-cancellation

## 📦 Database

### Migrations

```bash
# Create a new migration
rails generate migration MigrationName

# Run migrations
rails db:migrate

# Rollback last migration
rails db:rollback
```

### Database Schema

The application uses PostgreSQL with the following main tables:
- `account_users` - User accounts
- `products` - Products catalog
- `product_variants` - Product variants
- `categories` - Product categories
- `orders` - Customer orders
- `cart_items` - Shopping cart items
- `payments` - Payment records
- `roles` - User roles
- `permissions` - Role permissions

## 🐳 Docker

The project includes Docker configuration. To run with Docker:

```bash
docker-compose up
```

## 🔍 Search

Product search is powered by Elasticsearch. To index products:

```bash
rails console
Product.import
```

## 📝 Code Quality

### Linting

```bash
bundle exec rubocop
```

### Security Scanning

```bash
bundle exec brakeman
```

## 🌍 CORS Configuration

CORS is configured to allow requests from:
- `http://localhost:5173` (development frontend)
- `http://localhost:3000` (local API)
- `http://127.0.0.1:3000` (local API)

Update `config/initializers/cors.rb` for production origins.

## 📄 License

[Add your license here]

## 👥 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

For support, email [your-email@example.com] or open an issue in the repository.

## 🙏 Acknowledgments

- Built with [Ruby on Rails](https://rubyonrails.org/)
- API documentation powered by [RSwag](https://github.com/rswag/rswag)
- Authentication by [Devise](https://github.com/heartcombo/devise)
