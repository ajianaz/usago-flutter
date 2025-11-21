# Multi-Platform Development Best Practices

## 📋 Overview

Dokumen ini membahas best practices untuk pengembangan aplikasi multi-platform (iOS, Android, Web, Desktop) dengan Flutter. Focus pada consistency, maintainability, dan optimal performance di semua platform.

---

## 🏗️ Architecture Principles

### 1. Platform-Agnostic Core Design

**Prinsip**: Business logic dan core functionality harus independen dari platform.

```dart
// ✅ Good: Platform-agnostic service
abstract class StorageService {
  Future<void> save(String key, String value);
  Future<String?> read(String key);
  Future<void> remove(String key);
}

// ✅ Good: Platform-specific implementation
class MobileStorageService implements StorageService {
  // Mobile-specific implementation
}

class WebStorageService implements StorageService {
  // Web-specific implementation
}
```

**❌ Bad**: Platform-specific code di core logic
```dart
class UserService {
  Future<void> saveToken(String token) async {
    if (Platform.isIOS) {
      // iOS-specific code
    } else if (Platform.isAndroid) {
      // Android-specific code
    }
    // This should be abstracted
  }
}
```

### 2. Dependency Inversion Pattern

```dart
// Abstraction layer
abstract class PlatformAdapter {
  Future<void> initialize();
  Future<T> execute<T>(Future<T> Function() operation);
}

// Concrete implementations
class MobileAdapter implements PlatformAdapter {
  @override
  Future<void> initialize() async {
    // Mobile-specific initialization
  }
}

class WebAdapter implements PlatformAdapter {
  @override
  Future<void> initialize() async {
    // Web-specific initialization
  }
}
```

### 3. Feature-Based Architecture

```
lib/
├── core/
│   ├── services/          # Platform-agnostic services
│   ├── utils/            # Shared utilities
│   └── constants/        # Shared constants
├── features/
│   ├── auth/
│   │   ├── data/         # Data layer (platform-agnostic)
│   │   ├── domain/       # Business logic
│   │   └── presentation/ # UI with platform-specific widgets
│   ├── profile/
│   └── ...
└── platform/
    ├── mobile/           # Mobile-specific implementations
    ├── web/             # Web-specific implementations
    └── desktop/         # Desktop-specific implementations
```

---

## 📱 Platform-Specific Implementations

### 1. Strategy Pattern untuk Platform Detection

```dart
class PlatformStrategy {
  static PlatformStrategy get current {
    if (PlatformDetector.isMobile) return MobileStrategy();
    if (PlatformDetector.isWeb) return WebStrategy();
    if (PlatformDetector.isDesktop) return DesktopStrategy();
    return FallbackStrategy();
  }

  abstract void initializePlatform();
  abstract Widget buildPlatformWidget(Widget child);
  abstract Future<void> performPlatformSpecificOperation();
}

class MobileStrategy extends PlatformStrategy {
  @override
  void initializePlatform() {
    // Mobile-specific initialization
    Firebase.initializeApp();
  }

  @override
  Widget buildPlatformWidget(Widget child) {
    return MobileScaffold(child: child);
  }
}
```

### 2. Factory Pattern untuk Platform Services

```dart
abstract class PlatformServiceFactory {
  T createService<T>();
}

class MobileServiceFactory extends PlatformServiceFactory {
  @override
  T createService<T>() {
    if (T == StorageService) {
      return MobileStorageService() as T;
    }
    throw UnimplementedError('Service $T not implemented for mobile');
  }
}

class WebServiceFactory extends PlatformServiceFactory {
  @override
  T createService<T>() {
    if (T == StorageService) {
      return WebStorageService() as T;
    }
    throw UnimplementedError('Service $T not implemented for web');
  }
}
```

### 3. Adapter Pattern untuk Platform APIs

```dart
// Platform-agnostic interface
abstract class NotificationService {
  Future<void> sendNotification(String title, String body);
  Future<bool> hasPermission();
  Future<void> requestPermission();
}

// Mobile implementation
class MobileNotificationService implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  @override
  Future<void> sendNotification(String title, String body) async {
    await _plugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'usago_channel',
          'Usago Notifications',
        ),
        iOS: IOSNotificationDetails(),
      ),
    );
  }
}

// Web implementation
class WebNotificationService implements NotificationService {
  @override
  Future<void> sendNotification(String title, String body) async {
    if (html.Notification.supported) {
      html.Notification(title, body: body);
    }
  }
}
```

