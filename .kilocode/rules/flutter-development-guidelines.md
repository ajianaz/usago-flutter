## Brief overview
Project-specific guidelines for Flutter development that emphasize documentation-first approach, testing, and focused implementation based on the existing codebase structure.

## Documentation adherence
- Always refer to the 'docs' directory before starting any task to ensure synchronization and clarity
- Follow all patterns already defined in the documentation
- Update relevant documentation immediately after implementation
- The docs directory contains both development/ and task/ subdirectories with important guidelines

## Testing requirements
- Create small, clear unit tests for every new function or class
- Ensure tests have a defined flow from start to finish
- Run tests periodically and manage using a checklist that records the last check date
- Test files should follow the existing structure in the test/ directory
- Test files just 100 - 350 lines only, not more. Make it simple and little per file.
- Target test coverage minimum 80% untuk semua fitur kritis

## Development approach
- Focus on improvements that match specific user needs and directions
- Avoid over-development or adding features outside the defined scope
- Follow the existing clean architecture pattern with data/domain/presentation layers
- Maintain the existing dependency injection structure

## Code organization
- Follow the existing feature-based structure in lib/features/
- Maintain separation between data, domain, and presentation layers
- Use the existing naming conventions for files and directories
- Keep the shared widgets and utilities in their respective directories

## Implementation workflow
- Check docs/development/ and docs/task/ directories first
- Follow the patterns defined in architecture_rules.md and implementation_guide.md
- Update relevant task documentation after completing work
- Ensure all tests pass before considering a task complete

## Security Implementation
### Enkripsi Data
- Gunakan AES-256-GCM untuk enkripsi data sensitif (lihat `lib/core/utils/encryption_util.dart`)
- Implementasikan certificate pinning untuk koneksi API
- Gunakan request signing untuk endpoint kritis
- Simpan kunci enkripsi dengan aman menggunakan secure storage

### Secure Storage
- Gunakan `EnhancedSecureStorageService` untuk data sensitif
- Jangan simpan password atau token di plain text
- Implementasikan auto-clear untuk session data yang expired
- Gunakan `SecureEnvConfig` untuk konfigurasi environment sensitif

### Authentication & Authorization
- Implementasikan token refresh mechanism
- Gunakan refresh token dengan rotasi yang aman
- Validasi token pada setiap request yang memerlukan autentikasi
- Implementasikan logout dari semua devices

## Performance Monitoring
### Performance Tracking
- Gunakan `PerformanceTracker` untuk monitoring performa aplikasi
- Implementasikan performance metrics untuk critical paths
- Monitor app startup time dan screen load time
- Gunakan `PerformanceService` untuk centralized monitoring

### Memory Management
- Implementasikan `MemoryManager` untuk optimalisasi memori
- Monitor memory leaks pada BLoC dan controllers
- Gunakan proper disposal untuk resources yang tidak digunakan
- Implementasikan memory caching strategy yang efisien

### BLoC Monitoring
- Gunakan `BlocMonitor` untuk tracking BLoC performance
- Monitor event processing time dan state transitions
- Implementasikan proper error handling di BLoC level
- Gunakan `BlocLoadingHelper` untuk loading state management

## Environment Configuration
### Multi-Environment Setup
- Gunakan environment files: `.env.development`, `.env.staging`, `.env.production`
- Implementasikan `EnvConfig` untuk environment-specific settings
- Gunakan `AppConfig` untuk application-wide configuration
- Pastikan sensitive data tidak di-include di version control

### Configuration Management
- Gunakan `SecureEnvConfig` untuk sensitive configuration
- Implementasikan configuration validation pada app startup
- Gunakan environment-specific API endpoints
- Pastikan fallback values untuk missing configuration

## Internationalization
### Slang Implementation
- Gunakan slang package untuk internationalization (lihat `lib/i18n/`)
- Implementasikan dynamic language switching
- Gunakan `LocaleService` untuk locale management
- Support untuk Bahasa Indonesia dan English

### Translation Management
- Simpan translation files di `lib/i18n/` dengan format yang konsisten
- Gunakan keys yang deskriptif dan hierarkis
- Implementasikan fallback language untuk missing translations
- Test semua UI elements dengan multiple languages

