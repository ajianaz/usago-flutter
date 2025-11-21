# DeviceInfoService

## Overview

`DeviceInfoService` adalah service yang bertanggung jawab untuk mendapatkan informasi device dan generate fingerprint untuk validasi. Service ini mendukung multiple platform termasuk Android, iOS, Windows, Linux, macOS, dan Web.

## Features

- Mendapatkan informasi device lengkap (ID, name, type, platform, app version)
- Generate device fingerprint menggunakan SHA256 hash
- Support untuk Android, iOS, Windows, Linux, macOS, dan Web
- Error handling yang komprehensif
- Documentation yang jelas

## Dependencies

- `device_info_plus: ^9.1.0` - Untuk mendapatkan informasi device
- `package_info_plus: ^5.0.0` - Untuk mendapatkan informasi aplikasi
- `crypto: ^3.0.3` - Untuk generate SHA256 hash

## Usage

### Basic Usage

```dart
import 'package:usago/lib/core/services/device_info_service.dart';

final deviceInfoService = DeviceInfoService();

// Mendapatkan informasi device
final deviceInfo = await deviceInfoService.getDeviceInfo();
print('Device ID: ${deviceInfo['deviceId']}');
print('Device Name: ${deviceInfo['deviceName']}');
print('Device Type: ${deviceInfo['deviceType']}');
print('Platform: ${deviceInfo['platform']}');
print('App Version: ${deviceInfo['appVersion']}');

// Generate device fingerprint
final fingerprint = deviceInfoService.generateDeviceFingerprint(deviceInfo);
print('Device Fingerprint: $fingerprint');
```

### Error Handling

```dart
try {
  final deviceInfo = await deviceInfoService.getDeviceInfo();
  final fingerprint = deviceInfoService.generateDeviceFingerprint(deviceInfo);
} on Exception catch (e) {
  // Handle error
  print('Error: $e');
}
```

## Methods

### `getDeviceInfo()`

Mendapatkan informasi device lengkap.

**Returns:** `Future<Map<String, dynamic>>`

**Throws:** `Exception` jika gagal mendapatkan informasi device

**Response Format:**
```json
{
  "deviceId": "unique_device_id",
  "deviceName": "Device Name (Model)",
  "deviceType": "MOBILE | DESKTOP | WEB",
  "platform": "Platform Version",
  "appVersion": "1.0.0"
}
```

### `generateDeviceFingerprint(Map<String, dynamic> deviceInfo)`

Generate device fingerprint dari informasi device.

**Parameters:**
- `deviceInfo`: Map yang berisi informasi device

**Returns:** `String` - SHA256 hash dari deviceId dan platform

**Throws:** `Exception` jika deviceId atau platform null

## Platform Support

### Android
- Device ID: Android ID
- Device Name: Manufacturer + Model
- Platform: Android Version

### iOS
- Device ID: identifierForVendor atau generated UUID
- Device Name: Device Name (Model)
- Platform: iOS Version

### Windows
- Device ID: Device ID atau generated UUID
- Device Name: Computer Name (Product Name)
- Platform: Windows Version

### Linux
- Device ID: Machine ID atau generated UUID
- Device Name: Pretty Name
- Platform: Linux Version

### macOS
- Device ID: System GUID atau generated UUID
- Device Name: Computer Name (Model)
- Platform: macOS Version

### Web
- Device ID: Generated UUID
- Device Name: Web Browser
- Platform: Browser Type

## Testing

Service ini dilengkapi dengan unit test yang komprehensif:

```bash
flutter test test/unit/core/services/device_info_service_test.dart
```

Test mencakup:
- Generate fingerprint consistency
- Different fingerprint untuk device berbeda
- Error handling untuk null values
- Platform detection

## Security Considerations

- Device fingerprint menggunakan SHA256 hash yang aman
- Tidak menyimpan informasi sensitif
- Generated UUID menggunakan timestamp untuk keunikan
- Error handling tidak mengexpose informasi sensitif

## Future Enhancements

- Support untuk platform tambahan
- Enhanced web user agent detection
- Device capability detection
- Custom fingerprint algorithms