---

## 🎨 UI/UX Consistency

### 1. Responsive Design System

```dart
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenType screenType) builder;

  const ResponsiveBuilder({required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = _getScreenType(constraints.maxWidth);
        return builder(context, screenType);
      },
    );
  }

  ScreenType _getScreenType(double width) {
    if (width < 600) return ScreenType.mobile;
    if (width < 1024) return ScreenType.tablet;
    return ScreenType.desktop;
  }
}

enum ScreenType { mobile, tablet, desktop }
```

### 2. Platform-Specific UI Components

```dart
class PlatformButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PlatformButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformDetector.isMobile) {
      return _buildMobileButton();
    } else if (PlatformDetector.isWeb) {
      return _buildWebButton();
    } else {
      return _buildDesktopButton();
    }
  }

  Widget _buildMobileButton() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(text),
    );
  }

  Widget _buildWebButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
```

### 3. Adaptive Layout System

```dart
class AdaptiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const AdaptiveLayout({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenType) {
        switch (screenType) {
          case ScreenType.mobile:
            return mobile;
          case ScreenType.tablet:
            return tablet ?? mobile;
          case ScreenType.desktop:
            return desktop ?? tablet ?? mobile;
        }
      },
    );
  }
}
```

---

## 🔧 Development Workflow

### 1. Environment Configuration

```dart
// Environment-specific configuration
class AppConfig {
  static AppConfig get current {
    if (kDebugMode) {
      return DevelopmentConfig();
    } else if (kProfileMode) {
      return StagingConfig();
    } else {
      return ProductionConfig();
    }
  }

  abstract String get apiBaseUrl;
  abstract bool get enableLogging;
  abstract bool get enableAnalytics;
}

class DevelopmentConfig extends AppConfig {
  @override
  String get apiBaseUrl => 'https://dev-api.usago.com';

  @override
  bool get enableLogging => true;

  @override
  bool get enableAnalytics => false;
}
```

### 2. Testing Strategy

```dart
// Platform-agnostic tests
void main() {
  group('UserService', () {
    late UserService userService;
    late MockStorageService mockStorage;

    setUp(() {
      mockStorage = MockStorageService();
      userService = UserService(storage: mockStorage);
    });

    test('should save user token', () async {
      // Test business logic, not platform specifics
      when(mockStorage.save('auth_token', 'test_token'))
          .thenAnswer((_) async {});

      await userService.saveToken('test_token');

      verify(mockStorage.save('auth_token', 'test_token')).called(1);
    });
  });
}

// Platform-specific integration tests
void main() {
  group('Mobile Storage Integration', () {
    testWidgets('should save and retrieve data on mobile', (tester) async {
      // Mobile-specific integration test
    });
  });
}
```

### 3. CI/CD Pipeline

```yaml
# .github/workflows/multi-platform.yml
name: Multi-Platform CI/CD

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test

  build-web:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build web

  build-mobile:
    runs-on: macos-latest
    needs: test
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk
      - run: flutter build ios
```

---

## 📊 Performance Optimization

### 1. Lazy Loading untuk Platform Resources

```dart
class PlatformResourceManager {
  static final Map<Type, dynamic> _resources = {};

  static T getResource<T>() {
    if (!_resources.containsKey(T)) {
      _resources[T] = _createResource<T>();
    }
    return _resources[T] as T;
  }

  static T _createResource<T>() {
    if (T == ImageCache) {
      if (PlatformDetector.isMobile) {
        return MobileImageCache() as T;
      } else if (PlatformDetector.isWeb) {
        return WebImageCache() as T;
      } else {
        return DesktopImageCache() as T;
      }
    }
    throw UnimplementedError('Resource $T not implemented');
  }
}
```

### 2. Memory Management

