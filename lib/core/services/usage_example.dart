import 'package:flutter/material.dart';
import 'secure_storage_service.dart';
import 'platform_detector.dart';
import '../constants/storage_constants.dart';

/// Example usage of cross-platform SecureStorageService
///
/// This file demonstrates how to use the SecureStorageService
/// across different platforms with proper error handling.
class SecureStorageExample {
  late SecureStorageService _storage;

  /// Initialize secure storage with platform detection
  Future<void> initialize() async {
    try {
      _storage = SecureStorageService();
      await _storage.initialize();

      debugPrint(
          'SecureStorage initialized for ${PlatformDetector.platformName}');
      debugPrint(
          'Secure storage supported: ${PlatformDetector.isSecureStorageSupported}');
      debugPrint(
          'Encryption available: ${PlatformDetector.isEncryptionAvailable}');
    } catch (e) {
      debugPrint('Failed to initialize secure storage: $e');
      rethrow;
    }
  }

  /// Example: Save authentication token
  Future<void> saveAuthToken() async {
    try {
      const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'; // JWT token
      await _storage.save(
        StorageConstants.authTokenKey,
        token,
        isSecure: true, // Explicitly secure
      );
      debugPrint('Auth token saved securely');
    } catch (e) {
      debugPrint('Failed to save auth token: $e');
    }
  }

  /// Example: Save user preferences (non-sensitive)
  Future<void> saveUserPreferences() async {
    try {
      const preferences = {
        'theme': 'dark',
        'language': 'id',
        'notifications_enabled': true,
      };

      await _storage.save(
        'user_preferences',
        preferences,
        isSecure: false, // Non-sensitive data
      );
      debugPrint('User preferences saved');
    } catch (e) {
      debugPrint('Failed to save user preferences: $e');
    }
  }

  /// Example: Retrieve authentication token
  Future<String?> getAuthToken() async {
    try {
      final token = await _storage.get<String>(
        StorageConstants.authTokenKey,
        isSecure: true,
      );

      if (token != null) {
        debugPrint('Auth token retrieved successfully');
      } else {
        debugPrint('No auth token found');
      }

      return token;
    } catch (e) {
      debugPrint('Failed to get auth token: $e');
      return null;
    }
  }

  /// Example: Retrieve user preferences
  Future<Map<String, dynamic>?> getUserPreferences() async {
    try {
      final preferences = await _storage.get<Map<String, dynamic>>(
        'user_preferences',
        isSecure: false,
      );

      if (preferences != null) {
        debugPrint('User preferences retrieved: $preferences');
      } else {
        debugPrint('No user preferences found');
      }

      return preferences;
    } catch (e) {
      debugPrint('Failed to get user preferences: $e');
      return null;
    }
  }

  /// Example: Check if user is logged in
  Future<bool> isUserLoggedIn() async {
    try {
      final hasToken = await _storage.containsKey(
        StorageConstants.authTokenKey,
        isSecure: true,
      );
      debugPrint('User logged in: $hasToken');
      return hasToken;
    } catch (e) {
      debugPrint('Failed to check login status: $e');
      return false;
    }
  }

  /// Example: Logout user
  Future<void> logout() async {
    try {
      // Remove sensitive data
      await _storage.remove(StorageConstants.authTokenKey, isSecure: true);
      await _storage.remove(StorageConstants.refreshTokenKey, isSecure: true);
      await _storage.remove(StorageConstants.sessionDataKey, isSecure: true);

      debugPrint('User logged out successfully');
    } catch (e) {
      debugPrint('Failed to logout: $e');
    }
  }

  /// Example: Clear all storage data
  Future<void> clearAllData() async {
    try {
      await _storage.clearAll();
      debugPrint('All storage data cleared');
    } catch (e) {
      debugPrint('Failed to clear all data: $e');
    }
  }

  /// Example: Migrate from old SharedPreferences
  Future<void> migrateOldData() async {
    try {
      await _storage.migrateFromSharedPreferences();
      debugPrint('Data migration completed');
    } catch (e) {
      debugPrint('Data migration failed: $e');
    }
  }

