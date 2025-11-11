// Simple logger for Better Auth connection tests
// Replaces print statements with proper logging
// ignore_for_file: avoid_print
class AuthTestLogger {
  /// Logs informational messages with info icon
  static void info(String message) {
    print('ℹ️ $message');
  }

  /// Logs success messages with checkmark icon
  static void success(String message) {
    print('✅ $message');
  }

  /// Logs warning messages with warning icon
  static void warning(String message) {
    print('⚠️ $message');
  }

  /// Logs error messages with X icon
  static void error(String message) {
    print('❌ $message');
  }

  /// Logs test suite header with test tube icon and separator
  static void header(String title) {
    print('\n🧪 $title');
    print('==========================================');
  }

  /// Logs individual test header with satellite icon and separator
  static void testHeader(String title) {
    print('\n📡 $title');
    print('----------------------------------------');
  }

  /// Analyzes and logs response data structure
  static void responseAnalysis(Map<String, dynamic> data) {
    print('📊 Response Analysis:');
    print('   - Has user data: ${data.containsKey('user')}');
    print('   - Has session data: ${data.containsKey('session')}');
    print('   - Response structure: ${data.keys.toList()}');
  }

  /// Analyzes and logs error response structure
  static void errorAnalysis(Map<String, dynamic> data) {
    print('🚨 Error Analysis:');
    print('   - Error code: ${data['code']}');
    print('   - Error message: ${data['message']}');
    print('   - Error type: ${data['type']}');
  }

  /// Logs summary of completed tests with bullet points
  static void summary(List<String> items) {
    print('\n✅ All connection tests completed!');
    print('📋 Summary:');
    for (final item in items) {
      print('   - $item');
    }
  }
}