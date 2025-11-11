import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../constants/app_constants.dart';
import '../extensions/string_extension.dart';

/// Utility functions for the application
class AppUtils {
  /// Get formatted date string
  static String formatDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;

    return format
        .replaceAll('dd', day)
        .replaceAll('MMM', month)
        .replaceAll('yyyy', year.toString());
  }

  /// Get relative time string (e.g., "2 hours ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Generate random string
  static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    final randomGenerator = random;

    String result = '';
    for (int i = 0; i < length; i++) {
      final index = (randomGenerator + i) % chars.length;
      result += chars[index];
    }

    return result;
  }

  /// Validate Indonesian ID card format
  static bool isValidIndonesianId(String id) {
    if (id.length != 16 || !id.isNumeric) {
      return false;
    }

    // Check province code (01-94)
    final provinceCode = int.tryParse(id.substring(0, 2));
    if (provinceCode == null || provinceCode < 1 || provinceCode > 94) {
      return false;
    }

    // Simple checksum validation
    int sum = 0;
    for (int i = 0; i < 16; i++) {
      sum += int.parse(id[i]) * (16 - i);
    }

    return sum % 10 == 0;
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Get device info
  static Future<Map<String, String>> getDeviceInfo() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'app_version': AppConstants.appVersion,
      'first_install': prefs.getString('first_install') ?? 'Unknown',
      'last_open': DateTime.now().toIso8601String(),
    };
  }

  /// Check if app is first launch
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('is_first_launch', false);
      await prefs.setString('first_install', DateTime.now().toIso8601String());
    }

    return isFirstLaunch;
  }

  /// Get safe text from dynamic
  static String safeText(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    if (value is num) return value.toString();
    if (value is bool) return value.toString();
    return defaultValue;
  }

  /// Get safe number from dynamic
  static double safeNumber(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  /// Get safe boolean from dynamic
  static bool safeBool(dynamic value, {bool defaultValue = false}) {
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is String) {
      final lowerValue = value.toLowerCase();
      return lowerValue == 'true' || lowerValue == '1' || lowerValue == 'yes';
    }
    if (value is num) return value != 0;
    return defaultValue;
  }

  /// Debounce function
  static Function debounce(Function() func, Duration delay) {
    Timer? timer;

    return () {
      if (timer != null) {
        timer!.cancel();
      }

      timer = Timer(delay, func);
    };
  }

  /// Throttle function
  static Function throttle(Function() func, Duration interval) {
    bool isThrottled = false;

    return () {
      if (isThrottled) return;

      isThrottled = true;
      func();

      Timer(interval, () {
        isThrottled = false;
      });
    };
  }

  /// Copy text to clipboard
  static Future<void> copyToClipboard(String text) async {
    // This would need flutter/services package
    // await Clipboard.setData(ClipboardData(text: text));
  }

  /// Check if color is light
  static bool isLightColor(Color color) {
    // Calculate luminance
    final luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.5;
  }

  /// Get contrasting text color
  static Color getContrastingTextColor(Color backgroundColor) {
    return isLightColor(backgroundColor) ? Colors.black : Colors.white;
  }

  /// Generate color from string
  static Color colorFromString(String str) {
    if (str.isEmpty) return Colors.grey;

    int hash = 0;
    for (int i = 0; i < str.length; i++) {
      hash = str.codeUnitAt(i) + ((hash << 5) - hash);
    }

    final hue = hash.abs() % 360;
    return HSLColor.fromAHSL(1.0, 0.7, 0.6, 1.0).toColor();
  }

  /// Validate Indonesian postal code
  static bool isValidIndonesianPostalCode(String postalCode) {
    if (postalCode.length != 5 || !postalCode.isNumeric) {
      return false;
    }

    final code = int.tryParse(postalCode);
    return code != null && code >= 10000 && code <= 99999;
  }

  /// Get Indonesian province name from code
  static String getProvinceName(String code) {
    final provinces = {
      '11': 'Aceh',
      '12': 'Sumatera Utara',
      '13': 'Sumatera Barat',
      '14': 'Riau',
      '15': 'Kepulauan Riau',
      '16': 'Jambi',
      '17': 'Sumatera Selatan',
      '18': 'Bengkulu',
      '19': 'Lampung',
      '21': 'Kepulauan Bangka Belitung',
      '31': 'DKI Jakarta',
      '32': 'Jawa Barat',
      '33': 'Jawa Tengah',
      '34': 'DI Yogyakarta',
      '35': 'Jawa Timur',
      '36': 'Banten',
      '51': 'Bali',
      '52': 'Nusa Tenggara Barat',
      '53': 'Nusa Tenggara Timur',
      '61': 'Kalimantan Barat',
      '62': 'Kalimantan Tengah',
      '63': 'Kalimantan Selatan',
      '64': 'Kalimantan Timur',
      '65': 'Kalimantan Utara',
      '71': 'Sulawesi Utara',
      '72': 'Sulawesi Tengah',
      '73': 'Sulawesi Selatan',
      '74': 'Sulawesi Tenggara',
      '75': 'Gorontalo',
      '76': 'Sulawesi Barat',
      '81': 'Maluku',
      '82': 'Maluku Utara',
      '91': 'Papua Barat',
      '94': 'Papua',
    };

    return provinces[code] ?? 'Unknown Province';
  }
}