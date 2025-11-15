import '../helpers/test_constants.dart';

/// Storage data fixtures for testing
class StorageFixtures {
  /// Create test secure data
  static Map<String, String> createSecureData({
    String? accessToken,
    String? refreshToken,
    String? userData,
    String? sessionData,
  }) {
    return {
      'access_token': accessToken ?? CoreTestConstants.testAuthToken,
      'refresh_token': refreshToken ?? 'refresh_token_here',
      'user_data': userData ?? '{"id":1,"name":"Test User"}',
      'session_data': sessionData ?? '{"device_id":"test_device_123"}',
    };
  }

  /// Create test non-secure data
  static Map<String, String> createNonSecureData({
    String? theme,
    String? language,
    String? preferences,
    String? appSettings,
  }) {
    return {
      'theme': theme ?? 'light',
      'language': language ?? 'en',
      'preferences': preferences ?? '{"notifications":true}',
      'app_settings': appSettings ?? '{"auto_save":true}',
    };
  }

  /// Create test user data
  static Map<String, dynamic> createUserData({
    String? id,
    String? name,
    String? email,
    bool? isEmailVerified,
    String? profilePicture,
  }) {
    return {
      'id': id ?? CoreTestConstants.testId,
      'name': name ?? 'Test User',
      'email': email ?? 'test@example.com',
      'isEmailVerified': isEmailVerified ?? true,
      'profilePicture': profilePicture ?? 'https://example.com/avatar.jpg',
      'createdAt': CoreTestConstants.testTimestamp.toIso8601String(),
      'updatedAt': CoreTestConstants.testTimestamp.toIso8601String(),
      'lastLoginAt': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test session data
  static Map<String, dynamic> createSessionData({
    String? deviceId,
    String? deviceType,
    String? userAgent,
    String? ipAddress,
    DateTime? loginTime,
    DateTime? expiresAt,
  }) {
    return {
      'device_id': deviceId ?? CoreTestConstants.testDeviceId,
      'device_type': deviceType ?? 'mobile',
      'user_agent': userAgent ?? CoreTestConstants.testAppName,
      'ip_address': ipAddress ?? '127.0.0.1',
      'login_time': loginTime?.toIso8601String() ?? CoreTestConstants.testTimestamp.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String() ?? CoreTestConstants.testFutureTimestamp.toIso8601String(),
    };
  }

  /// Create test app settings
  static Map<String, dynamic> createAppSettings({
    bool? autoSave,
    bool? notifications,
    bool? darkMode,
    bool? locationServices,
    double? fontSize,
  }) {
    return {
      'auto_save': autoSave ?? true,
      'notifications': notifications ?? true,
      'dark_mode': darkMode ?? false,
      'location_services': locationServices ?? false,
      'font_size': fontSize ?? CoreTestConstants.testFontSize,
      'updated_at': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test preferences
  static Map<String, dynamic> createPreferences({
    String? preferredLanguage,
    String? preferredTheme,
    List<String>? favoriteFeatures,
    Map<String, bool>? featureFlags,
  }) {
    return {
      'preferred_language': preferredLanguage ?? 'en',
      'preferred_theme': preferredTheme ?? 'light',
      'favorite_features': favoriteFeatures ?? ['notifications', 'auto_save'],
      'feature_flags': featureFlags ?? {
        'feature1': true,
        'feature2': false,
        'feature3': true,
      },
      'updated_at': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test cache data
  static Map<String, dynamic> createCacheData({
    String? key,
    dynamic? value,
    DateTime? expiresAt,
    String? etag,
  }) {
    return {
      'key': key ?? 'cache_key',
      'value': value ?? 'cached_value',
      'expires_at': expiresAt?.toIso8601String() ?? CoreTestConstants.testFutureTimestamp.toIso8601String(),
      'etag': etag ?? 'cache_etag',
      'created_at': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test encryption data
  static Map<String, dynamic> createEncryptionData({
    String? originalData,
    String? encryptedData,
    String? encryptionKey,
    String? algorithm,
  }) {
    return {
      'original_data': originalData ?? 'sensitive_data',
      'encrypted_data': encryptedData ?? CoreTestConstants.testEncryptedData,
      'encryption_key': encryptionKey ?? CoreTestConstants.testEncryptionKey,
      'algorithm': algorithm ?? 'AES-256-GCM',
      'created_at': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test storage keys
  static List<String> createStorageKeys() {
    return [
      'access_token',
      'refresh_token',
      'user_data',
      'session_data',
      'theme',
      'language',
      'preferences',
      'app_settings',
      'cache_data',
      'biometric_data',
      'device_fingerprint',
      'security_questions',
    ];
  }

  /// Create test storage values
  static List<String> createStorageValues() {
    return [
      CoreTestConstants.testAuthToken,
      'refresh_token_here',
      '{"id":1,"name":"Test User"}',
      '{"device_id":"test_device_123"}',
      'light',
      'dark',
      'en',
      'id',
      'true',
      'false',
      'cached_value_here',
      'biometric_enabled',
      'fingerprint_data',
      'security_answer_1',
    ];
  }

  /// Create test storage errors
  static Map<String, dynamic> createStorageError({
    String? key,
    String? error,
    String? code,
    String? details,
  }) {
    return {
      'key': key ?? CoreTestConstants.testStorageKey,
      'error': error ?? 'Storage operation failed',
      'code': code ?? 'STORAGE_ERROR',
      'details': details ?? 'Failed to access storage',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test security violation
  static Map<String, dynamic> createSecurityViolation({
    String? operation,
    String? reason,
    String? details,
  }) {
    return {
      'operation': operation ?? 'read_sensitive_data',
      'reason': reason ?? 'Security policy violation',
      'details': details ?? 'Attempted to access secure data without proper authentication',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test storage quota exceeded
  static Map<String, dynamic> createQuotaExceeded({
    String? key,
    int? currentSize,
    int? maxSize,
    String? unit,
  }) {
    return {
      'key': key ?? CoreTestConstants.testStorageKey,
      'current_size': currentSize ?? CoreTestConstants.testMemorySize,
      'max_size': maxSize ?? CoreTestConstants.testMaxFileSize,
      'unit': unit ?? 'bytes',
      'error': 'Storage quota exceeded',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test storage corrupted data
  static Map<String, dynamic> createCorruptedData({
    String? key,
    String? expectedChecksum,
    String? actualChecksum,
  }) {
    return {
      'key': key ?? CoreTestConstants.testStorageKey,
      'expected_checksum': expectedChecksum ?? 'abc123',
      'actual_checksum': actualChecksum ?? 'def456',
      'error': 'Data corruption detected',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test storage migration data
  static Map<String, dynamic> createMigrationData({
    String? fromVersion,
    String? toVersion,
    List<String>? migratedKeys,
  }) {
    return {
      'from_version': fromVersion ?? '1.0.0',
      'to_version': toVersion ?? '2.0.0',
      'migrated_keys': migratedKeys ?? ['user_data', 'preferences'],
      'status': 'success',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test storage backup data
  static Map<String, dynamic> createBackupData({
    String? backupId,
    List<String>? backedUpKeys,
    int? totalSize,
    String? compression,
  }) {
    return {
      'backup_id': backupId ?? CoreTestConstants.testId,
      'backed_up_keys': backedUpKeys ?? ['user_data', 'preferences', 'cache'],
      'total_size': totalSize ?? CoreTestConstants.testMemorySize,
      'compression': compression ?? 'gzip',
      'status': 'completed',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }
}