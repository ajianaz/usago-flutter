import '../helpers/test_constants.dart';

/// Platform detection fixtures for testing
class PlatformFixtures {
  /// Create iOS platform info
  static Map<String, dynamic> createIOSInfo({
    String? version,
    String? deviceModel,
    String? systemVersion,
    bool? isPhysicalDevice,
    double? screenHeight,
    double? screenWidth,
  }) {
    return {
      'platform': CoreTestConstants.testPlatformNames[0], // iOS
      'version': version ?? '16.0.0',
      'device_model': deviceModel ?? 'iPhone14,3',
      'system_version': systemVersion ?? 'iOS 16.0.0',
      'is_physical_device': isPhysicalDevice ?? true,
      'screen_height': screenHeight ?? 844.0,
      'screen_width': screenWidth ?? 390.0,
      'is_mobile': true,
      'is_desktop': false,
      'is_web': false,
      'has_touch_screen': true,
      'has_mouse': false,
      'has_keyboard': true,
      'has_secure_storage': true,
      'has_file_system': true,
      'supports_notifications': true,
      'supports_biometrics': true,
      'has_camera': true,
      'has_gps': true,
      'recommended_storage': 'FlutterSecureStorage',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create Android platform info
  static Map<String, dynamic> createAndroidInfo({
    String? version,
    String? deviceModel,
    String? manufacturer,
    String? sdkVersion,
    int? apiLevel,
    bool? isPhysicalDevice,
    double? screenHeight,
    double? screenWidth,
  }) {
    return {
      'platform': CoreTestConstants.testPlatformNames[1], // Android
      'version': version ?? '13.0.0',
      'device_model': deviceModel ?? 'Pixel 6',
      'manufacturer': manufacturer ?? 'Google',
      'sdk_version': sdkVersion ?? '33',
      'api_level': apiLevel ?? 33,
      'is_physical_device': isPhysicalDevice ?? true,
      'screen_height': screenHeight ?? 960.0,
      'screen_width': screenWidth ?? 480.0,
      'is_mobile': true,
      'is_desktop': false,
      'is_web': false,
      'has_touch_screen': true,
      'has_mouse': false,
      'has_keyboard': true,
      'has_secure_storage': true,
      'has_file_system': true,
      'supports_notifications': true,
      'supports_biometrics': true,
      'has_camera': true,
      'has_gps': true,
      'recommended_storage': 'FlutterSecureStorage',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create Web platform info
  static Map<String, dynamic> createWebInfo({
    String? browser,
    String? userAgent,
    bool? isMobile,
    bool? isDesktop,
    String? language,
    String? timezone,
  }) {
    return {
      'platform': CoreTestConstants.testPlatformNames[2], // Web
      'browser': browser ?? 'Chrome',
      'user_agent': userAgent ?? CoreTestConstants.testAppName,
      'is_mobile': isMobile ?? false,
      'is_desktop': isDesktop ?? false,
      'is_web': true,
      'has_touch_screen': false,
      'has_mouse': true,
      'has_keyboard': true,
      'has_secure_storage': false,
      'has_file_system': false,
      'supports_notifications': true,
      'supports_biometrics': false,
      'has_camera': true,
      'has_gps': false,
      'recommended_storage': 'WebStorage (localStorage/sessionStorage)',
      'language': language ?? 'en',
      'timezone': timezone ?? 'UTC',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create Windows platform info
  static Map<String, dynamic> createWindowsInfo({
    String? version,
    String? buildNumber,
    String? deviceName,
    bool? isPhysicalDevice,
    double? screenHeight,
    double? screenWidth,
  }) {
    return {
      'platform': CoreTestConstants.testPlatformNames[3], // Windows
      'version': version ?? '11.0.0',
      'build_number': buildNumber ?? '22000',
      'device_name': deviceName ?? 'DESKTOP-ABC123',
      'is_physical_device': isPhysicalDevice ?? true,
      'screen_height': screenHeight ?? 1080.0,
      'screen_width': screenWidth ?? 1920.0,
      'is_mobile': false,
      'is_desktop': true,
      'is_web': false,
      'has_touch_screen': false,
      'has_mouse': true,
      'has_keyboard': true,
      'has_secure_storage': false,
      'has_file_system': true,
      'supports_notifications': true,
      'supports_biometrics': false,
      'has_camera': true,
      'has_gps': false,
      'recommended_storage': 'SharedPreferences',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create macOS platform info
  static Map<String, dynamic> createMacOSInfo({
    String? version,
    String? deviceModel,
    String? systemVersion,
    bool? isPhysicalDevice,
    double? screenHeight,
    double? screenWidth,
  }) {
    return {
      'platform': CoreTestConstants.testPlatformNames[4], // macOS
      'version': version ?? '13.0.0',
      'device_model': deviceModel ?? 'MacBook Pro',
      'system_version': systemVersion ?? 'macOS 13.0.0',
      'is_physical_device': isPhysicalDevice ?? true,
      'screen_height': screenHeight ?? 900.0,
      'screen_width': screenWidth ?? 1440.0,
      'is_mobile': false,
      'is_desktop': true,
      'is_web': false,
      'has_touch_screen': false,
      'has_mouse': true,
      'has_keyboard': true,
      'has_secure_storage': true,
      'has_file_system': true,
      'supports_notifications': true,
      'supports_biometrics': true,
      'has_camera': true,
      'has_gps': false,
      'recommended_storage': 'FlutterSecureStorage',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create Linux platform info
  static Map<String, dynamic> createLinuxInfo({
    String? distribution,
    String? version,
    String? desktopEnvironment,
    bool? isPhysicalDevice,
    double? screenHeight,
    double? screenWidth,
  }) {
    return {
      'platform': CoreTestConstants.testPlatformNames[5], // Linux
      'distribution': distribution ?? 'Ubuntu',
      'version': version ?? '22.04.0',
      'desktop_environment': desktopEnvironment ?? 'GNOME',
      'is_physical_device': isPhysicalDevice ?? true,
      'screen_height': screenHeight ?? 1080.0,
      'screen_width': screenWidth ?? 1920.0,
      'is_mobile': false,
      'is_desktop': true,
      'is_web': false,
      'has_touch_screen': false,
      'has_mouse': true,
      'has_keyboard': true,
      'has_secure_storage': false,
      'has_file_system': true,
      'supports_notifications': true,
      'supports_biometrics': false,
      'has_camera': true,
      'has_gps': false,
      'recommended_storage': 'SharedPreferences',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test platform capabilities
  static Map<String, dynamic> createPlatformCapabilities({
    bool? hasTouchScreen,
    bool? hasMouse,
    bool? hasKeyboard,
    bool? hasSecureStorage,
    bool? hasFileSystem,
    bool? hasNetwork,
    bool? hasNotifications,
    bool? hasBiometrics,
    bool? hasCamera,
    bool? hasGPS,
  }) {
    return {
      'has_touch_screen': hasTouchScreen ?? true,
      'has_mouse': hasMouse ?? false,
      'has_keyboard': hasKeyboard ?? true,
      'has_secure_storage': hasSecureStorage ?? true,
      'has_file_system': hasFileSystem ?? true,
      'has_network': hasNetwork ?? true,
      'supports_notifications': hasNotifications ?? true,
      'supports_biometrics': hasBiometrics ?? false,
      'has_camera': hasCamera ?? true,
      'has_gps': hasGPS ?? false,
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test device info
  static Map<String, dynamic> createDeviceInfo({
    String? deviceId,
    String? deviceName,
    String? manufacturer,
    String? model,
    String? osVersion,
    Map<String, dynamic>? capabilities,
  }) {
    return {
      'device_id': deviceId ?? CoreTestConstants.testDeviceId,
      'device_name': deviceName ?? 'Test Device',
      'manufacturer': manufacturer ?? 'Test Manufacturer',
      'model': model ?? 'Test Model',
      'os_version': osVersion ?? '1.0.0',
      'capabilities': capabilities ?? createPlatformCapabilities(),
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test screen info
  static Map<String, dynamic> createScreenInfo({
    double? width,
    double? height,
    double? density,
    String? orientation,
    bool? isTablet,
  }) {
    return {
      'width': width ?? 390.0,
      'height': height ?? 844.0,
      'density': density ?? CoreTestConstants.testScreenDensity,
      'orientation': orientation ?? 'portrait',
      'is_tablet': isTablet ?? false,
      'aspect_ratio': (width ?? 390.0) / (height ?? 844.0),
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test network info
  static Map<String, dynamic> createNetworkInfo({
    String? connectionType,
    String? ipAddress,
    String? networkName,
    bool? isConnected,
    int? signalStrength,
  }) {
    return {
      'connection_type': connectionType ?? 'wifi',
      'ip_address': ipAddress ?? '192.168.1.100',
      'network_name': networkName ?? 'Home WiFi',
      'is_connected': isConnected ?? true,
      'signal_strength': signalStrength ?? 4, // 0-4 scale
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test battery info
  static Map<String, dynamic> createBatteryInfo({
    int? level,
    bool? isCharging,
    bool? isPowerSaveMode,
    String? technology,
  }) {
    return {
      'level': level ?? 85,
      'is_charging': isCharging ?? false,
      'is_power_save_mode': isPowerSaveMode ?? false,
      'technology': technology ?? 'Li-ion',
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test memory info
  static Map<String, dynamic> createMemoryInfo({
    int? totalMemory,
    int? availableMemory,
    int? usedMemory,
    String? unit,
  }) {
    return {
      'total_memory': totalMemory ?? CoreTestConstants.testMemorySize,
      'available_memory': availableMemory ?? (CoreTestConstants.testMemorySize ~/ 2),
      'used_memory': usedMemory ?? (CoreTestConstants.testMemorySize ~/ 2),
      'unit': unit ?? 'bytes',
      'usage_percentage': ((usedMemory ?? (CoreTestConstants.testMemorySize ~/ 2)) / (totalMemory ?? CoreTestConstants.testMemorySize)) * 100,
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }

  /// Create test storage info
  static Map<String, dynamic> createStorageInfo({
    int? totalSpace,
    int? availableSpace,
    int? usedSpace,
    String? unit,
  }) {
    return {
      'total_space': totalSpace ?? (CoreTestConstants.testMemorySize * 10),
      'available_space': availableSpace ?? (CoreTestConstants.testMemorySize * 5),
      'used_space': usedSpace ?? (CoreTestConstants.testMemorySize * 5),
      'unit': unit ?? 'bytes',
      'usage_percentage': ((usedSpace ?? (CoreTestConstants.testMemorySize * 5)) / (totalSpace ?? (CoreTestConstants.testMemorySize * 10))) * 100,
      'timestamp': CoreTestConstants.testTimestamp.toIso8601String(),
    };
  }
}