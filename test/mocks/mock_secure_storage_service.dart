import 'package:mocktail/mocktail.dart';

import '../../lib/core/services/secure_storage_service.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {
  MockSecureStorageService() {
    // Register fallback methods
    registerFallbackValue(Future.value(null));
  }

  @override
  Future<T?> get<T>(String key, {bool isSecure = true}) async {
    return Future.value(null);
  }

  @override
  Future<void> save(String key, dynamic value, {bool isSecure = false}) async {
    // Mock implementation
  }

  @override
  Future<void> remove(String key, {bool isSecure = true}) async {
    // Mock implementation
  }

  @override
  Future<void> clearAll() async {
    // Mock implementation
  }

  @override
  Future<bool> containsKey(String key, {bool isSecure = true}) async {
    // Mock implementation
    return false;
  }

  @override
  Future<Set<String>> getSecureKeys() async {
    // Mock implementation
    return <String>{};
  }

  @override
  Future<void> migrateFromSharedPreferences() async {
    // Mock implementation
  }
}