```dart
class MemoryManager {
  static void optimizeForPlatform() {
    if (PlatformDetector.isMobile) {
      _optimizeForMobile();
    } else if (PlatformDetector.isWeb) {
      _optimizeForWeb();
    } else {
      _optimizeForDesktop();
    }
  }

  static void _optimizeForMobile() {
    // Reduce cache sizes
    imageCache.maximumSize = 50;
    imageCache.maximumSizeBytes = 50 << 20; // 50MB
  }

  static void _optimizeForWeb() {
    // Optimize for browser memory constraints
    imageCache.maximumSize = 100;
    imageCache.maximumSizeBytes = 25 << 20; // 25MB
  }

  static void _optimizeForDesktop() {
    // Utilize available memory
    imageCache.maximumSize = 200;
    imageCache.maximumSizeBytes = 200 << 20; // 200MB
  }
}
```

### 3. Network Optimization

```dart
class NetworkOptimizer {
  static Duration getTimeoutForPlatform() {
    if (PlatformDetector.isMobile) {
      return const Duration(seconds: 30); // Mobile networks
    } else if (PlatformDetector.isWeb) {
      return const Duration(seconds: 15); // Web typically faster
    } else {
      return const Duration(seconds: 45); // Desktop can wait longer
    }
  }

  static int getRetryCountForPlatform() {
    if (PlatformDetector.isMobile) {
      return 3; // Mobile networks less reliable
    } else {
      return 2; // More stable connections
    }
  }
}
```

---

## 🔄 State Management

### 1. Platform-Agnostic State Management

```dart
// Using Bloc for platform-agnostic state management
abstract class BlocEvent {}

abstract class BlocState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authService.login(event.email, event.password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
```

### 2. Platform-Specific State Persistence

```dart
class StatePersistence {
  static Future<void> persistState(String key, dynamic state) async {
    final storage = SecureStorageService();
    await storage.initialize();

    if (PlatformDetector.isMobile) {
      await _persistMobileState(key, state, storage);
    } else if (PlatformDetector.isWeb) {
      await _persistWebState(key, state, storage);
    } else {
      await _persistDesktopState(key, state, storage);
    }
  }

  static Future<void> _persistMobileState(
    String key,
    dynamic state,
    SecureStorageService storage,
  ) async {
    // Mobile-specific persistence with encryption
    await storage.save(key, jsonEncode(state), isSecure: true);
  }
}
```

---

## 🧪 Testing Best Practices

### 1. Test Pyramid untuk Multi-Platform

```
                /\
               /  \
              / E2E \  (Platform-specific)
             /______\
            /        \
           /Integration\ (Platform-agnostic)
          /__________\
         /            \
        /   Unit       \ (Platform-agnostic)
       /________________\
```

### 2. Platform Mocking

```dart
// Mock platform detection for testing
class MockPlatformDetector extends PlatformDetector {
  static bool _isMobile = false;
  static bool _isWeb = false;
  static bool _isDesktop = false;

  static void setMobile(bool value) => _isMobile = value;
  static void setWeb(bool value) => _isWeb = value;
  static void setDesktop(bool value) => _isDesktop = value;

  @override
  static bool get isMobile => _isMobile;
  @override
  static bool get isWeb => _isWeb;
  @override
  static bool get isDesktop => _isDesktop;
}

// Usage in tests
void main() {
  setUp(() {
    MockPlatformDetector.setMobile(true);
    MockPlatformDetector.setWeb(false);
    MockPlatformDetector.setDesktop(false);
  });

  test('mobile-specific behavior', () {
    // Test mobile logic
  });
}
```

### 3. Golden Testing untuk UI Consistency

```dart
void main() {
  testWidgets('PlatformButton consistency', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlatformButton(
            text: 'Test Button',
            onPressed: () {},
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(PlatformButton),
      matchesGoldenFile('goldens/platform_button.png'),
    );
  });
}
```

---

## 📱 Platform-Specific Features

### 1. Feature Flags

```dart
class FeatureFlags {
  static bool isBiometricEnabled() {
    if (PlatformDetector.isMobile) {
      return true; // Biometrics available on mobile
    } else if (PlatformDetector.isDesktop) {
      return PlatformDetector.isMacOS; // Touch ID on macOS
    } else {
      return false; // No biometrics on web
    }
  }

  static bool isPushNotificationEnabled() {
    return PlatformDetector.isMobile; // Only mobile supports push notifications
  }

  static bool isOfflineModeEnabled() {
    return true; // All platforms support offline mode
  }
}
```

