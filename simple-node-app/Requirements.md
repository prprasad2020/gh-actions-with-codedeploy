# Created this Simple NodeJS App with CRUD operations

## Functional Requirements

Users should be able to,
1. add new Services
2. update existing Services
3. delete existing Services
4. view existing Services

## Non-Functional Requirements

Should handle multiple Services
Handles Load


## API Design

### Service
- Name: string
- Language: string
- Version: string

### Endpoints

1. Create Service
- HTTP POST
- URL: /v1/service
- Request: Service Data
- Response: 200: Service create / 500: Application Error

2. Update Service
- HTTP PUT
- URL: /v1/service/:id
- Request body: Service Data
- Response: 200: Service create / 500: Application Error

3. Delete Service
- HTTP DELETE
- URL: /v1/service/:id
- Request: Service Data
- Response: 200: Service delete / 500: Application Error

3. Get Service by ID
- HTTP GET
- URL: /v1/service/:id
- Request: Service Data
- Response: 200: Service view / 404: Service Not Found / 500: Application Error

4. Get All Services
- HTTP GET
- URL: /v1/services
- Request: Service Data
- Response: 200: Services view / 404: Services Not Found / 500: Application Error
