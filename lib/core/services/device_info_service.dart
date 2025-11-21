import 'dart:convert';
import 'dart:io' show Platform;
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Service untuk mendapatkan informasi device dan generate fingerprint
///
/// Service ini menyediakan fungsi untuk:
/// - Mendapatkan informasi device (ID, name, type, platform, app version)
/// - Generate device fingerprint untuk validasi
/// - Support untuk Android dan iOS
class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// Mendapatkan informasi device lengkap
  ///
  /// Returns [Map<String, dynamic>] dengan informasi:
  /// - deviceId: Unique identifier device
  /// - deviceName: Nama device (manufacturer + model)
  /// - deviceType: Tipe device (MOBILE)
  /// - platform: Platform dan versi (Android/iOS)
  /// - appVersion: Versi aplikasi
  ///
  /// Throws [UnsupportedError] jika platform tidak didukung
  /// Throws [Exception] jika terjadi error saat mengambil informasi
  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      final deviceInfo = await _getDeviceInfo();
      final appVersion = await _getAppVersion();

      // Tentukan device type berdasarkan platform
      String deviceType = 'MOBILE';
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        deviceType = 'DESKTOP';
      } else if (deviceInfo['platform']?.contains('Web') == true) {
        deviceType = 'WEB';
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
  /// Menggunakan SHA256 hash dari deviceId dan platform
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

      final data = '${deviceId}_$platform';
      final bytes = utf8.encode(data);
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e) {
      throw Exception('Failed to generate device fingerprint: $e');
    }
  }

  /// Mendapatkan informasi device spesifik platform
  ///
  /// Returns [Map<String, String>] dengan informasi device
  /// - id: Unique identifier device
  /// - name: Nama device
  /// - platform: Platform dan versi
  ///
  /// Throws [UnsupportedError] jika platform tidak didukung
  Future<Map<String, String>> _getDeviceInfo() async {
    try {
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
        // Fallback untuk web atau platform lainnya
        return _getWebDeviceInfo();
      }
    } catch (e) {
      throw Exception('Failed to get platform device info: $e');
    }
  }

  /// Mendapatkan informasi device untuk web
  ///
  /// Returns [Map<String, String>] dengan informasi device web
  Map<String, String> _getWebDeviceInfo() {
    try {
      // Untuk web, kita menggunakan user agent dan generate ID
      final userAgent = _getUserAgent();
      final platform = _getWebPlatform(userAgent);

      return {
        'id': _generateUUID(),
        'name': 'Web Browser',
        'platform': platform,
      };
    } catch (e) {
      throw Exception('Failed to get web device info: $e');
    }
  }

  /// Mendapatkan user agent untuk web
  String _getUserAgent() {
    // Untuk sekarang, kita gunakan fallback sederhana
    // Di implementasi production, bisa ditambahkan web-specific logic
    return 'Web Browser';
  }

  /// Mendapatkan platform dari user agent
  String _getWebPlatform(String userAgent) {
    if (userAgent.contains('Chrome')) {
      return 'Web Chrome';
    } else if (userAgent.contains('Firefox')) {
      return 'Web Firefox';
    } else if (userAgent.contains('Safari')) {
      return 'Web Safari';
    } else if (userAgent.contains('Edge')) {
      return 'Web Edge';
    } else {
      return 'Web Browser';
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
