import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

/// Service untuk mendapatkan informasi device dan generate fingerprint
///
/// Service ini menyediakan fungsi untuk:
/// - Mendapatkan informasi device (ID, name, type, platform, app version)
/// - Generate device fingerprint untuk validasi
/// - Support untuk Android, iOS, Web, Desktop (Windows, macOS, Linux)
class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static const String _webDeviceIdKey = 'web_device_id';

  /// Mendapatkan informasi device lengkap
  ///
  /// Returns [Map<String, dynamic>] dengan informasi:
  /// - deviceId: Unique identifier device
  /// - deviceName: Nama device (manufacturer + model)
  /// - deviceType: Tipe device (MOBILE, WEB, DESKTOP)
  /// - platform: Platform dan versi (Android/iOS/Web Browser/Windows/macOS/Linux)
  /// - appVersion: Versi aplikasi
  ///
  /// Throws [Exception] jika terjadi error saat mengambil informasi
  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      final deviceInfo = await _getDeviceInfo();
      final appVersion = await _getAppVersion();

      // Tentukan device type berdasarkan platform
      String deviceType = 'MOBILE';
      if (kIsWeb) {
        deviceType = 'WEB';
      } else if (!kIsWeb) {
        // Only check Platform on non-web platforms
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          deviceType = 'DESKTOP';
        }
      }

      return {
        'deviceId': deviceInfo['id'],
        'deviceName': deviceInfo['name'],
        'deviceType': deviceType,
        'platform': deviceInfo['platform'],
        'appVersion': appVersion,
      };
    } catch (e) {
      throw Exception('Failed to get device info: $e');
    }
  }

  /// Generate device fingerprint dari informasi device
  ///
  /// Menggunakan SHA256 hash dari deviceId, platform, dan additional info
  /// untuk match dengan server-side generation
  ///
  /// [deviceInfo] Map yang berisi informasi device
  /// Returns [String] fingerprint dalam bentuk hash
  String generateDeviceFingerprint(Map<String, dynamic> deviceInfo) {
    try {
      final deviceId = deviceInfo['deviceId'];
      final platform = deviceInfo['platform'];

      if (deviceId == null || platform == null) {
        throw Exception('Device ID and Platform cannot be null');
      }

      // Match server implementation exactly: "${deviceId}_${platform}" -> SHA256
      // Server uses: const data = `${deviceInfo.deviceId}_${deviceInfo.platform || 'unknown'}`;
      final fingerprintData = '${deviceId}_${platform}';
      final bytes = utf8.encode(fingerprintData);
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e) {
      throw Exception('Failed to generate device fingerprint: $e');
    }
  }

  /// Generate device ID yang konsisten dengan server
  ///
  /// Menggunakan format yang sama dengan server untuk memastikan compatibility
  /// Returns [String] device ID dalam format yang diharapkan server
  String generateConsistentDeviceId(Map<String, dynamic> deviceInfo) {
    try {
      final deviceId = deviceInfo['deviceId'];
      final platform = deviceInfo['platform'];

      if (deviceId == null || platform == null) {
        throw Exception('Device ID and Platform cannot be null');
      }

      // Generate consistent device ID (32 characters like server)
      final deviceData = '${deviceId}_$platform';
      final bytes = utf8.encode(deviceData);
      final digest = sha256.convert(bytes);
      return digest.toString().substring(0, 32);
    } catch (e) {
      throw Exception('Failed to generate consistent device ID: $e');
    }
  }

  /// Mendapatkan informasi device spesifik platform
  ///
  /// Returns [Map<String, String>] dengan informasi device
  /// - id: Unique identifier device
  /// - name: Nama device
  /// - platform: Platform dan versi
  ///
  /// Throws [Exception] jika terjadi error
  Future<Map<String, String>> _getDeviceInfo() async {
    try {
      // Check for web first, before any Platform checks
      if (kIsWeb) {
        return await _getWebDeviceInfo();
      }

      // For non-web platforms, use Platform checks
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return {
          'id': androidInfo.id,
          'name': '${androidInfo.manufacturer} ${androidInfo.model}',
          'platform': 'Android ${androidInfo.version.release}',
        };
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return {
          'id': iosInfo.identifierForVendor ?? _generateUUID(),
          'name': '${iosInfo.name} (${iosInfo.model})',
          'platform': 'iOS ${iosInfo.systemVersion}',
        };
      } else if (Platform.isWindows) {
        final windowsInfo = await _deviceInfoPlugin.windowsInfo;
        return {
          'id': windowsInfo.deviceId ?? _generateUUID(),
          'name': '${windowsInfo.computerName} (${windowsInfo.productName})',
          'platform':
              'Windows ${windowsInfo.majorVersion}.${windowsInfo.minorVersion}',
        };
      } else if (Platform.isLinux) {
        final linuxInfo = await _deviceInfoPlugin.linuxInfo;
        return {
          'id': linuxInfo.machineId ?? _generateUUID(),
          'name': '${linuxInfo.prettyName}',
          'platform': 'Linux ${linuxInfo.version}',
        };
      } else if (Platform.isMacOS) {
        final macOsInfo = await _deviceInfoPlugin.macOsInfo;
        return {
          'id': macOsInfo.systemGUID ?? _generateUUID(),
          'name': '${macOsInfo.computerName} (${macOsInfo.model})',
          'platform':
              'macOS ${macOsInfo.majorVersion}.${macOsInfo.minorVersion}',
        };
      } else {
        // Fallback
        throw UnsupportedError('Unsupported platform');
      }
    } catch (e) {
      throw Exception('Failed to get platform device info: $e');
    }
  }

  /// Mendapatkan informasi device untuk web
  ///
  /// Returns [Map<String, String>] dengan informasi device web
  /// Menggunakan webBrowserInfo dari device_info_plus dan persistent device ID
  Future<Map<String, String>> _getWebDeviceInfo() async {
    try {
      final webInfo = await _deviceInfoPlugin.webBrowserInfo;

      // Get or create persistent device ID for web
      final deviceId = await _getOrCreateWebDeviceId();

      // Extract browser information
      final browserName = webInfo.browserName.name;
      final userAgent = webInfo.userAgent ?? 'Unknown';

      // Determine platform from user agent
      String platform = 'Web';
      if (userAgent.toLowerCase().contains('chrome')) {
        platform = 'Chrome';
      } else if (userAgent.toLowerCase().contains('firefox')) {
        platform = 'Firefox';
      } else if (userAgent.toLowerCase().contains('safari')) {
        platform = 'Safari';
      } else if (userAgent.toLowerCase().contains('edge')) {
        platform = 'Edge';
      }

      return {
        'id': deviceId,
        'name': '$platform Browser',
        'platform': 'Web $browserName',
      };
    } catch (e) {
      throw Exception('Failed to get web device info: $e');
    }
  }

  /// Get or create persistent device ID for web platform
  /// Menggunakan SharedPreferences untuk menyimpan device ID yang persistent
  Future<String> _getOrCreateWebDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Try to get existing device ID
      String? deviceId = prefs.getString(_webDeviceIdKey);

      // If no device ID exists, create new one
      if (deviceId == null || deviceId.isEmpty) {
        deviceId = _generateUUID();
        await prefs.setString(_webDeviceIdKey, deviceId);
      }

      return deviceId;
    } catch (e) {
      // Fallback to non-persistent UUID if localStorage fails
      return _generateUUID();
    }
  }

  /// Mendapatkan versi aplikasi
  ///
  /// Returns [String] versi aplikasi
  ///
  /// Throws [Exception] jika gagal mendapatkan package info
  Future<String> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      throw Exception('Failed to get app version: $e');
    }
  }

  /// Generate UUID sederhana sebagai fallback
  ///
  /// Menggunakan timestamp sebagai basis untuk generate UUID
  /// Returns [String] UUID yang dihasilkan
  String _generateUUID() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
