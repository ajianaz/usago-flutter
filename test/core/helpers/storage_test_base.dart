import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'core_test_base.dart';
import 'core_test_helpers.dart';
import 'test_constants.dart';
import '../../../lib/core/services/secure_storage_service.dart';
import '../../../lib/core/services/enhanced_secure_storage_service.dart';
import '../../../lib/core/errors/failure.dart';
import '../../../lib/core/errors/exceptions.dart';

/// Base test class for storage-related tests
/// Provides common setup and utilities for testing storage components
abstract class StorageTestBase extends CoreTestBase {
  // Storage-specific test data
  late Map<String, String> testSecureData;
  late Map<String, String> testNonSecureData;
  late List<String> testKeys;
  late List<String> testValues;
  late Exception storageException;
  late Exception securityException;

  @override
  void setUp() {
    super.setUp();

    // Initialize storage-specific test data
    testSecureData = createTestSecureData();
    testNonSecureData = createTestNonSecureData();
    testKeys = createTestKeys();
    testValues = createTestValues();
    storageException = createStorageException();
    securityException = createSecurityException();
  }

  /// Create test secure data
  Map<String, String> createTestSecureData({
    String? token,
    String? userData,
    String? sessionData,
  }) {
    return {
      'access_token': token ?? CoreTestConstants.testAuthToken,
      'refresh_token': 'refresh_token_here',
      'user_data': userData ?? '{"id":1,"name":"Test User"}',
      'session_data': sessionData ?? '{"device_id":"test_device_123"}',
    };
  }

  /// Create test non-secure data
  Map<String, String> createTestNonSecureData({
    String? theme,
    String? language,
    String? preferences,
  }) {
    return {
      'theme': theme ?? 'light',
      'language': language ?? 'en',
      'preferences': preferences ?? '{"notifications":true}',
    };
  }

  /// Create test keys
  List<String> createTestKeys() {
    return [
      CoreTestConstants.testStorageKey,
      'access_token',
      'refresh_token',
      'user_data',
      'session_data',
      'theme',
      'language',
      'preferences',
      'app_settings',
      'cache_data',
    ];
  }

  /// Create test values
  List<String> createTestValues() {
    return [
      CoreTestConstants.testStorageValue,
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
    ];
  }

  /// Create storage exception
  Exception createStorageException({
    String? message,
  }) {
    return Exception(message ?? 'Storage operation failed');
  }

  /// Create security exception
  Exception createSecurityException({
    String? message,
  }) {
    return Exception(message ?? 'Security violation in storage operation');
  }

  /// Setup successful secure storage read
  void setupSecureReadSuccess({
    String key = CoreTestConstants.testStorageKey,
    String value = CoreTestConstants.testStorageValue,
  }) {
    when(mockSecureStorageService.getSecureData(key))
        .thenAnswer((_) async => value);
  }

  /// Setup successful secure storage write
  void setupSecureWriteSuccess({
    String key = CoreTestConstants.testStorageKey,
    String value = CoreTestConstants.testStorageValue,
  }) {
    when(mockSecureStorageService.saveSecureData(key, value))
        .thenAnswer((_) async {});
  }

  /// Setup successful secure storage delete
  void setupSecureDeleteSuccess({
    String key = CoreTestConstants.testStorageKey,
  }) {
    when(mockSecureStorageService.removeSecureData(key))
        .thenAnswer((_) async {});
  }

  /// Setup successful non-secure storage read
  void setupNonSecureReadSuccess({
    String key = CoreTestConstants.testStorageKey,
    String value = CoreTestConstants.testStorageValue,
  }) {
    when(mockSecureStorageService.getNonSecureData(key))
        .thenAnswer((_) async => value);
  }

  /// Setup successful non-secure storage write
  void setupNonSecureWriteSuccess({
    String key = CoreTestConstants.testStorageKey,
    String value = CoreTestConstants.testStorageValue,
  }) {
    when(mockSecureStorageService.saveNonSecureData(key, value))
        .thenAnswer((_) async {});
  }

  /// Setup successful non-secure storage delete
  void setupNonSecureDeleteSuccess({
    String key = CoreTestConstants.testStorageKey,
  }) {
    when(mockSecureStorageService.removeNonSecureData(key))
        .thenAnswer((_) async {});
  }

  /// Setup secure storage read error
  void setupSecureReadError({
    String key = CoreTestConstants.testStorageKey,
    Exception? error,
  }) {
    when(mockSecureStorageService.getSecureData(key))
        .thenThrow(error ?? storageException);
  }

  /// Setup secure storage write error
  void setupSecureWriteError({
    String key = CoreTestConstants.testStorageKey,
    Exception? error,
  }) {
    when(mockSecureStorageService.saveSecureData(key, any))
        .thenThrow(error ?? securityException);
  }

  /// Setup secure storage delete error
  void setupSecureDeleteError({
    String key = CoreTestConstants.testStorageKey,
    Exception? error,
  }) {
    when(mockSecureStorageService.removeSecureData(key))
        .thenThrow(error ?? storageException);
  }

  /// Setup non-secure storage read error
  void setupNonSecureReadError({
    String key = CoreTestConstants.testStorageKey,
    Exception? error,
  }) {
    when(mockSecureStorageService.getNonSecureData(key))
        .thenThrow(error ?? storageException);
  }

  /// Setup non-secure storage write error
  void setupNonSecureWriteError({
    String key = CoreTestConstants.testStorageKey,
    Exception? error,
  }) {
    when(mockSecureStorageService.saveNonSecureData(key, any))
        .thenThrow(error ?? storageException);
  }