### 2. Graceful Degradation

```dart
class FeatureManager {
  static Widget buildFeature(FeatureType feature) {
    switch (feature) {
      case FeatureType.biometricAuth:
        if (FeatureFlags.isBiometricEnabled()) {
          return BiometricAuthWidget();
        } else {
          return PasswordAuthWidget(); // Fallback
        }
      case FeatureType.pushNotifications:
        if (FeatureFlags.isPushNotificationEnabled()) {
          return PushNotificationWidget();
        } else {
          return EmailNotificationWidget(); // Fallback
        }
      default:
        return Placeholder(); // Feature not available
    }
  }
}
```

---

## 📚 Code Organization

### 1. Directory Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── platform_constants.dart
│   │   └── storage_constants.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── services/
│   │   ├── storage_service.dart
│   │   ├── network_service.dart
│   │   └── platform_service.dart
│   ├── utils/
│   │   ├── platform_detector.dart
│   │   ├── logger.dart
│   │   └── validators.dart
│   └── widgets/
│       ├── responsive_layout.dart
│       ├── platform_button.dart
│       └── adaptive_widget.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── pages/
│   │       ├── widgets/
│   │       └── bloc/
│   └── ...
├── platform/
│   ├── mobile/
│   │   ├── services/
│   │   └── widgets/
│   ├── web/
│   │   ├── services/
│   │   └── widgets/
│   └── desktop/
│       ├── services/
│       └── widgets/
└── main.dart
```

### 2. Naming Conventions

```dart
// Platform-specific implementations
class MobileStorageService implements StorageService { }
class WebStorageService implements StorageService { }
class DesktopStorageService implements StorageService { }

// Platform-agnostic core
class StorageService { }
class SecureStorageService { }

// Platform detection utilities
class PlatformDetector { }
class PlatformUtils { }

// Feature-specific implementations
class MobileAuthFeature { }
class WebAuthFeature { }
class DesktopAuthFeature { }
```

---

## 🔍 Debugging and Monitoring

### 1. Platform-Specific Logging

```dart
class PlatformLogger {
  static void log(String message, {LogLevel level = LogLevel.info}) {
    final platform = PlatformDetector.platformName;
    final timestamp = DateTime.now().toIso8601String();

    if (PlatformDetector.isWeb) {
      _logToWeb('[$platform] [$timestamp] $message', level);
    } else {
      _logToNative('[$platform] [$timestamp] $message', level);
    }
  }

  static void _logToWeb(String message, LogLevel level) {
    if (level == LogLevel.error) {
      print('ERROR: $message');
    } else {
      print(message);
    }
  }