## UI/UX Guidelines
### Theme System
- Gunakan `ThemeProvider` untuk theme management
- Implementasikan light dan dark themes
- Gunakan `AppColors`, `AppTextStyles`, dan `AppSpacing` yang konsisten
- Pastikan contrast ratio yang memenuhi accessibility standards

### Responsive Design
- Gunakan `ResponsiveBuilder` untuk adaptive layouts
- Implementasikan breakpoint yang konsisten
- Gunakan `ResponsiveLayout` untuk complex layouts
- Test UI pada multiple screen sizes

### Micro-interactions
- Implementasikan micro-interactions untuk user feedback
- Gunakan `AnimatedButton`, `GestureFeedback`, dan `InteractiveInput`
- Pastikan animasi smooth dan tidak mengganggu performance
- Gunakan `AnimationUtils` untuk reusable animations

## Architecture Patterns
### BaseBloc Implementation
- Gunakan `BaseBloc` sebagai foundation untuk semua BLoC
- Implementasikan proper error handling di base level
- Gunakan consistent state management patterns
- Implementasikan loading dan error states yang konsisten

### RepositoryMixin Usage
- Gunakan `RepositoryMixin` untuk common repository operations
- Implementasikan caching strategy di repository level
- Gunakan proper error mapping dari data source ke domain
- Implementasikan offline-first approach jika diperlukan

### DataSourceMixin Implementation
- Gunakan `DataSourceMixin` untuk common data source operations
- Implementasikan proper error handling di data source level
- Gunakan consistent response format
- Implementasikan retry mechanism untuk network failures

## Testing Strategy
### Unit Testing
- Test semua business logic di domain layer
- Mock dependencies untuk isolated testing
- Gunakan `test_helpers.dart` untuk common test utilities
- Target coverage minimum 80% untuk critical paths

### Widget Testing
- Test semua custom widgets dengan multiple scenarios
- Gunakan `mock_builders.dart` untuk complex widget testing
- Test widget interactions dan state changes
- Implementasikan golden tests untuk UI consistency

### Integration Testing
- Test complete user flows dari UI ke data layer
- Implementasikan end-to-end testing untuk critical paths
- Gunakan real API endpoints untuk integration testing
- Test error scenarios dan recovery flows

## Code Quality
### Code Review Checklist
- Pastikan code mengikuti existing patterns
- Verify semua tests pass dan coverage adequate
- Check error handling dan edge cases
- Validate performance implications
- Ensure documentation updated

### Formatting Standards
- Gunakan `dart format` untuk code formatting
- Implementasikan `analysis_options.yaml` rules
- Gunakan consistent naming conventions
- Pastikan imports yang tidak digunakan dihapus

### Error Handling
- Gunakan `ErrorHandler` untuk centralized error management
- Implementasikan proper error logging
- Gunakan user-friendly error messages
- Pastikan error recovery mechanisms

## Network & API
### Dio Client Usage
- Gunakan `DioClient` untuk semua HTTP requests
- Implementasikan proper timeout configuration
- Gunakan `TimeoutConstants` untuk consistent timeout values
- Implementasikan retry mechanism dengan exponential backoff

### Auth Interceptor
- Gunakan `AuthInterceptor` untuk automatic token injection
- Implementasikan automatic token refresh
- Handle authentication errors secara global
- Implementasikan request signing untuk sensitive endpoints

### Error Handling
- Gunakan proper HTTP status code handling
- Implementasikan network error recovery
- Gunakan `ErrorMessages` untuk consistent error texts
- Pastikan user feedback untuk network issues

## Platform-Specific Guidelines
### Platform Detection
- Gunakan `PlatformDetector` untuk platform-specific logic
- Implementasikan conditional UI/UX berdasarkan platform
- Gunakan platform-specific optimizations
- Test pada target platforms (iOS/Android)

### Native Integration
- Gunakan method channels untuk native functionality
- Implementasikan proper error handling untuk native calls
- Gunakan platform-specific UI components saat necessary
- Pastikan native dependencies terintegrasi dengan baik