import 'dart:async';

/// Abstract interface for platform-specific storage implementations
///
/// This interface defines the contract that all platform-specific
/// storage implementations must follow, ensuring consistent API
/// across mobile, web, and desktop platforms.
abstract class PlatformStorageInterface {
  /// Initialize the storage implementation
  Future<void> initialize();

  /// Save data to platform-specific secure storage
  ///
  /// [key] Storage key
  /// [value] Value to save
  Future<void> write(String key, String value);

  /// Read data from platform-specific secure storage
  ///
  /// [key] Storage key
  /// Returns [String?] or null if not found
  Future<String?> read(String key);

  /// Delete data from platform-specific secure storage
  ///
  /// [key] Storage key
  Future<void> delete(String key);

  /// Delete all data from platform-specific secure storage
  Future<void> deleteAll();

  /// Check if key exists in platform-specific secure storage
  ///
  /// [key] Storage key
  /// Returns [bool] true if key exists
  Future<bool> containsKey(String key);

  /// Get all keys from platform-specific secure storage
  Future<Set<String>> getAllKeys();
}
