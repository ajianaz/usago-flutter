import 'package:flutter/foundation.dart';
import '../utils/logger.dart';

/// Platform detection utility for cross-platform compatibility
/// Provides unified interface to detect current platform and capabilities
class PlatformDetector {
  static final AppLogger _logger = AppLogger();

  /// Check if running on mobile platform (iOS or Android)
  static bool get isMobile {
    try {
      return defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android;
    } catch (e) {
      _logger.warning('Failed to detect mobile platform', e);
      return false;
    }
  }

  /// Check if running on iOS
  static bool get isIOS {
    try {
      return defaultTargetPlatform == TargetPlatform.iOS;
    } catch (e) {
      _logger.warning('Failed to detect iOS platform', e);
      return false;
    }
  }

  /// Check if running on Android
  static bool get isAndroid {
    try {
      return defaultTargetPlatform == TargetPlatform.android;
    } catch (e) {
      _logger.warning('Failed to detect Android platform', e);
      return false;
    }
  }

  /// Check if running on web platform
  static bool get isWeb {
    try {
      return kIsWeb;
    } catch (e) {
      _logger.warning('Failed to detect web platform', e);
      return false;
    }
  }

  /// Check if running on desktop platform (Windows, macOS, Linux)
  static bool get isDesktop {
    try {
      return kIsWeb == false && !isMobile;
    } catch (e) {
      _logger.warning('Failed to detect desktop platform', e);
      return false;
    }
  }

  /// Check if running on Windows
  static bool get isWindows {
    try {
      return defaultTargetPlatform == TargetPlatform.windows;
    } catch (e) {
      _logger.warning('Failed to detect Windows platform', e);
      return false;
    }
  }

  /// Check if running on macOS
  static bool get isMacOS {
    try {
      return defaultTargetPlatform == TargetPlatform.macOS;
    } catch (e) {
      _logger.warning('Failed to detect macOS platform', e);
      return false;
    }
  }

  /// Check if running on Linux
  static bool get isLinux {
    try {
      return defaultTargetPlatform == TargetPlatform.linux;
    } catch (e) {
      _logger.warning('Failed to detect Linux platform', e);
      return false;
    }
  }

  /// Get platform name as string
  static String get platformName {
    try {
      if (isIOS) return 'iOS';
      if (isAndroid) return 'Android';
      if (isWeb) return 'Web';
      if (isWindows) return 'Windows';
      if (isMacOS) return 'macOS';
      if (isLinux) return 'Linux';
      return 'Unknown';
    } catch (e) {
      _logger.warning('Failed to get platform name', e);
      return 'Unknown';
    }
  }

  /// Get platform-specific capabilities and features
  static Map<String, dynamic> get platformCapabilities {
    return {
      'platform': platformName,
      'isMobile': isMobile,
      'isWeb': isWeb,
      'isDesktop': isDesktop,
      'hasTouchScreen': isMobile,
      'hasMouse': isDesktop,
      'hasKeyboard': true, // Assume all platforms have keyboard input
      'hasSecureStorage': isMobile, // Flutter Secure Storage is mobile-only
      'hasFileSystem': !isWeb,
      'hasNetwork': true, // Assume all platforms have network capability
      'supportsNotifications':
          isMobile || isWeb, // Mobile and web support notifications
      'supportsBiometrics': isMobile, // Biometrics typically mobile-only
      'hasCamera': true, // Most platforms support camera
      'hasGPS': isMobile, // GPS typically mobile-only
    };
  }

  /// Check if specific feature is supported on current platform
  static bool isFeatureSupported(String feature) {
    final capabilities = platformCapabilities;

    switch (feature.toLowerCase()) {
      case 'secure_storage':
        return capabilities['hasSecureStorage'] as bool;
      case 'biometrics':
        return capabilities['supportsBiometrics'] as bool;
      case 'gps':
        return capabilities['hasGPS'] as bool;
      case 'camera':
        return capabilities['hasCamera'] as bool;
      case 'notifications':
        return capabilities['supportsNotifications'] as bool;
      case 'file_system':
        return capabilities['hasFileSystem'] as bool;
      default:
        return true; // Assume unknown features are supported
    }
  }

  /// Get recommended storage method for current platform
  static String get recommendedStorage {
    if (isMobile) {
      return 'FlutterSecureStorage';
    } else if (isWeb) {
      return 'WebStorage (localStorage/sessionStorage)';
    } else {
      return 'SharedPreferences';
    }
  }

  /// Log platform information for debugging
  static void logPlatformInfo() {
    final capabilities = platformCapabilities;
    _logger.info('=== Platform Information ===');
    _logger.info('Platform: ${capabilities['platform']}');
    _logger.info('Mobile: ${capabilities['isMobile']}');
    _logger.info('Web: ${capabilities['isWeb']}');
    _logger.info('Desktop: ${capabilities['isDesktop']}');
    _logger.info('Recommended Storage: $recommendedStorage');
    _logger.info('Features:');

    final features = [
      'Secure Storage',
      'Biometrics',
      'GPS',
      'Camera',
      'Notifications',
      'File System',
    ];

    for (final feature in features) {
      final supported = isFeatureSupported(feature);
      _logger.info('  $feature: ${supported ? 'Supported' : 'Not Supported'}');
    }

    _logger.info('=== End Platform Information ===');
  }
}
