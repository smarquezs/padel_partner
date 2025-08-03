# Padel Partner

A Rails application for managing padel partnerships.

## Development with VSCode Dev Containers

This project is configured to work with VSCode Dev Containers for a consistent development environment.

### Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop)
- [VSCode](https://code.visualstudio.com/)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Getting Started

1. Clone the repository
2. Open in VSCode
3. When prompted, click "Reopen in Container" or run the "Dev Containers: Reopen in Container" command
4. Wait for the container to build and dependencies to install

The dev container will automatically:
- Install all Ruby dependencies via bundler
- Install JavaScript dependencies via yarn
- Set up the database
- Configure the development environment

## Testing

This project uses RSpec for testing instead of the default Rails minitest.

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run tests with coverage
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/user_spec.rb

# Run tests matching a pattern
bundle exec rspec -t model
```

### Test Structure

- `spec/models/` - Model unit tests
- `spec/controllers/` - Controller tests
- `spec/requests/` - Request/integration tests
- `spec/system/` - System/feature tests using Capybara
- `spec/factories/` - FactoryBot test data factories
- `spec/support/` - Test configuration and helpers

## Development Setup (without Dev Containers)

### System Dependencies

- Ruby 3.3.7
- PostgreSQL
- Node.js & Yarn

### Configuration

1. Install dependencies:
   ```bash
   bundle install
   yarn install
   ```

2. Set up the database:
   ```bash
   rails db:setup
   ```

3. Run the test suite:
   ```bash
   bundle exec rspec
   ```

4. Start the server:
   ```bash
   rails server
   ```

## Deployment

This application uses Kamal for deployment. See the `.kamal/` directory for configuration.
