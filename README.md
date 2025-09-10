# Spree V2 Backend

A modern e-commerce backend API built with Ruby on Rails, featuring comprehensive product management, user
authentication, payment processing, and search capabilities.

## Technology Stack

| Category                           | Technology               | Version | Purpose                             |
|------------------------------------|--------------------------|---------|-------------------------------------|
| **Backend Framework**              | Ruby on Rails            | 8.0.2   | Modern web application framework    |
|                                    | Ruby                     | 3.2.2   | Programming language                |
| **Database**                       | PostgreSQL               | 15      | Primary database                    |
| **Authentication & Authorization** | Devise                   | 4.9     | User authentication                 |
|                                    | Devise JWT               | Latest  | JWT token authentication            |
|                                    | Pundit                   | 2.5     | Authorization policies              |
|                                    | Omniauth                 | Latest  | OAuth integration                   |
|                                    | Google OAuth2            | Latest  | Social login                        |
| **Background Jobs & Caching**      | Sidekiq                  | Latest  | Background job processing           |
|                                    | Sidekiq Cron             | Latest  | Scheduled jobs                      |
|                                    | Redis                    | Latest  | Caching and job queue storage       |
| **Search & Analytics**             | Elasticsearch            | 9.1.0   | Full-text search engine             |
|                                    | Elasticsearch Model      | Latest  | Rails integration for Elasticsearch |
| **Payment Processing**             | Stripe                   | Latest  | Payment gateway integration         |
|                                    | Stripe Event             | Latest  | Webhook handling                    |
| **File Storage & Media**           | AWS S3                   | 1.194   | Cloud file storage                  |
| **API & Serialization**            | Active Model Serializers | Latest  | JSON API serialization              |
|                                    | Rack CORS                | Latest  | Cross-origin resource sharing       | 
| **Development & Testing**          | RSpec                    | Latest  | Testing framework                   |
|                                    | Faker                    | 3.5     | Test data generation                |
| **Infrastructure & Deployment**    | Docker                   | Latest  | Containerization                    |
|                                    | Docker Compose           | Latest  | Multi-container orchestration       | 
| **Additional Libraries**           | Kaminari                 | Latest  | Pagination                          |
|                                    | Paranoia                 | Latest  | Soft delete functionality           |
|                                    | Dotenv Rails             | Latest  | Environment variable management     |

### Frontend Technology Stack (React.js)

| Category             | Technology               | Purpose             |
|----------------------|--------------------------|---------------------|
| **Framework**        | React 18+                | UI framework        |
|                      | TypeScript               | Type safety         |
|                      | Vite                     | Build tool          |
| **State Management** | Redux Toolkit            | Global state        |
|                      | React Query              | Server state        |
| **UI Library**       | Material-UI / Ant Design | Component library   |
|                      | Styled Components        | CSS-in-JS           |
| **Routing**          | React Router             | Client-side routing |
| **Forms**            | React Hook Form          | Form handling       |
|                      | Yup / Zod                | Validation          |
| **HTTP Client**      | RTK Query                | API calls           |

## Services

- **Redis**: Caching and job queue
- **Elasticsearch**: Search functionality
- **PostgreSQL**: Primary database

## Project Development Estimate

### Backend Tasks (Rails API)

| Phase                      | Task                                           | Hours | Status |
|----------------------------|------------------------------------------------|-------|--------|
| **Setup & Infrastructure** | Project setup, Docker                          | 1     | Done   |
| **Authentication System**  | JWT auth, OAuth, user management, login Google | 10    | Done   |
| **User Management**        | Profiles, roles, permissions                   | 5     | Done   |
| **Product Management**     | CRUD, variants, attributes                     | 12    | Done   |
| **Category Management**    | Categories, subcategories                      | 1     | Done   |
| **Shopping Cart**          | CRUD                                           | 8     | Done   |
| **Order Management**       | CRUD Order, Order Item                         | 6     | Done   |
| **Payment Integration**    | Stripe integration, webhooks                   | 5     | Done   |
| **Email System**           | Gmail SMTP API                                 | 1     | Done   |
| **Authorization**          | RBAC Model                                     |       |        |
| **Search & Filtering**     | ElasticSearch                                  |       |        |
| **Export Data**            |                                                |       |        |
| **Testing**                |                                                |       |        |
| **Performance**            |                                                |       |        |
| **Deployment**             |                                                |       |        |
| **TOTAL**                  | **Backend Development**                        |       |        |

### Frontend Tasks (React.js)

| Phase                         | Task                                                    | Hours | Status |
|-------------------------------|---------------------------------------------------------|-------|--------|
| **Layout**                    | Project setup, Vite, TypeScript, Cliend and Admin Pages | 3     | Done   |
| **Redux**                     | Config Redux, Redux Toolkit                             | 3     | Done   |
| **Admin Category Management** |                                                         |       |        |
| **TOTAL**                     | **Frontend Development**                                | ****  |        |
