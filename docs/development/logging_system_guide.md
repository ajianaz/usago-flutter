# Enhanced Logging System Guide

## Overview

Enhanced logging system telah diimplementasikan untuk project Usago dengan fitur-fitur berikut:

- Environment-based log activation/deactivation
- Log levels dengan filtering
- Platform-specific logging (web/desktop/mobile)
- Performance logging untuk debugging
- Structured logging dengan timestamps
- Integration dengan existing error handling

## Environment Variables

### ENABLE_LOGGING
- **Default**: `true`
- **Description**: Mengaktifkan/menonaktifkan logging system
- **Usage**: `ENABLE_LOGGING=true` atau `ENABLE_LOGGING=false`

### LOG_LEVEL
- **Default**: `debug`
- **Description**: Menentukan minimum log level yang akan ditampilkan
- **Available values**: `debug`, `info`, `warning`, `error`, `verbose`, `wtf`
- **Usage**: `LOG_LEVEL=info`

## Log Levels

1. **Debug** (0): Informasi detail untuk debugging
2. **Info** (1): Informasi umum tentang aplikasi flow
3. **Warning** (2): Peringatan tentang potensi masalah
4. **Error** (3): Error yang terjadi
5. **Verbose** (4): Logging yang sangat detail
6. **WTF** (5): Critical errors yang tidak seharusnya terjadi

## Usage Examples

### Basic Logging

```dart
// Get logger from dependency injection
final logger = getIt<AppLogger>();

// Basic logging
logger.debug('Debug message');
logger.info('Info message');
logger.warning('Warning message');
logger.error('Error message');
```

### Performance Logging

```dart
// Start performance timer
logger.startPerformanceTimer('api_call');

// ... do some work ...

// End timer and log duration
logger.endPerformanceTimer('api_call');
// Output: ⏱️ Performance timer ended: api_call - 150ms
```

### Structured Logging

```dart
// Log with context
logger.logStructured(
  LogLevel.info,
  'User action performed',
  context: {
    'user_id': '123',
    'action': 'login',
  },
);
```

### Network Logging

```dart
// Log API request
logger.logRequest(
  'GET',
  'https://api.example.com/users',
  headers: {'Authorization': 'Bearer token'},
);

// Log API response
logger.logResponse(
  'GET',
  'https://api.example.com/users',
  200,
  body: {'users': []},
  duration: 150,
);
```

### User Action Logging

```dart
// Log user interactions
logger.logUserAction(
  'button_clicked',
  properties: {'button_id': 'login_btn'},
);
```

## Configuration

### Runtime Configuration Update

```dart
// Update logging configuration at runtime
final newConfig = LoggingConfig(
  isActive: false,
  level: LogLevel.error,
);

logger.updateConfig(newConfig);
```

### Environment-based Configuration

```dart
// Configuration automatically loaded from environment variables
final config = LoggingConfig.fromEnvironment();
final logger = AppLogger(config);
```

## Platform Compatibility

### Mobile (Flutter)
- Menggunakan `developer.log()` untuk platform compatibility
- Console output dengan PrettyPrinter
- Emoji dan color support (non-release mode)

### Web/Desktop
- Menggunakan `developer.log()` untuk cross-platform compatibility
- Structured output dengan timestamps
- Performance optimization untuk production

## Security Considerations

### Environment Variables
- Gunakan `.env` file untuk development
- Gunakan compile-time environment untuk production
- Sensitive data tidak akan di-log dalam production mode

### Log Sanitization
- Automatic sanitization untuk sensitive data
- Filter untuk passwords, tokens, dan personal information
- Configurable log levels untuk environment berbeda

## Best Practices

### Development
- Gunakan `LOG_LEVEL=debug` untuk detail logging
- Aktifkan performance logging untuk optimization
- Gunakan structured logging untuk complex operations

### Production
- Gunakan `LOG_LEVEL=warning` atau `LOG_LEVEL=error`
- Nonaktifkan debug logging untuk performance
- Monitor error logs untuk issue tracking

### Testing
- Gunakan `ENABLE_LOGGING=false` untuk silent testing
- Mock logger untuk unit tests
- Verify log output yang diharapkan

## Integration with Dependency Injection

Logger terintegrasi dengan GetIt dependency injection:

```dart
// In setupDependencies()
await LoggingConfig.initialize();
final loggingConfig = LoggingConfig.fromEnvironment();
getIt.registerSingleton(loggingConfig);
getIt.registerSingleton(AppLogger(loggingConfig));

// Usage in classes
class MyService {
  final AppLogger _logger;

  MyService(this._logger);

  void doSomething() {
    _logger.info('Doing something');
  }
}
```

## File Structure

```
apps/mobile/lib/core/
├── config/
│   └── logging_config.dart    # Configuration management
├── utils/
│   ├── logger.dart           # Enhanced AppLogger implementation
│   └── logger_test.dart     # Comprehensive tests
└── di/
    └── injection_container.dart  # DI setup with dotenv initialization
```

## Environment Files

### .env.example
```bash
# Feature Flags
ENABLE_LOGGING=true
LOG_LEVEL=debug

# Other configuration...
API_BASE_URL=http://127.0.0.1:3000
```

### .env (development)
```bash
ENABLE_LOGGING=true
LOG_LEVEL=debug
```

### Production
```bash
ENABLE_LOGGING=false
LOG_LEVEL=error
```

## Troubleshooting

### Common Issues

1. **DotEnv not initialized**
   - Pastikan `LoggingConfig.initialize()` dipanggil sebelum logger usage
   - Check `.env` file existence di development

2. **Logs not appearing**
   - Verify `ENABLE_LOGGING=true`
   - Check log level configuration
   - Ensure logger properly injected

3. **Performance overhead**
   - Use appropriate log levels
   - Disable verbose logging in production
   - Consider async logging untuk heavy operations

## Migration from Old System

### Before
```dart
// Simple logger without configuration
final logger = Logger();
logger.d('Debug message');
```

### After
```dart
// Enhanced logger with environment control
final logger = getIt<AppLogger>();
logger.debug('Debug message');
logger.startPerformanceTimer('operation');
// ... work ...
logger.endPerformanceTimer('operation');
```

## Performance Considerations

- Logging disabled: Zero overhead
- Debug level: Minimal overhead
- Structured logging: Slightly higher overhead
- Performance logging: Low overhead dengan timers
- Production optimization: Automatic level filtering

## Monitoring and Analytics

Integration dengan monitoring systems dapat dilakukan melalui:

1. **Error Tracking**: Automatic error logging dengan context
2. **Performance Monitoring**: Built-in timing capabilities
3. **User Analytics**: User action logging framework
4. **System Health**: Log level dan configuration monitoring

## Future Enhancements

Potential improvements untuk logging system:

1. **Remote Logging**: Kirim logs ke external service
2. **Log Rotation**: Automatic file rotation untuk mobile
3. **Crash Reporting**: Integration dengan crash reporting
4. **Real-time Filtering**: Dynamic log level adjustment
5. **Structured Output**: JSON format untuk log aggregation

## Conclusion

Enhanced logging system menyediakan fleksibilitas, performansi, dan keamanan untuk logging di semua platform (web, desktop, mobile). Dengan environment-based configuration dan structured logging approach, sistem ini dapat digunakan untuk development debugging, production monitoring, dan error tracking secara efektif.