  /// Example: Platform-specific handling
  Future<void> platformSpecificOperations() async {
    if (PlatformDetector.isMobile) {
      debugPrint('Running on mobile platform');
      // Mobile-specific operations
      await _performMobileOperations();
    } else if (PlatformDetector.isWeb) {
      debugPrint('Running on web platform');
      // Web-specific operations
      await _performWebOperations();
    } else if (PlatformDetector.isDesktop) {
      debugPrint('Running on desktop platform');
      // Desktop-specific operations
      await _performDesktopOperations();
    }
  }

  Future<void> _performMobileOperations() async {
    // Mobile-specific secure storage operations
    debugPrint('Using hardware-backed secure storage');
  }

  Future<void> _performWebOperations() async {
    // Web-specific secure storage operations
    debugPrint('Using encrypted web storage');
  }

  Future<void> _performDesktopOperations() async {
    // Desktop-specific secure storage operations
    debugPrint('Using system secure storage');
  }

  /// Example: Error handling demonstration
  Future<void> demonstrateErrorHandling() async {
    try {
      // Try to save invalid data
      await _storage.save('test_key', null);
    } catch (e) {
      debugPrint('Expected error caught: $e');
    }

    try {
      // Try to access non-existent key
      final value = await _storage.get<String>('non_existent_key');
      debugPrint('Non-existent key value: $value'); // Should be null
    } catch (e) {
      debugPrint('Unexpected error: $e');
    }
  }

  /// Example: Performance testing
  Future<void> performanceTest() async {
    final stopwatch = Stopwatch()..start();

    // Test write performance
    for (int i = 0; i < 100; i++) {
      await _storage.save('test_key_$i', 'test_value_$i');
    }

    final writeTime = stopwatch.elapsedMilliseconds;
    stopwatch.reset();

    // Test read performance
    for (int i = 0; i < 100; i++) {
      await _storage.get<String>('test_key_$i');
    }

    final readTime = stopwatch.elapsedMilliseconds;

    debugPrint('Write performance: ${writeTime}ms for 100 operations');
    debugPrint('Read performance: ${readTime}ms for 100 operations');

    // Cleanup test data
    for (int i = 0; i < 100; i++) {
      await _storage.remove('test_key_$i');
    }
  }
}

/// Widget example for Flutter app integration
class SecureStorageDemo extends StatefulWidget {
  const SecureStorageDemo({super.key});

  @override
  State<SecureStorageDemo> createState() => _SecureStorageDemoState();
}

class _SecureStorageDemoState extends State<SecureStorageDemo> {
  late SecureStorageExample _example;
  bool _isInitialized = false;
  String? _authToken;
  Map<String, dynamic>? _preferences;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _initializeStorage();
  }

  Future<void> _initializeStorage() async {
    _example = SecureStorageExample();
    await _example.initialize();
    setState(() {
      _isInitialized = true;
    });
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _authToken = await _example.getAuthToken();
    _preferences = await _example.getUserPreferences();
    _isLoggedIn = await _example.isUserLoggedIn();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Storage Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Platform: ${PlatformDetector.platformName}'),
            Text('Logged In: $_isLoggedIn'),
            const SizedBox(height: 16),
            if (_authToken != null) ...[
              const Text('Auth Token (first 20 chars):'),
              Text(
                _authToken!.substring(
                    0, _authToken!.length > 20 ? 20 : _authToken!.length),
                style: const TextStyle(fontFamily: 'monospace'),
              ),
              const SizedBox(height: 16),
            ],
            if (_preferences != null) ...[
              const Text('User Preferences:'),
              Text(_preferences.toString()),
              const SizedBox(height: 16),
            ],
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _example.saveAuthToken();
                    await _loadUserData();
                  },
                  child: const Text('Save Auth Token'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _example.saveUserPreferences();
                    await _loadUserData();
                  },
                  child: const Text('Save Preferences'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _example.logout();
                    await _loadUserData();
                  },
                  child: const Text('Logout'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _example.clearAllData();
                    await _loadUserData();
                  },
                  child: const Text('Clear All'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _example.performanceTest();
                  },
                  child: const Text('Performance Test'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
