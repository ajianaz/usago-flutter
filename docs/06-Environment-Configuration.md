# Environment Configuration

This document explains how to use environment configuration in the Usago Flutter mobile app.

## Overview

The app uses `flutter_dotenv` package to manage environment-specific configurations. This allows different settings for development, staging, and production environments.

## File Structure

```
apps/mobile/
├── .env                    # Default environment (development)
├── .env.example           # Template for environment variables
├── .env.development       # Development-specific configuration
├── .env.staging          # Staging-specific configuration
├── .env.production       # Production-specific configuration
└── lib/core/config/
    ├── env_config.dart   # Environment management class
    └── app_config.dart   # Application configuration class
```

## Environment Files

### .env.example
Template file that shows all available environment variables. Copy this file to create your own `.env` file.

### .env.development
Configuration for development environment. Used when building in debug mode.

### .env.staging
Configuration for staging environment. Used when building in profile mode.

### .env.production
Configuration for production environment. Used when building in release mode.

## Setup Instructions

### 1. Copy the template file
```bash
cp .env.example .env
```

### 2. Update the values
Edit the `.env` file with your specific configuration values.

### 3. Environment-specific files (optional)
If you need different configurations for different environments, create the appropriate files:
- `.env.development` for development
- `.env.staging` for staging
- `.env.production` for production

## Available Environment Variables

### API Configuration
- `API_BASE_URL`: Base URL for API endpoints
- `API_VERSION`: API version
- `API_TIMEOUT`: API timeout in milliseconds

### Headers
- `CONTENT_TYPE_HEADER`: Content-Type header value
- `ACCEPT_HEADER`: Accept header value
- `BEARER_TOKEN_HEADER`: Authorization header name

### Response Codes
- `SUCCESS_CODE`: HTTP success status code
- `UNAUTHORIZED_CODE`: HTTP unauthorized status code
- `FORBIDDEN_CODE`: HTTP forbidden status code
- `NOT_FOUND_CODE`: HTTP not found status code
- `SERVER_ERROR_CODE`: HTTP server error status code

### Feature Flags
- `ENABLE_LOGGING`: Enable/disable logging
- `ENABLE_CRASH_REPORTING`: Enable/disable crash reporting
- `ENABLE_ANALYTICS`: Enable/disable analytics

### Security
- `ENCRYPTION_KEY`: Encryption key for sensitive data
- `JWT_SECRET`: JWT secret for token validation

### External Services
- `SENTRY_DSN`: Sentry DSN for error tracking
- `FIREBASE_API_KEY`: Firebase API key

### Debug Settings
- `DEBUG_MODE`: Enable/disable debug mode
- `LOG_LEVEL`: Log level (debug, info, warning, error)

## Usage in Code

### Accessing Configuration Values

```dart
import 'package:usago/core/config/app_config.dart';

// Get API base URL
final baseUrl = AppConfig.apiBaseUrl;

// Get API timeout
final timeout = AppConfig.apiTimeout;

// Check if logging is enabled
if (AppConfig.enableLogging) {
  // Log something
}

// Check current environment
if (AppConfig.isDevelopment) {
  // Development-specific code
}
```

### Environment Information

```dart
// Get current environment name
final env = AppConfig.environment; // 'development', 'staging', or 'production'

// Check environment
if (AppConfig.isProduction) {
  // Production-specific code
}
```

### Validation

```dart
// Validate required environment variables
final missingVars = AppConfig.validateRequiredVariables();
if (missingVars.isNotEmpty) {
  // Handle missing variables
  print('Missing: ${missingVars.join(', ')}');
}
```

## Environment Loading Logic

The app automatically loads the appropriate environment file based on the build mode:

- **Debug Mode**: Loads `.env` or `.env.development`
- **Profile Mode**: Loads `.env.staging`
- **Release Mode**: Loads `.env.production`

You can also manually specify which file to load:

```dart
await EnvConfig.initialize(envFileName: '.env.custom');
```

## Security Considerations

1. **Never commit `.env` files** to version control. They are already included in `.gitignore`.
2. **Use different values** for each environment, especially for secrets and API keys.
3. **Rotate secrets** regularly and update environment files accordingly.
4. **Use environment-specific files** for different deployment targets.

## Debug Information

In debug mode, you can print the current configuration:

```dart
AppConfig.debugPrintConfig();
```

This will display all current configuration values (only in debug mode).

## Troubleshooting

### Missing Environment Variables
If required environment variables are missing, the app will:
- Print a warning in debug mode
- Throw an exception in production mode

### Loading Errors
If environment loading fails, the app will:
- Fall back to development environment
- Print an error message in debug mode
- Continue with default values

### Common Issues

1. **Environment not initialized**: Make sure `EnvConfig.initialize()` is called before accessing configuration values.
2. **Missing .env file**: Copy `.env.example` to `.env` and update the values.
3. **Wrong file loaded**: Check the build mode and ensure the correct environment file exists.

## Best Practices

1. **Always use environment variables** for configuration values that change between environments.
2. **Validate required variables** at app startup.
3. **Use feature flags** to enable/disable functionality based on environment.
4. **Keep secrets secure** and never commit them to version control.
5. **Document new environment variables** in this file when adding them.