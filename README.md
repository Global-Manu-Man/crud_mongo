# Express MongoDB CRUD API

A RESTful API implementing CRUD operations with Express.js and MongoDB, following best practices for error handling, response formatting, and security.

## API Response Format

### Success Response
```json
{
  "success": true,
  "status": 200,
  "data": { },
  "message": "Optional success message"
}
```

### Error Response
```json
{
  "success": false,
  "status": 400,
  "error": {
    "message": "Error message"
  }
}
```

## Error Handling

- Centralized error handling through middleware
- Consistent HTTP status codes and error messages
- Stack traces only shown in development environment
- Standardized error response format

## Environment Variables

```env
NODE_ENV=development         # Environment (development/production)
PORT=3001                   # Server port
MONGODB_URI=mongodb://...   # MongoDB connection string
API_VERSION=v1             # API version
RATE_LIMIT_WINDOW_MS=900000 # Rate limiting window (15 minutes)
RATE_LIMIT_MAX=100         # Maximum requests per window
```

## Docker Setup

### Prerequisites
- Docker installed on your system
- Docker Compose installed on your system

### Development Environment

1. Build and start the development environment:
```bash
docker-compose -f docker-compose.dev.yml build
docker-compose -f docker-compose.dev.yml up -d
```

2. View logs:
```bash
docker-compose -f docker-compose.dev.yml logs -f api
```

3. Stop the development environment:
```bash
docker-compose -f docker-compose.dev.yml down
```

### Production Environment

1. Build and start the production environment:
```bash
docker-compose -f docker-compose.prod.yml build
docker-compose -f docker-compose.prod.yml up -d
```

2. View logs:
```bash
docker-compose -f docker-compose.prod.yml logs -f api
```

3. Stop the production environment:
```bash
docker-compose -f docker-compose.prod.yml down
```

### Docker Commands Reference

- Check running containers:
```bash
docker ps
```

- Check container logs:
```bash
docker logs express-mongodb-api-dev  # For development
docker logs express-mongodb-api-prod # For production
```

- Enter container shell:
```bash
docker exec -it express-mongodb-api-dev sh  # For development
docker exec -it express-mongodb-api-prod sh # For production
```

- Remove all containers and networks:
```bash
docker-compose -f docker-compose.dev.yml down --volumes # Development
docker-compose -f docker-compose.prod.yml down --volumes # Production
```

## Traditional Installation (Without Docker)

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```
3. Set up environment variables (copy .env.example to .env)
4. Start the server:
   ```bash
   npm run dev    # Development
   npm start      # Production
   ```

## Best Practices

- **Pagination**: Implemented for list endpoints
- **Rate Limiting**: Protect against abuse
- **API Versioning**: Routes prefixed with `/api/v1`
- **Health Check**: Endpoint to monitor API status
- **Data Validation**: Prevent duplicate entries
- **Field Selection**: Exclude unnecessary fields
- **HTTP Status Codes**: Appropriate response codes

## Security Measures

- Rate limiting to prevent abuse
- Data sanitization
- Sensitive information protection
- CORS configuration
- Input validation

## API Endpoints

| Method | Endpoint           | Description                    |
|--------|-------------------|--------------------------------|
| GET    | /api/v1/users     | List users (with pagination)   |
| POST   | /api/v1/users     | Create new user               |
| GET    | /api/v1/users/:id | Get user by ID                |
| PUT    | /api/v1/users/:id | Update user                   |
| DELETE | /api/v1/users/:id | Delete user                   |
| GET    | /health          | Server health status           |

## Request Examples

### Create User
```bash
POST /api/v1/users
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "age": 30
}
```

### Update User
```bash
PUT /api/v1/users/:id
Content-Type: application/json

{
  "name": "John Updated",
  "age": 31
}
```

## Development

- Uses ES Modules
- Nodemon for development auto-reload
- Consistent code formatting
- Modular architecture