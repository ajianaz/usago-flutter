# Cross-Platform Secure Storage Documentation

## Overview

SecureStorageService provides cross-platform secure storage capabilities with platform-specific implementations for optimal security and performance.

## Architecture

```
SecureStorageService
├── PlatformStorageInterface (Abstract)
├── MobileSecureStorage (iOS/Android)
├── WebSecureStorage (Web with encryption)
├── DesktopSecureStorage (Windows/Linux/macOS)
└── _FallbackSecureStorage (SharedPreferences fallback)
```

## Platform Implementations

### Mobile (iOS/Android)

**Implementation**: `MobileSecureStorage`
**Storage Backend**: FlutterSecureStorage
**Security Features**:
- **iOS**: Keychain with `first_unlock` accessibility
- **Android**: EncryptedSharedPreferences with RSA/AES encryption
- **Configuration**: Platform-specific optimal settings

**Security Level**: ⭐⭐⭐⭐⭐ (Highest)

**Usage**:
```dart
// Automatic initialization based on platform
final storage = SecureStorageService();
await storage.initialize();
await storage.save('auth_token', 'token_value');
```

### Web

**Implementation**: `WebSecureStorage`
**Storage Backend**: SharedPreferences + Custom Encryption
**Security Features**:
- XOR cipher with SHA-256 key derivation
- Browser fingerprinting for key generation
- Base64 encoding for storage
- Prefix-based key isolation

**Security Level**: ⭐⭐⭐ (Good - limited by browser constraints)

**Encryption Details**:
- Algorithm: XOR cipher with SHA-256 derived key
- Key Source: Browser fingerprint + timestamp
- Storage: Base64 encoded in localStorage
- Fallback: Default key if encryption fails

**Usage**:
```dart
// Web automatically uses encrypted storage
final storage = SecureStorageService();
await storage.initialize();
await storage.save('auth_token', 'token_value'); // Automatically encrypted
```

**Limitations**:
- No hardware security module (HSM)
- Dependent on browser security
- Encryption strength limited to XOR cipher
- Vulnerable to XSS attacks (like all web storage)

### Desktop (Windows/Linux/macOS)

**Implementation**: `DesktopSecureStorage`
**Storage Backend**: FlutterSecureStorage with platform-specific backends
**Security Features**:
- **Windows**: DPAPI (Data Protection API)
- **Linux**: libsecret/GNOME Keyring
- **macOS**: Keychain (similar to iOS)
- **Configuration**: EncryptedSharedPreferences fallback

**Security Level**: ⭐⭐⭐⭐ (High)

**Platform Details**:
- **Windows**: Uses DPAPI for system-level encryption
- **Linux**: Integrates with GNOME Keyring/KWallet
- **macOS**: Uses Keychain with device-specific access

**Usage**:
```dart
// Desktop automatically uses platform secure storage
final storage = SecureStorageService();
await storage.initialize();
await storage.save('auth_token', 'token_value');
```

## Fallback Mechanism

### _FallbackSecureStorage

**Purpose**: Emergency fallback when secure storage fails
**Storage Backend**: SharedPreferences
**Security Level**: ⭐ (Not Secure - Plaintext)

**When Used**:
- Platform detection fails
- Secure storage initialization fails
- Platform not supported

**Warning**: This fallback is NOT secure and should only be used for non-sensitive data or during development.

## Security Considerations

### Data Classification

The service automatically classifies data as sensitive if:
- Key matches predefined sensitive keys
- Key contains: 'token', 'password', 'secret', 'key'
- Explicitly marked as secure via `isSecure: true`

### Sensitive Keys (Always Secure)
```dart
static const String authTokenKey = 'auth_token';
static const String bearerTokenKey = 'bearer_token';
static const String refreshTokenKey = 'refresh_token';
static const String sessionDataKey = 'session_data';
static const String biometricEnabledKey = 'biometric_enabled';
```

### Non-Sensitive Data Storage
Non-sensitive data is stored in SharedPreferences without encryption for better performance.

## Error Handling

### Platform-Specific Errors
Each platform implementation handles:
- Initialization failures
- Read/write permission errors
- Storage corruption
- Platform-specific limitations

### Fallback Strategy
1. Try platform-specific secure storage
2. Fall back to SharedPreferences with warning
3. Log all failures for debugging

## Migration

### From SharedPreferences to Secure Storage
```dart
await storage.migrateFromSharedPreferences();
```

This utility migrates sensitive data from SharedPreferences to the appropriate secure storage for the current platform.

## Best Practices

### 1. Always Initialize
```dart
await storage.initialize(); // Required before any operation
```

### 2. Use Appropriate Storage Type
```dart
// Sensitive data (default)
await storage.save('auth_token', token);

// Non-sensitive data
await storage.save('user_preference', value, isSecure: false);
```

### 3. Handle Platform Differences
```dart
if (PlatformDetector.isWeb) {
  // Web-specific considerations
} else if (PlatformDetector.isMobile) {
  // Mobile-specific considerations
}
```

### 4. Monitor Security Level
```dart
final platform = PlatformDetector.platformName;
final isSecure = PlatformDetector.isSecureStorageSupported;
```

## Performance Considerations

### Mobile
- Fast access to hardware security modules
- Optimized for battery usage
- Minimal overhead

### Web
- Encryption/decryption overhead
- Browser storage limitations
- Network-dependent for some operations

### Desktop
- System-level encryption overhead
- File system-based operations
- Generally fastest for large datasets

## Testing

### Platform Testing
Test on all target platforms:
- iOS Simulator/Device
- Android Emulator/Device
- Web browsers (Chrome, Firefox, Safari)
- Desktop (Windows, Linux, macOS)

### Security Testing
- Verify encryption works correctly
- Test fallback mechanisms
- Validate data isolation
- Check for data leakage

## Troubleshooting

### Common Issues

1. **Initialization Fails**
   - Check platform support
   - Verify permissions
   - Review platform-specific requirements

2. **Data Not Persisting**
   - Verify storage backend
   - Check for quota limits (web)
   - Review permission settings

3. **Performance Issues**
   - Consider data classification
   - Use non-secure storage for large data
   - Optimize encryption overhead

### Debug Logging
Enable detailed logging:
```dart
final storage = SecureStorageService(
  logger: AppLogger(level: LogLevel.debug)
);
```

## Future Enhancements

### Planned Features
- Hardware security module (HSM) integration
- Biometric authentication integration
- Cross-platform key synchronization
- Advanced encryption algorithms
- Performance optimization

### Platform-Specific Improvements
- **Web**: Web Crypto API integration
- **Mobile**: Secure Enclave/Keystore integration
- **Desktop**: Enhanced platform integration