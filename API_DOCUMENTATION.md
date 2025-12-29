# API_DOCUMENTATION.md

# SSO Identity Provider API Documentation

## Authentication

All API requests require authentication using API keys.

### Headers Required
X-API-Key: your_api_key
X-API-Secret: your_api_secret
Content-Type: application/json

### Getting API Credentials

1. Log in to the admin dashboard
2. Navigate to Organization Settings
3. Generate or view your API credentials

## Base URL
Development: http://localhost:3000/api/v1
Production: https://your-domain.com/api/v1

## Endpoints

### Service Providers

#### List All Service Providers
GET /api/v1/service_providers

Response:
```json
[
  {
    "id": 1,
    "name": "My App",
    "entity_id": "https://myapp.com",
    "acs_url": "https://myapp.com/saml/acs",
    "active": true,
    "created_at": "2024-01-01T00:00:00.000Z"
  }
]
```

#### Get Service Provider
GET /api/v1/service_providers/:id

#### Create Service Provider
POST /api/v1/service_providers
{
"service_provider": {
"name": "My App",
"entity_id": "https://myapp.com",
"acs_url": "https://myapp.com/saml/acs",
"active": true
}
}

#### Update Service Provider
PATCH /api/v1/service_providers/:id
{
"service_provider": {
"name": "Updated Name"
}
}

#### Delete Service Provider
DELETE /api/v1/service_providers/:id

### Users

#### List All Users
GET /api/v1/users

#### Create User
POST /api/v1/users
{
"user": {
"email": "user@example.com",
"first_name": "John",
"last_name": "Doe",
"role": "user"
}
}

## Error Responses

### 401 Unauthorized
```json
{
  "error": "Missing API credentials"
}
```

### 403 Forbidden
```json
{
  "error": "Organization is inactive"
}
```

### 404 Not Found
```json
{
  "error": "Record not found"
}
```

### 422 Unprocessable Entity
```json
{
  "error": "Validation failed",
  "details": ["Email can't be blank"]
}
```

## Rate Limiting

- 100 requests per minute per API key
- 1000 requests per hour per API key

## Support

For API support, contact: api-support@your-domain.com