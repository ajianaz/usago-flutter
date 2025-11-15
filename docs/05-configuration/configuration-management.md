# Configuration Management Documentation
# Dokumentasi Manajemen Konfigurasi

---

## 📋 **Document Metadata**

| Field | Value |
|-------|-------|
| **Document ID** | DOC-CONFIGURATION-MANAGEMENT |
| **Version** | 1.0 |
| **Status** | Ready to Implement |
| **Category** | Technical Documentation |
| **Priority** | High |
| **Created Date** | November 15, 2025 |
| **Last Updated** | November 15, 2025 |
| **Next Review** | November 22, 2025 |
| **Author** | Mobile Development Team |
| **Reviewers** | DevOps Lead, Tech Lead |
| **Stakeholders** | Development Team, QA Team, DevOps Team |

---

## 🎯 **Purpose**

Dokumen ini menjelaskan sistem manajemen konfigurasi yang digunakan dalam aplikasi Usago Mobile. Sistem ini dirancang untuk menyediakan konfigurasi yang fleksibel untuk berbagai environments (development, staging, production) dengan validasi dan type safety.

---

## 📚 **Table of Contents**

1. [Configuration Overview](#configuration-overview)
2. [Constants Files](#constants-files)
3. [Environment Configuration](#environment-configuration)
4. [App Configuration](#app-configuration)
5. [Environment-Specific Setup](#environment-specific-setup)
6. [Validation and Safety](#validation-and-safety)
7. [Usage Examples](#usage-examples)
8. [Best Practices](#best-practices)

---

## 🏗️ **Configuration Overview**

### Arsitektur Konfigurasi

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    CONFIGURATION ARCHITECTURE                      │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                    ENVIRONMENT FILES                        │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │   │
│  │  │ .env.develop │  │ .env.staging │  │ .env.production│ │   │
│  │  │    ment     │  │             │  │              │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                     │
│                              ▼                                     │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                  ENV CONFIG CLASS                         │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │   │
│  │  │   Loader    │  │   Validator │  │ Environment │ │   │
│  │  └─────────────┘  └─────────────┘  │ Detection   │ │   │
│  │                                          └─────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                     │
│                              ▼                                     │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                  APP CONFIG CLASS                          │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │   │
│  │  │   API Config│  │Performance  │  │   Security  │ │   │
│  │  │             │  │   Config    │  │   Config    │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────┘   │
│                              │                                     │
│                              ▼                                     │
│  ┌─────────────────────────────────────────────────────────────────┐   │
│  │                  CONSTANTS FILES                             │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │   │
│  │  │   Timeout   │  │Performance  │  │   Security  │ │   │
│  │  │ Constants  │  │ Constants  │  │ Constants  │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
```

### Prinsip Utama

1. **Environment-Based**: Konfigurasi berbeda untuk setiap environment
2. **Type Safety**: Strong typing untuk semua nilai konfigurasi
3. **Validation**: Built-in validation untuk required values
4. **Fallback**: Default values untuk development
5. **Security**: Sensitive data tidak di-hardcode

---

## 📁 **Constants Files**

### 1. Timeout Constants

[`TimeoutConstants`](../lib/core/constants/timeout_constants.dart:4) mendefinisikan semua timeout values yang digunakan di aplikasi.

```dart
class TimeoutConstants {
  const TimeoutConstants._();

  /// Timeout untuk operasi jaringan (30 detik)
  static const Duration network = Duration(seconds: 30);

  /// Timeout untuk operasi kritis (2 detik)
  static const Duration critical = Duration(seconds: 2);

  /// Threshold warning untuk BLoC execution time (100ms)
  static const Duration blocWarning = Duration(milliseconds: 100);

  /// Threshold critical untuk BLoC execution time (500ms)
  static const Duration blocCritical = Duration(milliseconds: 500);

  /// Timeout untuk koneksi database (15 detik)
  static const Duration database = Duration(seconds: 15);

  /// Timeout untuk operasi file I/O (10 detik)
  static const Duration fileIO = Duration(seconds: 10);

  /// Timeout untuk cache retrieval (1 detik)
  static const Duration cache = Duration(seconds: 1);

  /// Timeout untuk operasi storage (5 detik)
  static const Duration storage = Duration(seconds: 5);

  /// Timeout untuk retry mechanism (1 detik)
  static const Duration retry = Duration(seconds: 1);

  /// Timeout untuk splash screen (3 detik)
  static const Duration splash = Duration(seconds: 3);

  /// Timeout untuk animasi loading (30 detik maksimal)
  static const Duration loading = Duration(seconds: 30);
}
```

### 2. Performance Constants

[`PerformanceConstants`](../lib/core/constants/performance_constants.dart:4) mendefinisikan thresholds dan limits untuk performance monitoring.

```dart
class PerformanceConstants {
  const PerformanceConstants._();

  // ==================== Memory Thresholds ====================

  /// Memory threshold untuk warning (70%)
  static const double memoryWarningThreshold = 0.7;

  /// Memory threshold untuk critical (85%)
  static const double memoryCriticalThreshold = 0.85;

  /// Memory threshold untuk alert (80%)
  static const double memoryAlertThreshold = 0.8;

  // ==================== Cache Configuration ====================

  /// Default cache expiry duration (24 jam)
  static const Duration defaultCacheExpiry = Duration(hours: 24);

  /// Short cache expiry (1 jam)
  static const Duration shortCacheExpiry = Duration(hours: 1);

  /// Long cache expiry (7 hari)
  static const Duration longCacheExpiry = Duration(days: 7);

  // ==================== Pagination ====================

  /// Default page size untuk pagination
  static const int defaultPageSize = 20;

  /// Maximum page size
  static const int maxPageSize = 100;

  /// Minimum page size
  static const int minPageSize = 5;

  // ==================== Performance Monitoring ====================

  /// Interval untuk performance monitoring (5 detik)
  static const Duration performanceMonitoringInterval = Duration(seconds: 5);

  /// Interval untuk memory monitoring (2 detik)
  static const Duration memoryMonitoringInterval = Duration(seconds: 2);

  /// Interval untuk CPU monitoring (1 detik)
  static const Duration cpuMonitoringInterval = Duration(seconds: 1);

  // ==================== BLoC Performance ====================

  /// Maximum execution time untuk BLoC events (500ms)
  static const Duration maxBlocExecutionTime = Duration(milliseconds: 500);

  /// Warning threshold untuk BLoC execution time (200ms)
  static const Duration blocWarningThreshold = Duration(milliseconds: 200);

  /// Maximum BLoC events dalam queue
  static const int maxBlocEventQueueSize = 50;
}
```

### 3. Security Constants

[`SecurityConstants`](../lib/core/constants/security_constants.dart:4) mendefinisikan security-related constants.

```dart
class SecurityConstants {
  const SecurityConstants._();

  // ==================== Encryption ====================

  /// AES key length (256 bits)
  static const int aesKeyLength = 256;

  /// IV (Initialization Vector) size (16 bytes)
  static const int ivSize = 16;

  /// Random key length untuk generate (32 bytes)
  static const int randomKeyLength = 32;

  /// Salt length untuk hashing
  static const int saltLength = 16;

  /// PBKDF2 iterations
  static const int pbkdf2Iterations = 10000;

  // ==================== Authentication ====================

  /// Maximum retry attempts untuk login
  static const int maxRetryAttempts = 3;

  /// Maximum failed attempts sebelum lockout
  static const int maxFailedAttempts = 5;

  /// Lockout duration setelah failed attempts (15 menit)
  static const Duration lockoutDuration = Duration(minutes: 15);

  /// Session timeout duration (24 jam)
  static const Duration sessionTimeout = Duration(hours: 24);

  /// Remember me duration (30 hari)
  static const Duration rememberMeDuration = Duration(days: 30);

  // ==================== Key Management ====================

  /// Key rotation interval (30 hari)
  static const Duration keyRotationInterval = Duration(days: 30);

  /// Maximum key age sebelum rotation
  static const Duration maxKeyAge = Duration(days: 30);

  /// Key derivation iteration count
  static const int keyDerivationIterations = 100000;

  /// Minimum key strength score
  static const int minKeyStrengthScore = 80;

  // ==================== Token Management ====================

  /// Access token expiry (1 jam)
  static const Duration accessTokenExpiry = Duration(hours: 1);

  /// Refresh token expiry (7 hari)
  static const Duration refreshTokenExpiry = Duration(days: 7);

  /// Reset token expiry (1 jam)
  static const Duration resetTokenExpiry = Duration(hours: 1);

  /// Verification token expiry (24 jam)
  static const Duration verificationTokenExpiry = Duration(hours: 24);

  /// OTP token expiry (5 menit)
  static const Duration otpTokenExpiry = Duration(minutes: 5);
}
```

### 4. UI Constants

[`UIConstants`](../lib/core/constants/ui_constants.dart) mendefinisikan UI-related constants.

```dart
class UIConstants {
  const UIConstants._();

  // ==================== Spacing ====================

  /// Default padding value
  static const double paddingDefault = 16.0;

  /// Small padding value
  static const double paddingSmall = 8.0;

  /// Large padding value
  static const double paddingLarge = 24.0;

  // ==================== Border Radius ====================

  /// Default border radius
  static const double borderRadiusDefault = 8.0;

  /// Small border radius
  static const double borderRadiusSmall = 4.0;

  /// Large border radius
  static const double borderRadiusLarge = 12.0;

  // ==================== Screen Dimensions ====================

  /// Maximum width untuk mobile layout
  static const double maxMobileWidth = 600.0;

  /// Maximum width untuk tablet layout
  static const double maxTabletWidth = 1024.0;

  // ==================== Animation ====================

  /// Default animation duration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  /// Fast animation duration
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);

  /// Slow animation duration
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);
}
```

### 5. Validation Constants

[`ValidationConstants`](../lib/core/constants/validation_constants.dart) mendefinisikan validation-related constants.

```dart
class ValidationConstants {
  const ValidationConstants._();

  // ==================== Password ====================

  /// Minimum password length
  static const int passwordMinLength = 8;

  /// Maximum password length
  static const int passwordMaxLength = 128;

  /// Minimum password strength score
  static const int passwordMinStrengthScore = 60;

  // ==================== Username ====================

  /// Minimum username length
  static const int usernameMinLength = 3;

  /// Maximum username length
  static const int usernameMaxLength = 30;

  // ==================== Email ====================

  /// Maximum email length
  static const int emailMaxLength = 254;

  // ==================== Phone ====================

  /// Minimum phone length
  static const int phoneMinLength = 10;

  /// Maximum phone length
  static const int phoneMaxLength = 15;

  // ==================== General ====================

  /// Maximum text field length
  static const int maxTextFieldLength = 1000;

  /// Maximum file size (10MB)
  static const int maxFileSizeBytes = 10 * 1024 * 1024;
}
```

---

## 🌍 **Environment Configuration**

### Environment Files

Environment configuration disimpan dalam file `.env` yang berbeda untuk setiap environment:

#### `.env.development`

```bash
# Development Environment Configuration
API_BASE_URL=http://localhost:3000
API_VERSION=v1
CONTENT_TYPE_HEADER=application/json
ACCEPT_HEADER=application/json
BEARER_TOKEN_HEADER=Authorization

# Feature Flags
ENABLE_LOGGING=true
ENABLE_CRASH_REPORTING=false
ENABLE_ANALYTICS=false
ENABLE_PERFORMANCE_MONITORING=true
ENABLE_MEMORY_MONITORING=true
ENABLE_BLOC_MONITORING=true
ENABLE_AUTO_OPTIMIZATION=false
ENABLE_PERFORMANCE_REPORTING=true
ENABLE_PERFORMANCE_EXPORT=true

# Performance Configuration
MEMORY_WARNING_THRESHOLD=70
MEMORY_CRITICAL_THRESHOLD=85
MAX_METRICS_HISTORY=1000
PERFORMANCE_MONITORING_INTERVAL_SECONDS=5
MEMORY_MONITORING_INTERVAL_SECONDS=2
BLOC_CLEANUP_INTERVAL_MINUTES=5

# BLoC Performance Configuration
SLOW_BLOC_EVENT_WARNING_MS=100
SLOW_BLOC_EVENT_CRITICAL_MS=500
MAX_ACTIVE_BLOCS=20

# Performance Reporting Configuration
PERFORMANCE_REPORTING_INTERVAL_MINUTES=2
PERFORMANCE_EXPORT_PATH=/tmp/performance_logs

# Security
ENCRYPTION_KEY=dev_encryption_key_256bit
JWT_SECRET=dev_jwt_secret_at_least_32_chars
ENCRYPTION_ALGORITHM=AES-256-GCM
KEY_CIPHER_ALGORITHM=RSA_ECB_OAEPwithSHA_256andMGF1Padding
STORAGE_CIPHER_ALGORITHM=AES_GCM_NoPadding
ENABLE_ENHANCED_SECURITY=true
ENABLE_HARDWARE_SECURITY=true
ENABLE_ENCRYPTION_KEY_ROTATION=false
ENABLE_DATA_INTEGRITY_CHECK=true
MAX_FAILED_ACCESS_ATTEMPTS=5
LOCKOUT_DURATION_MINUTES=15

# Debug Settings
DEBUG_MODE=true
LOG_LEVEL=debug
```

#### `.env.staging`

```bash
# Staging Environment Configuration
API_BASE_URL=https://staging-api.usago.id
API_VERSION=v1
CONTENT_TYPE_HEADER=application/json
ACCEPT_HEADER=application/json
BEARER_TOKEN_HEADER=Authorization

# Feature Flags
ENABLE_LOGGING=true
ENABLE_CRASH_REPORTING=true
ENABLE_ANALYTICS=true
ENABLE_PERFORMANCE_MONITORING=true
ENABLE_MEMORY_MONITORING=true
ENABLE_BLOC_MONITORING=true
ENABLE_AUTO_OPTIMIZATION=true
ENABLE_PERFORMANCE_REPORTING=true
ENABLE_PERFORMANCE_EXPORT=false

# Performance Configuration
MEMORY_WARNING_THRESHOLD=75
MEMORY_CRITICAL_THRESHOLD=90
MAX_METRICS_HISTORY=500
PERFORMANCE_MONITORING_INTERVAL_SECONDS=10
MEMORY_MONITORING_INTERVAL_SECONDS=5
BLOC_CLEANUP_INTERVAL_MINUTES=10

# Security
ENCRYPTION_KEY=staging_encryption_key_256bit
JWT_SECRET=staging_jwt_secret_at_least_32_chars
ENCRYPTION_ALGORITHM=AES-256-GCM
KEY_CIPHER_ALGORITHM=RSA_ECB_OAEPwithSHA_256andMGF1Padding
STORAGE_CIPHER_ALGORITHM=AES_GCM_NoPadding
ENABLE_ENHANCED_SECURITY=true
ENABLE_HARDWARE_SECURITY=true
ENABLE_ENCRYPTION_KEY_ROTATION=true
ENABLE_DATA_INTEGRITY_CHECK=true
MAX_FAILED_ACCESS_ATTEMPTS=3
LOCKOUT_DURATION_MINUTES=10

# Debug Settings
DEBUG_MODE=true
LOG_LEVEL=info
```

#### `.env.production`

```bash
# Production Environment Configuration
API_BASE_URL=https://api.usago.id
API_VERSION=v1
CONTENT_TYPE_HEADER=application/json
ACCEPT_HEADER=application/json
BEARER_TOKEN_HEADER=Authorization

# Feature Flags
ENABLE_LOGGING=false
ENABLE_CRASH_REPORTING=true
ENABLE_ANALYTICS=true
ENABLE_PERFORMANCE_MONITORING=false
ENABLE_MEMORY_MONITORING=false
ENABLE_BLOC_MONITORING=false
ENABLE_AUTO_OPTIMIZATION=true
ENABLE_PERFORMANCE_REPORTING=false
ENABLE_PERFORMANCE_EXPORT=false

# Performance Configuration
MEMORY_WARNING_THRESHOLD=80
MEMORY_CRITICAL_THRESHOLD=95
MAX_METRICS_HISTORY=200
PERFORMANCE_MONITORING_INTERVAL_SECONDS=30
MEMORY_MONITORING_INTERVAL_SECONDS=10
BLOC_CLEANUP_INTERVAL_MINUTES=15

# Security
ENCRYPTION_KEY=${ENCRYPTION_KEY}
JWT_SECRET=${JWT_SECRET}
ENCRYPTION_ALGORITHM=AES-256-GCM
KEY_CIPHER_ALGORITHM=RSA_ECB_OAEPwithSHA_256andMGF1Padding
STORAGE_CIPHER_ALGORITHM=AES_GCM_NoPadding
ENABLE_ENHANCED_SECURITY=true
ENABLE_HARDWARE_SECURITY=true
ENABLE_ENCRYPTION_KEY_ROTATION=true
ENABLE_DATA_INTEGRITY_CHECK=true
MAX_FAILED_ACCESS_ATTEMPTS=3
LOCKOUT_DURATION_MINUTES=15

# Debug Settings
DEBUG_MODE=false
LOG_LEVEL=error
```

### EnvConfig Class

[`EnvConfig`](../lib/core/config/env_config.dart) bertanggung jawab untuk loading dan validasi environment variables.

```dart
class EnvConfig {
  static Environment get currentEnvironment {
    const env = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');

    switch (env.toLowerCase()) {
      case 'production':
      case 'prod':
        return Environment.production;
      case 'staging':
      case 'stage':
        return Environment.staging;
      case 'development':
      case 'dev':
      default:
        return Environment.development;
    }
  }

  static bool get isDevelopment => currentEnvironment == Environment.development;
  static bool get isStaging => currentEnvironment == Environment.staging;
  static bool get isProduction => currentEnvironment == Environment.production;

  static String get(String key, {String? defaultValue}) {
    return _env[key] ?? defaultValue ?? '';
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    final value = get(key);
    if (value.isEmpty) return defaultValue;

    return value.toLowerCase() == 'true' || value == '1';
  }

  static int getInt(String key, {int defaultValue = 0}) {
    final value = get(key);
    return int.tryParse(value) ?? defaultValue;
  }

  static double getDouble(String key, {double defaultValue = 0.0}) {
    final value = get(key);
    return double.tryParse(value) ?? defaultValue;
  }

  static Duration getDuration(String key, {Duration? defaultValue}) {
    final value = get(key);
    if (value.isEmpty) return defaultValue ?? Duration.zero;

    return DurationParser.parse(value);
  }

  static List<String> validateRequired(List<String> requiredKeys) {
    final missing = <String>[];

    for (final key in requiredKeys) {
      if (get(key).isEmpty) {
        missing.add(key);
      }
    }

    return missing;
  }
}
```

---

## ⚙️ **App Configuration**

[`AppConfig`](../lib/core/config/app_config.dart:8) menyediakan centralized access ke semua configuration values dengan validasi dan type safety.

### API Configuration

```dart
class AppConfig {
  // API Configuration
  static String get apiBaseUrl => EnvConfig.get('API_BASE_URL');
  static Duration get apiTimeout => TimeoutConstants.network;
  static String get apiVersion => EnvConfig.get('API_VERSION', defaultValue: 'v1');

  // Headers
  static String get contentTypeHeader => EnvConfig.get('CONTENT_TYPE_HEADER', defaultValue: 'application/json');
  static String get acceptHeader => EnvConfig.get('ACCEPT_HEADER', defaultValue: 'application/json');
  static String get bearerTokenHeader => EnvConfig.get('BEARER_TOKEN_HEADER', defaultValue: 'Authorization');

  // Response Codes
  static int get successCode => ApiStatusCode.ok.code;
  static int get unauthorizedCode => ApiStatusCode.unauthorized.code;
  static int get forbiddenCode => ApiStatusCode.forbidden.code;
  static int get notFoundCode => ApiStatusCode.notFound.code;
  static int get serverErrorCode => ApiStatusCode.internalServerError.code;
}
```

### Feature Flags

```dart
class AppConfig {
  // Feature Flags
  static bool get enableLogging => EnvConfig.getBool('ENABLE_LOGGING', defaultValue: kDebugMode);
  static bool get enableCrashReporting => EnvConfig.getBool('ENABLE_CRASH_REPORTING', defaultValue: !kDebugMode);
  static bool get enableAnalytics => EnvConfig.getBool('ENABLE_ANALYTICS', defaultValue: !kDebugMode);

  // Performance Configuration
  static bool get enablePerformanceMonitoring => EnvConfig.getBool('ENABLE_PERFORMANCE_MONITORING', defaultValue: kDebugMode);
  static bool get enableMemoryMonitoring => EnvConfig.getBool('ENABLE_MEMORY_MONITORING', defaultValue: kDebugMode);
  static bool get enableBlocMonitoring => EnvConfig.getBool('ENABLE_BLOC_MONITORING', defaultValue: kDebugMode);
  static bool get enableAutoOptimization => EnvConfig.getBool('ENABLE_AUTO_OPTIMIZATION', defaultValue: !kDebugMode);
  static bool get enablePerformanceReporting => EnvConfig.getBool('ENABLE_PERFORMANCE_REPORTING', defaultValue: kDebugMode);
  static bool get enablePerformanceExport => EnvConfig.getBool('ENABLE_PERFORMANCE_EXPORT', defaultValue: kDebugMode);
}
```

### Performance Configuration

```dart
class AppConfig {
  // Memory Configuration
  static double get memoryWarningThreshold => PerformanceConstants.memoryWarningThreshold * 100;
  static double get memoryCriticalThreshold => PerformanceConstants.memoryCriticalThreshold * 100;
  static int get maxMetricsHistory => PerformanceConstants.maxMetricsHistoryLength;
  static Duration get memoryMonitoringInterval => PerformanceConstants.memoryMonitoringInterval;

  // BLoC Performance Configuration
  static Duration get slowBlocEventWarning => TimeoutConstants.blocWarning;
  static Duration get slowBlocEventCritical => TimeoutConstants.blocCritical;
  static int get maxActiveBlocs => EnvConfig.getInt('MAX_ACTIVE_BLOCS', defaultValue: 20);
  static Duration get blocCleanupInterval => Duration(
    minutes: EnvConfig.getInt('BLOC_CLEANUP_INTERVAL_MINUTES', defaultValue: 5)
  );

  // Performance Tracking Configuration
  static Duration get performanceMonitoringInterval => PerformanceConstants.performanceMonitoringInterval;
  static Duration get performanceCleanupInterval => Duration(minutes: 10);
  static Duration get slowOperationWarning => TimeoutConstants.blocCritical;
  static Duration get slowOperationCritical => TimeoutConstants.critical;

  // Performance Reporting Configuration
  static Duration get performanceReportingInterval => Duration(
    minutes: EnvConfig.getInt('PERFORMANCE_REPORTING_INTERVAL_MINUTES', defaultValue: 2)
  );
  static String get performanceExportPath => EnvConfig.get('PERFORMANCE_EXPORT_PATH', defaultValue: '/tmp/performance_logs');
}
```

### Security Configuration

```dart
class AppConfig {
  // Security
  static String get encryptionKey => EnvConfig.get('ENCRYPTION_KEY');
  static String get jwtSecret => EnvConfig.get('JWT_SECRET');

  // Enhanced Security Configuration
  static bool get enableEnhancedSecurity => EnvConfig.getBool('ENABLE_ENHANCED_SECURITY', defaultValue: true);
  static bool get enableHardwareSecurity => EnvConfig.getBool('ENABLE_HARDWARE_SECURITY', defaultValue: true);
  static bool get enableEncryptionKeyRotation => EnvConfig.getBool('ENABLE_ENCRYPTION_KEY_ROTATION', defaultValue: false);
  static Duration get encryptionKeyRotationInterval => SecurityConstants.keyRotationInterval;
  static String get encryptionAlgorithm => EnvConfig.get('ENCRYPTION_ALGORITHM', defaultValue: 'AES-256-GCM');
  static String get keyCipherAlgorithm => EnvConfig.get('KEY_CIPHER_ALGORITHM', defaultValue: 'RSA_ECB_OAEPwithSHA_256andMGF1Padding');
  static String get storageCipherAlgorithm => EnvConfig.get('STORAGE_CIPHER_ALGORITHM', defaultValue: 'AES_GCM_NoPadding');
  static bool get enableDataIntegrityCheck => EnvConfig.getBool('ENABLE_DATA_INTEGRITY_CHECK', defaultValue: true);
  static int get maxFailedAccessAttempts => SecurityConstants.maxFailedAttempts;
  static Duration get lockoutDuration => SecurityConstants.lockoutDuration;
}
```

---

## 🎯 **Environment-Specific Setup**

### Development Environment

**Karakteristik:**
- Debug logging enabled
- Performance monitoring aktif
- Local API endpoints
- Relaxed security settings
- Hot reload enabled

**Konfigurasi Kunci:**
```dart
// Development-specific settings
static const String apiBaseUrl = 'http://localhost:3000';
static const bool enableLogging = true;
static const bool enablePerformanceMonitoring = true;
static const bool enableDebugMode = true;
static const String logLevel = 'debug';
```

### Staging Environment

**Karakteristik:**
- Production-like settings
- Analytics enabled
- Staging API endpoints
- Enhanced security enabled
- Performance reporting aktif

**Konfigurasi Kunci:**
```dart
// Staging-specific settings
static const String apiBaseUrl = 'https://staging-api.usago.id';
static const bool enableLogging = true;
static const bool enableAnalytics = true;
static const bool enablePerformanceMonitoring = true;
static const bool enableEnhancedSecurity = true;
static const String logLevel = 'info';
```

### Production Environment

**Karakteristik:**
- Minimal logging
- Crash reporting enabled
- Production API endpoints
- Maximum security settings
- Performance monitoring disabled

**Konfigurasi Kunci:**
```dart
// Production-specific settings
static const String apiBaseUrl = 'https://api.usago.id';
static const bool enableLogging = false;
static const bool enableCrashReporting = true;
static const bool enableAnalytics = true;
static const bool enablePerformanceMonitoring = false;
static const bool enableEnhancedSecurity = true;
static const String logLevel = 'error';
```

---

## ✅ **Validation and Safety**

### Configuration Validation

[`AppConfig`](../lib/core/config/app_config.dart:96) menyediakan built-in validation methods:

```dart
class AppConfig {
  // Validation
  static List<String> validateRequiredVariables() {
    return EnvConfig.validateRequired([
      'API_BASE_URL',
      'API_VERSION',
      'CONTENT_TYPE_HEADER',
      'ACCEPT_HEADER',
      'BEARER_TOKEN_HEADER',
      'ENCRYPTION_KEY',
      'JWT_SECRET',
      'ENCRYPTION_ALGORITHM',
      'KEY_CIPHER_ALGORITHM',
      'STORAGE_CIPHER_ALGORITHM',
    ]);
  }

  // Validate API configuration
  static List<String> validateApiConfiguration() {
    final issues = <String>[];

    // Validate base URL format
    final baseUrl = apiBaseUrl;
    if (baseUrl.isEmpty) {
      issues.add('API_BASE_URL cannot be empty');
    } else {
      // Check if URL has valid format
      if (!baseUrl.startsWith('http://') && !baseUrl.startsWith('https://')) {
        issues.add('API_BASE_URL must start with http:// or https://');
      }

      // Check if URL ends with slash (should not for consistency)
      if (baseUrl.endsWith('/')) {
        issues.add('API_BASE_URL should not end with /');
      }
    }

    // Validate API version
    final version = apiVersion;
    if (version.isEmpty) {
      issues.add('API_VERSION cannot be empty');
    }

    return issues;
  }

  // Performance validation
  static List<String> validatePerformanceVariables() {
    final issues = <String>[];

    // Memory validation
    if (memoryWarningThreshold >= memoryCriticalThreshold) {
      issues.add('MEMORY_WARNING_THRESHOLD should be less than MEMORY_CRITICAL_THRESHOLD');
    }

    if (memoryWarningThreshold < 0 || memoryWarningThreshold > 100) {
      issues.add('MEMORY_WARNING_THRESHOLD should be between 0 and 100');
    }

    // Metrics validation
    if (maxMetricsHistory < 100) {
      issues.add('MAX_METRICS_HISTORY should be at least 100');
    }

    return issues;
  }
}
```

### Safety Checks

```dart
class AppConfig {
  // Check if all required variables are set
  static bool get isConfigValid {
    final missingVars = validateRequiredVariables();
    return missingVars.isEmpty;
  }

  // Check if performance configuration is valid
  static bool get isPerformanceConfigValid {
    final issues = validatePerformanceVariables();
    return issues.isEmpty;
  }

  // Get all configuration issues
  static List<String> getAllConfigIssues() {
    final issues = <String>[];
    issues.addAll(validateRequiredVariables());
    issues.addAll(validateApiConfiguration());
    issues.addAll(validatePerformanceVariables());
    return issues;
  }

  // Check if performance monitoring should be enabled
  static bool get shouldEnablePerformanceMonitoring {
    return enableLogging && enablePerformanceMonitoring;
  }

  // Check if memory monitoring should be enabled
  static bool get shouldEnableMemoryMonitoring {
    return enableLogging && enableMemoryMonitoring;
  }

  // Check if BLoC monitoring should be enabled
  static bool get shouldEnableBlocMonitoring {
    return enableLogging && enableBlocMonitoring;
  }
}
```

### Debug Helper

```dart
class AppConfig {
  // Debug helper to print current configuration (only in debug mode)
  static void debugPrintConfig() {
    if (!debugMode) return;

    if (kDebugMode) {
      print('=== AppConfig Debug Info ===');
      print('Environment: $environment');
      print('API Base URL: $apiBaseUrl');
      print('API Version: $apiVersion');
      print('API Timeout: ${apiTimeout.inMilliseconds}ms');
      print('Enable Logging: $enableLogging');
      print('Enable Crash Reporting: $enableCrashReporting');
      print('Enable Analytics: $enableAnalytics');
      print('Debug Mode: $debugMode');
      print('Log Level: $logLevel');

      // Print validation results
      final apiIssues = validateApiConfiguration();
      if (apiIssues.isNotEmpty) {
        print('=== API Configuration Issues ===');
        for (final issue in apiIssues) {
          print('WARNING: $issue');
        }
      }
      print('=============================');
    }
  }
}
```

---

## 💡 **Usage Examples**

### Basic Usage

```dart
// Menggunakan configuration values
class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    // Setup base configuration
    _dio.options.baseUrl = AppConfig.apiBaseUrl;
    _dio.options.connectTimeout = AppConfig.apiTimeout;
    _dio.options.headers = {
      AppConfig.contentTypeHeader: AppConfig.contentTypeHeader,
      AppConfig.acceptHeader: AppConfig.acceptHeader,
    };
  }

  Future<Response> getData(String endpoint) async {
    try {
      return await _dio.get(endpoint);
    } catch (e) {
      // Log error jika logging enabled
      if (AppConfig.enableLogging) {
        logger.error('API call failed', e);
      }
      rethrow;
    }
  }
}
```

### Environment-Specific Logic

```dart
// Logika berdasarkan environment
class FeatureFlagService {
  static bool isFeatureEnabled(String featureName) {
    switch (AppConfig.currentEnvironment) {
      case Environment.development:
        return _getDevelopmentFeatureFlag(featureName);
      case Environment.staging:
        return _getStagingFeatureFlag(featureName);
      case Environment.production:
        return _getProductionFeatureFlag(featureName);
    }
  }

  static bool _getDevelopmentFeatureFlag(String featureName) {
    // Development: semua features enabled
    return true;
  }

  static bool _getStagingFeatureFlag(String featureName) {
    // Staging: selective features enabled
    switch (featureName) {
      case 'advanced_analytics':
        return AppConfig.enableAnalytics;
      case 'performance_monitoring':
        return AppConfig.enablePerformanceMonitoring;
      default:
        return true;
    }
  }

  static bool _getProductionFeatureFlag(String featureName) {
    // Production: only stable features enabled
    switch (featureName) {
      case 'debug_tools':
        return false;
      case 'performance_monitoring':
        return AppConfig.enablePerformanceMonitoring;
      default:
        return true;
    }
  }
}
```

### Configuration Validation

```dart
// Validasi configuration saat startup
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment configuration
  await EnvConfig.load();

  // Validate configuration
  final configIssues = AppConfig.getAllConfigIssues();
  if (configIssues.isNotEmpty) {
    print('Configuration Issues:');
    for (final issue in configIssues) {
      print('  - $issue');
    }

    // In production, exit if critical configuration is missing
    if (AppConfig.isProduction) {
      exit(1);
    }
  }

  // Debug print configuration in development
  AppConfig.debugPrintConfig();

  // Run app
  runApp(const MyApp());
}
```

### Dynamic Configuration

```dart
// Perubahan konfigurasi runtime
class ConfigurationService {
  static void updatePerformanceMonitoring(bool enabled) {
    // Update feature flag
    // Note: Ini hanya untuk development/debug purposes
    if (AppConfig.isDevelopment) {
      // Update internal state
      _performanceMonitoringEnabled = enabled;

      // Notify listeners
      _notifyConfigurationChanged('performance_monitoring', enabled);
    }
  }

  static void updateLogLevel(String level) {
    // Update log level
    if (AppConfig.isDevelopment) {
      _currentLogLevel = level;
      _notifyConfigurationChanged('log_level', level);
    }
  }

  static void _notifyConfigurationChanged(String key, dynamic value) {
    // Notify configuration change
    // Bisa digunakan untuk update UI atau restart services
    print('Configuration changed: $key = $value');
  }
}
```

---

## 🎯 **Best Practices**

### 1. **Environment Separation**

```dart
// ✅ GOOD: Environment-specific configuration
class AppConfig {
  static String get apiBaseUrl {
    switch (EnvConfig.currentEnvironment) {
      case Environment.development:
        return 'http://localhost:3000';
      case Environment.staging:
        return 'https://staging-api.usago.id';
      case Environment.production:
        return 'https://api.usago.id';
    }
  }
}

// ❌ BAD: Hardcoded values
class AppConfig {
  static const String apiBaseUrl = 'https://api.usago.id'; // Production only!
}
```

### 2. **Type Safety**

```dart
// ✅ GOOD: Type-safe configuration access
static Duration get networkTimeout => Duration(
  seconds: EnvConfig.getInt('NETWORK_TIMEOUT_SECONDS', defaultValue: 30),
);

// ❌ BAD: String-based configuration
static String get networkTimeout => EnvConfig.get('NETWORK_TIMEOUT_SECONDS');
```

### 3. **Validation**

```dart
// ✅ GOOD: Validate configuration on startup
void main() async {
  await EnvConfig.load();

  if (!AppConfig.isConfigValid) {
    print('Configuration is invalid!');
    exit(1);
  }

  runApp(MyApp());
}

// ❌ BAD: No validation
void main() {
  runApp(MyApp()); // Might crash with invalid config
}
```

### 4. **Security**

```dart
// ✅ GOOD: Use environment variables for secrets
static String get encryptionKey => EnvConfig.get('ENCRYPTION_KEY');

// ❌ BAD: Hardcode secrets
static const String encryptionKey = 'hardcoded_secret_key'; // Security risk!
```

### 5. **Default Values**

```dart
// ✅ GOOD: Provide sensible defaults
static bool get enableLogging => EnvConfig.getBool('ENABLE_LOGGING', defaultValue: kDebugMode);

// ❌ BAD: Assume values exist
static bool get enableLogging => EnvConfig.getBool('ENABLE_LOGGING'); // Might throw!
```

---

## 🔗 **Related Documentation**

- [`shared-utilities-guide.md`](./shared-utilities-guide.md) - Shared utilities documentation
- [`architecture-patterns.md`](./architecture-patterns.md) - Architecture patterns and data flow
- [`performance-monitoring.md`](./performance-monitoring.md) - Performance monitoring guide
- [`security-implementation.md`](./security-implementation.md) - Security best practices
- [`code-review-checklist.md`](./code-review-checklist.md) - Code review guidelines

---

## 📞 **Contact Information**

### **Development Team**

| Role | Name | Contact |
|-------|-------|----------|
| **Mobile Lead** | [Name] | [Email] |
| **DevOps Lead** | [Name] | [Email] |
| **Tech Lead** | [Name] | [Email] |

### **Support**

| Issue | Contact | Response Time |
|-------|----------|---------------|
| **Configuration Issue** | [Name] | 2 hours |
| **Environment Setup** | [Name] | 4 hours |
| **Security Configuration** | [Name] | 1 hour |

---

## 📝 **Notes**

### **Current Status (November 15, 2025)**
- ✅ **Environment Files**: Complete configuration for all environments
- ✅ **Constants Files**: Comprehensive constants with documentation
- ✅ **EnvConfig Class**: Robust loading and validation
- ✅ **AppConfig Class**: Centralized configuration access
- ✅ **Validation**: Built-in validation and safety checks
- ✅ **Type Safety**: Strong typing for all configuration values

### **Future Enhancements**
- 🔄 **Remote Configuration**: Dynamic configuration from server
- 🔄 **Feature Flags**: Advanced feature flag management
- 🔄 **Configuration UI**: Admin interface for configuration
- 🔄 **A/B Testing**: Configuration for A/B testing
- 🔄 **Environment Promotion**: Automated environment promotion

---

**Document End**

**Go Digital, Grow Together.**