  /// Setup non-secure storage delete error
  void setupNonSecureDeleteError({
    String key = CoreTestConstants.testStorageKey,
    Exception? error,
  }) {
    when(mockSecureStorageService.removeNonSecureData(key))
        .thenThrow(error ?? storageException);
  }

  /// Setup secure storage availability
  void setupSecureStorageAvailability({
    bool isAvailable = true,
  }) {
    when(mockSecureStorageService.isSecureStorageAvailable)
        .thenReturn(isAvailable);
  }

  /// Verify secure storage read was called
  void verifySecureReadCalled({
    String key = CoreTestConstants.testStorageKey,
    int times = 1,
  }) {
    verify(mockSecureStorageService.getSecureData(key)).called(times);
  }

  /// Verify secure storage write was called
  void verifySecureWriteCalled({
    String key = CoreTestConstants.testStorageKey,
    String value = CoreTestConstants.testStorageValue,
    int times = 1,
  }) {
    verify(mockSecureStorageService.saveSecureData(key, value)).called(times);
  }

  /// Verify secure storage delete was called
  void verifySecureDeleteCalled({
    String key = CoreTestConstants.testStorageKey,
    int times = 1,
  }) {
    verify(mockSecureStorageService.removeSecureData(key)).called(times);
  }

  /// Verify non-secure storage read was called
  void verifyNonSecureReadCalled({
    String key = CoreTestConstants.testStorageKey,
    int times = 1,
  }) {
    verify(mockSecureStorageService.getNonSecureData(key)).called(times);
  }

  /// Verify non-secure storage write was called
  void verifyNonSecureWriteCalled({
    String key = CoreTestConstants.testStorageKey,
    String value = CoreTestConstants.testStorageValue,
    int times = 1,
  }) {
    verify(mockSecureStorageService.saveNonSecureData(key, value)).called(times);
  }

  /// Verify non-secure storage delete was called
  void verifyNonSecureDeleteCalled({
    String key = CoreTestConstants.testStorageKey,
    int times = 1,
  }) {
    verify(mockSecureStorageService.removeNonSecureData(key)).called(times);
  }

  /// Verify no storage operations were made
  void verifyNoStorageOperations() {
    verifyNeverCalled(mockSecureStorageService);
  }

  /// Test successful secure storage operation
  Future<void> testSecureStorageSuccess(
    String description,
    Future<void> Function() operation,
  ) async {
    // Arrange
    setupSecureWriteSuccess();

    // Act & Assert
    await expectLater(operation(), completes);
    verifySecureWriteCalled();

    // Cleanup
    tearDown();
  }

  /// Test secure storage error
  Future<void> testSecureStorageError(
    String description,
    Future<void> Function() operation,
    Exception? expectedError,
  ) async {
    // Arrange
    setupSecureWriteError(error: expectedError);

    // Act & Assert
    expect(
      () => operation(),
      throwsA(expectedError ?? securityException),
    );
    verifySecureWriteCalled();

    // Cleanup
    tearDown();
  }

  /// Test successful non-secure storage operation
  Future<void> testNonSecureStorageSuccess(
    String description,
    Future<void> Function() operation,
  ) async {
    // Arrange
    setupNonSecureWriteSuccess();

    // Act & Assert
    await expectLater(operation(), completes);
    verifyNonSecureWriteCalled();

    // Cleanup
    tearDown();
  }

  /// Test non-secure storage error
  Future<void> testNonSecureStorageError(
    String description,
    Future<void> Function() operation,
    Exception? expectedError,
  ) async {
    // Arrange
    setupNonSecureWriteError(error: expectedError);

    // Act & Assert
    expect(
      () => operation(),
      throwsA(expectedError ?? storageException),
    );
    verifyNonSecureWriteCalled();

    // Cleanup
    tearDown();
  }

  /// Test storage availability
  Future<void> testStorageAvailability(
    String description,
    bool expectedAvailability,
  ) async {
    // Arrange
    setupSecureStorageAvailability(isAvailable: expectedAvailability);

    // Act & Assert
    expect(mockSecureStorageService.isSecureStorageAvailable, expectedAvailability);

    // Cleanup
    tearDown();
  }

  /// Test secure data encryption/decryption
  Future<void> testSecureDataIntegrity(
    String description,
    String originalData,
  ) async {
    // Arrange
    setupSecureWriteSuccess(value: originalData);
    setupSecureReadSuccess(value: originalData);

    // Act
    await mockSecureStorageService.saveSecureData(
      CoreTestConstants.testStorageKey,
      originalData,
    );
    final retrievedData = await mockSecureStorageService.getSecureData(
      CoreTestConstants.testStorageKey,
    );

    // Assert
    expect(retrievedData, equals(originalData));
    verifySecureWriteCalled();
    verifySecureReadCalled();

    // Cleanup
    tearDown();
  }

  /// Test storage cleanup operations
  Future<void> testStorageCleanup(
    String description,
  ) async {
    // Arrange
    setupSecureWriteSuccess();
    setupNonSecureWriteSuccess();

    // Act
    await mockSecureStorageService.clearAllSecureData();
    await mockSecureStorageService.clearAllNonSecureData();

    // Assert
    verify(mockSecureStorageService.clearAllSecureData).called(1);
    verify(mockSecureStorageService.clearAllNonSecureData).called(1);

    // Cleanup
    tearDown();
  }
}