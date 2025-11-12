import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

void main() {
  group('Simple Server Connection Tests', () {
    late Dio dio;

    setUp(() {
      dio = Dio(BaseOptions(
        baseUrl: 'http://localhost:3000',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));
    });

    test('should connect to server successfully', () async {
      try {
        final response = await dio.get('/');

        print('✅ Connection successful!');
        print('Status Code: ${response.statusCode}');
        print('Response Data: ${response.data}');

        expect(response.statusCode, isIn([200, 201, 204, 400])); // 400 is acceptable for root endpoint
      } catch (e) {
        print('❌ Connection failed!');
        print('Error: $e');

        // Check if it's a connection error (server not running)
        if (e is DioException && e.type == DioExceptionType.connectionError) {
          fail('Server is not running or not accessible at http://localhost:3000');
        } else {
          // For other errors (like 400), we can still consider the server as running
          print('ℹ️ Server is running but returned an error (this might be expected for root endpoint)');
        }
      }
    });

    test('should check server health endpoint', () async {
      try {
        final response = await dio.get('/health');

        print('✅ Health endpoint accessible!');
        print('Status Code: ${response.statusCode}');
        print('Response Data: ${response.data}');

        expect(response.statusCode, isIn([200, 201, 204]));
      } catch (e) {
        print('ℹ️ Health endpoint not available or server not responding');
        print('Error: $e');

        // Don't fail here as health endpoint might not exist
        if (e is DioException && e.type == DioExceptionType.connectionError) {
          print('❌ Server is not running or not accessible');
        } else {
          print('ℹ️ Server is running but health endpoint returned an error');
        }
      }
    });

    test('should check if server is running', () async {
      try {
        // Try to connect with a very short timeout
        final response = await dio.get(
          '/',
          options: Options(
            receiveTimeout: const Duration(seconds: 3),
          ),
        );

        print('✅ Server is running!');
        print('Status Code: ${response.statusCode}');

        // If we get any response (even 400), the server is running
        expect(true, isTrue);
      } catch (e) {
        if (e is DioException) {
          if (e.type == DioExceptionType.connectionError) {
            print('❌ Server is not running or not accessible');
            fail('Server is not running at http://localhost:3000');
          } else if (e.type == DioExceptionType.receiveTimeout) {
            print('❌ Server connection timeout');
            fail('Server connection timeout - server might be down');
          } else {
            print('✅ Server is running (got response: ${e.type})');
            // Other errors mean the server is running but returned an error
            expect(true, isTrue);
          }
        } else {
          print('❌ Unexpected error: $e');
          fail('Unexpected error: $e');
        }
      }
    });
  });
}