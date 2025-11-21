import 'package:flutter_test/flutter_test.dart';
import '../../../../lib/core/services/device_info_service.dart';

void main() {
  // Initialize Flutter binding for tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeviceInfoService', () {
    late DeviceInfoService deviceInfoService;

    setUp(() {
      deviceInfoService = DeviceInfoService();
    });

    group('generateDeviceFingerprint', () {
      test('should generate consistent fingerprint for same device info', () {
        // Arrange
        final deviceInfo = {
          'deviceId': 'test-device-id',
          'platform': 'Android 13',
        };

        // Act
        final fingerprint1 =
            deviceInfoService.generateDeviceFingerprint(deviceInfo);
        final fingerprint2 =
            deviceInfoService.generateDeviceFingerprint(deviceInfo);

        // Assert
        expect(fingerprint1, equals(fingerprint2));
        expect(fingerprint1.length, equals(64)); // SHA256 hash length
      });

      test('should generate different fingerprint for different device info',
          () {
        // Arrange
        final deviceInfo1 = {
          'deviceId': 'test-device-id-1',
          'platform': 'Android 13',
        };
        final deviceInfo2 = {
          'deviceId': 'test-device-id-2',
          'platform': 'Android 13',
        };

        // Act
        final fingerprint1 =
            deviceInfoService.generateDeviceFingerprint(deviceInfo1);
        final fingerprint2 =
            deviceInfoService.generateDeviceFingerprint(deviceInfo2);

        // Assert
        expect(fingerprint1, isNot(equals(fingerprint2)));
      });

      test('should throw exception when deviceId is null', () {
        // Arrange
        final deviceInfo = {
          'deviceId': null,
          'platform': 'Android 13',
        };

        // Act & Assert
        expect(
          () => deviceInfoService.generateDeviceFingerprint(deviceInfo),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception when platform is null', () {
        // Arrange
        final deviceInfo = {
          'deviceId': 'test-device-id',
          'platform': null,
        };

        // Act & Assert
        expect(
          () => deviceInfoService.generateDeviceFingerprint(deviceInfo),
          throwsA(isA<Exception>()),
        );
      });

      test('should generate different fingerprints for different platforms',
          () {
        // Arrange
        final deviceInfo1 = {
          'deviceId': 'same-device-id',
          'platform': 'Android 13',
        };
        final deviceInfo2 = {
          'deviceId': 'same-device-id',
          'platform': 'iOS 16',
        };

        // Act
        final fingerprint1 =
            deviceInfoService.generateDeviceFingerprint(deviceInfo1);
        final fingerprint2 =
            deviceInfoService.generateDeviceFingerprint(deviceInfo2);

        // Assert
        expect(fingerprint1, isNot(equals(fingerprint2)));
      });
    });
  });
}