  static void _logToNative(String message, LogLevel level) {
    // Use platform-specific logging frameworks
    debugPrint(message);
  }
}
```

### 2. Performance Monitoring

```dart
class PerformanceMonitor {
  static void trackOperation(String operation, Duration duration) {
    final platform = PlatformDetector.platformName;
    final metrics = {
      'platform': platform,
      'operation': operation,
      'duration_ms': duration.inMilliseconds,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Send to analytics service
    AnalyticsService.track('performance', metrics);
  }

  static Future<T> measureOperation<T>(
    String operation,
    Future<T> Function() func,
  ) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await func();
      stopwatch.stop();
      trackOperation(operation, stopwatch.elapsed);
      return result;
    } catch (e) {
      stopwatch.stop();
      trackOperation('${operation}_failed', stopwatch.elapsed);
      rethrow;
    }
  }
}
```

---

## 📖 Documentation Standards

### 1. Code Documentation

```dart
/// Cross-platform storage service
///
/// Provides secure storage capabilities across iOS, Android, Web, and Desktop.
/// Automatically selects appropriate storage implementation based on platform.
///
/// ## Platform Support
/// - **iOS**: Keychain with hardware-backed encryption
/// - **Android**: EncryptedSharedPreferences with Keystore
/// - **Web**: Encrypted localStorage with XOR cipher
/// - **Desktop**: Platform-specific secure storage
///
/// ## Example
/// ```dart
/// final storage = SecureStorageService();
/// await storage.initialize();
/// await storage.save('auth_token', 'jwt_token');
/// ```
///
/// ## Security Considerations
/// - Sensitive data is automatically encrypted
/// - Platform-specific optimal configurations
/// - Fallback mechanism for unsupported platforms
class SecureStorageService {
  // Implementation
}
```

### 2. API Documentation

```dart
/// Saves data to secure storage
///
/// [key] Storage key identifier
/// [value] Value to store (will be JSON encoded if Map/List)
/// [isSecure] Whether to use secure storage (default: true for sensitive keys)
///
/// Returns [Future<void>] that completes when data is saved
///
/// Throws [StorageException] if save operation fails
///
/// ## Platform Behavior
/// - **Mobile**: Uses hardware secure storage
/// - **Web**: Encrypts before storing in localStorage
/// - **Desktop**: Uses system secure storage
///
/// ## Example
/// ```dart
/// await storage.save('user_token', 'jwt_value');
/// await storage.save('preferences', {'theme': 'dark'}, isSecure: false);
/// ```
Future<void> save(String key, dynamic value, {bool isSecure = true}) async {
  // Implementation
}
```

---

## 🚀 Deployment Strategies

### 1. Platform-Specific Builds

```yaml
# Build configurations for different platforms
flutter:
  # Web build
  web:
    build:
      web-renderer: canvaskit
      csp: true

  # Mobile builds
  android:
    build:
      flavors:
        - dev
        - staging
        - production

  ios:
    build:
      flavors:
        - dev
        - staging
        - production
```

### 2. Version Management

```dart
class AppVersion {
  static String get version {
    if (PlatformDetector.isMobile) {
      return _getMobileVersion();
    } else if (PlatformDetector.isWeb) {
      return _getWebVersion();
    } else {
      return _getDesktopVersion();
    }
  }

  static String _getMobileVersion() {
    return PackageInfo.fromPlatform().then((info) => info.version);
  }

  static String _getWebVersion() {
    return const String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0');
  }
}
```

---

## 📊 Metrics and Analytics

### 1. Platform Usage Tracking

```dart
class AnalyticsTracker {
  static void trackPlatformUsage() {
    final platform = PlatformDetector.platformName;
    final version = AppVersion.version;

    AnalyticsService.track('app_opened', {
      'platform': platform,
      'version': version,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static void trackFeatureUsage(String feature, Map<String, dynamic> params) {
    final platformParams = {
      ...params,
      'platform': PlatformDetector.platformName,
    };

    AnalyticsService.track('feature_used', {
      'feature': feature,
      'parameters': platformParams,
    });
  }
}
```

### 2. Performance Metrics

```dart
class PerformanceMetrics {
  static void collectMetrics() {
    final metrics = {
      'platform': PlatformDetector.platformName,
      'memory_usage': _getMemoryUsage(),
      'storage_usage': _getStorageUsage(),
      'network_latency': _getNetworkLatency(),
    };

    MetricsService.submit('performance', metrics);
  }

  static double _getMemoryUsage() {
    // Platform-specific memory usage calculation
    if (PlatformDetector.isMobile) {
      return _getMobileMemoryUsage();
    } else if (PlatformDetector.isWeb) {
      return _getWebMemoryUsage();
    } else {
      return _getDesktopMemoryUsage();
    }
  }
}
```

---

## 📚 Referensi dan Resources

### Official Documentation
- [Flutter Multi-Platform Development](https://flutter.dev/multi-platform)
- [Flutter Platform Integration](https://flutter.dev/platform-integration)
- [Flutter Testing](https://flutter.dev/testing)

### Community Resources
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Very Good Ventures Flutter Best Practices](https://verygood.ventures/blog)

### Tools and Libraries
- [Platform Detector](https://pub.dev/packages/platform_detector)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [Responsive Framework](https://pub.dev/packages/responsive_framework)

---

**Last Updated**: November 21, 2025
**Version**: 1.0.0
**Next Review**: November 28, 2025

---

*Go Digital, Grow Together.*