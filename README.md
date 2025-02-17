# Rails 8 API Application

## Overview

This is an API-only application built with Rails 8 and Ruby 3.3.4. 
The application uses SQLite as its database for development and test, which runs within a single Docker container 
for simplified deployment and development. The docker build and production builds use a single Postgres instance for the main database, 
cache, and queue instances for reduced cost. 

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

4. Use the API!
   ```
   # Create a receipt
   curl -X POST http://localhost:3000/receipts/process -H "Content-Type: application/json" -d '{"retailer": "Target", "purchaseDate": "2022-01-02", "purchaseTime": "13:13", "total": "1.25", "items": [{"shortDescription": "Pepsi - 12-oz", "price": "1.25"}]}'

   # Using the ID returned from the POST: 
   curl -v http://localhost:3000/receipts/{id}/points
   ```

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


### Dependency Management

The project uses GitHub's Dependabot to automatically monitor and update dependencies:

- **Scope:** Monitors both Ruby gems and GitHub Actions
- **Update Schedule:** Checks for updates daily
- **Pull Requests:** Automatically creates PRs for:

  - Security updates (high priority)
  - Version updates for direct dependencies
  - GitHub Actions version updates

**Configuration:** See [.github/dependabot.yml](.github/dependabot.yml) for detailed settings
**Auto-merge:** Enabled for patch and minor version updates that pass all checks

Pull Requests from Dependabot trigger the same quality gates as regular PRs, ensuring updates don't break existing functionality.

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

## Health Checks

Uptime of the application is being monitored by pingdom using the /up route. 
Texts and emails will be sent when the application doesn't respond with a 200. 
