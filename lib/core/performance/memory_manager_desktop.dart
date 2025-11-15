import 'dart:io';

/// Desktop-specific memory utilities
class MemoryManagerDesktop {
  /// Get total system memory in MB for Linux/macOS
  static double getSystemMemoryLinuxMac() {
    try {
      final result = Process.runSync('sysctl', ['-n', 'hw.memsize']);
      if (result.exitCode == 0) {
        final bytes = int.parse(result.stdout.toString().trim());
        return bytes / (1024 * 1024);
      }
    } catch (e) {
      // Fallback
    }
    return 4096.0; // Default fallback
  }

  /// Get total system memory in MB for Windows
  static double getSystemMemoryWindows() {
    try {
      final result = Process.runSync(
          'wmic', ['computersystem', 'get', 'TotalPhysicalMemory']);
      if (result.exitCode == 0) {
        final lines = result.stdout.toString().split('\n');
        for (final line in lines) {
          if (line.trim().isNotEmpty &&
              !line.contains('TotalPhysicalMemory')) {
            final bytes = int.parse(line.trim());
            return bytes / (1024 * 1024);
          }
        }
      }
    } catch (e) {
      // Fallback
    }
    return 8192.0; // Default fallback
  }
}