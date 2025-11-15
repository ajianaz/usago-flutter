import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// Utility class untuk enkripsi dan dekripsi data sensitif
class EncryptionUtil {
  // Prefix untuk mengidentifikasi data yang terenkripsi
  static const String _encryptedPrefix = 'ENC:';

  // Default encryption key - dalam production seharusnya dari secure source
  static const String _defaultKey = 'usago-default-encryption-key-32';

  /// Check apakah string terenkripsi
  static bool isEncrypted(String value) {
    return value.startsWith(_encryptedPrefix);
  }

  /// Encrypt string value
  static Future<String> encrypt(String value, {String? key}) async {
    try {
      final encryptionKey = key ?? _defaultKey;
      final keyBytes = _utf8ToBytes(encryptionKey);
      final data = utf8.encode(value);

      // Simple XOR encryption untuk implementasi minimal
      final encrypted = _xorEncrypt(data, keyBytes);
      final encryptedBase64 = base64.encode(encrypted);

      return '$_encryptedPrefix$encryptedBase64';
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  /// Decrypt string value
  static Future<String> decrypt(String encryptedValue, {String? key}) async {
    try {
      if (!isEncrypted(encryptedValue)) {
        return encryptedValue; // Return as-is if not encrypted
      }

      final encryptionKey = key ?? _defaultKey;
      final keyBytes = _utf8ToBytes(encryptionKey);

      // Remove prefix and decode base64
      final base64String = encryptedValue.substring(_encryptedPrefix.length);
      final encryptedBytes = base64.decode(base64String);

      // Decrypt using XOR
      final decrypted = _xorEncrypt(encryptedBytes, keyBytes);

      return utf8.decode(decrypted);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }

  /// Convert UTF-8 string to bytes
  static Uint8List _utf8ToBytes(String str) {
    return Uint8List.fromList(utf8.encode(str));
  }

  /// XOR encryption/decryption
  static Uint8List _xorEncrypt(Uint8List data, Uint8List key) {
    final result = Uint8List(data.length);
    for (int i = 0; i < data.length; i++) {
      result[i] = data[i] ^ key[i % key.length];
    }
    return result;
  }

  /// Generate hash dari string
  static String generateHash(String value) {
    final bytes = utf8.encode(value);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}