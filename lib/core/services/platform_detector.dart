import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// Platform detection utility for cross-platform compatibility
///
/// This class provides methods to detect the current platform
/// and determine which storage implementation should be used.
class PlatformDetector {
  /// Check if current platform is mobile (iOS/Android)
  static bool get isMobile => !kIsWeb && (Platform.isIOS || Platform.isAndroid);

  /// Check if current platform is web
  static bool get isWeb => kIsWeb;

  /// Check if current platform is desktop (Windows/Linux/macOS)
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

  /// Check if current platform is iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Check if current platform is Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Check if current platform is Windows
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Check if current platform is Linux
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  /// Check if current platform is macOS
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// Get platform name as string
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isMacOS) return 'macOS';
    return 'Unknown';
  }

  /// Check if secure storage is supported on current platform
  static bool get isSecureStorageSupported {
    // All platforms support some form of secure storage
    return true;
  }

  /// Check if encryption is available on current platform
  static bool get isEncryptionAvailable {
    // All platforms support encryption
    return true;
  }

  /// Get storage type recommendation for current platform
  static String get recommendedStorageType {
    if (isWeb) return 'encrypted_web_storage';
    if (isMobile) return 'flutter_secure_storage';
    if (isDesktop) return 'platform_secure_storage';
    return 'shared_preferences';
  }
}
