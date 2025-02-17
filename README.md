# Rails 8 API Application

## Overview

This is an API-only application built with Rails 8 and Ruby 3.3.4. The application uses SQLite as its database, which runs within a single Docker container for simplified deployment and development.

## Application Structure

### Controllers
- **Application Controller**: Handles top-level error handling for the entire application
- **Receipts Controller**: Manages all API endpoints under the `/receipts` namespace

### Models
- **Receipt**: Primary model for receipt data
- **Item**: Represents individual items associated with receipts

### Validation and Testing
All model-level validations are implemented within their respective model classes. The application includes comprehensive test coverage:
- Controller tests ensuring proper API behavior
- Model tests validating business logic
- Service class tests verifying complex operations

## Local Development with Docker

### Prerequisites
- Docker installed on your machine ([Docker Installation Guide](https://docs.docker.com/get-docker/))

### Setup Steps
1. Clone the repository to your local machine
2. Build the Docker container:
   ```bash
   docker compose build
   ```
3. Start the application:
   ```bash
   docker compose up
   ```
   This command will:
    - Set up the database
    - Run any pending migrations
    - Start the application server

### Running Tests
You can run the test suite from within the Docker container:
```bash
# Run the entire test suite
docker compose run api bundle exec rspec test
```

Note: The first run might take a few moments as it sets up the test database.

## Quality Gates

The following quality checks run automatically on Pull Requests and merges to main:

### Security and Code Quality
- **Brakeman**: Scans for security vulnerabilities
- **Rubocop**: Enforces code style and best practices
- **RSpec**: Runs the full test suite

## Recent Additions

### New Features
- Individual receipt retrieval endpoint with associated items
- Automatic deployment to Heroku on main branch merges
- Health check endpoint at `/up` for monitoring application status

### API Endpoints
- `GET /up`: Health check endpoint
- `GET /receipts/:id`: Retrieve individual receipt with items
- Additional receipt endpoints under `/receipts` namespace

## Deployment

The application automatically deploys to Heroku when changes are merged into the main branch.