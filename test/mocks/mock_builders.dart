// Mock Builders for Integration Testing
// Purpose: Utility classes for building complex test data structures
// Follows Flutter development guidelines for test organization

/// Test Data Builder
///
/// Utility class for building complex test data structures
/// with fluent interface for better readability.
class TestDataBuilder {
  Map<String, dynamic> _data = {};

  /// Add string value
  TestDataBuilder addString(String key, String value) {
    _data[key] = value;
    return this;
  }

  /// Add integer value
  TestDataBuilder addInt(String key, int value) {
    _data[key] = value;
    return this;
  }

  /// Add boolean value
  TestDataBuilder addBool(String key, bool value) {
    _data[key] = value;
    return this;
  }

  /// Add list value
  TestDataBuilder addList<T>(String key, List<T> value) {
    _data[key] = value;
    return this;
  }

  /// Add map value
  TestDataBuilder addMap(String key, Map<String, dynamic> value) {
    _data[key] = value;
    return this;
  }

  /// Add nested object
  TestDataBuilder addObject(String key, dynamic value) {
    _data[key] = value;
    return this;
  }

  /// Build the final data structure
  Map<String, dynamic> build() {
    return Map<String, dynamic>.from(_data);
  }

  /// Reset builder
  TestDataBuilder reset() {
    _data.clear();
    return this;
  }
}

/// Mock Response Builder
///
/// Utility class for building HTTP response mock data
/// with fluent interface for better readability.
class MockResponseBuilder {
  int _statusCode = 200;
  Map<String, dynamic> _body = {};
  Map<String, String> _headers = {};

  /// Set status code
  MockResponseBuilder withStatusCode(int code) {
    _statusCode = code;
    return this;
  }

  /// Set body
  MockResponseBuilder withBody(Map<String, dynamic> body) {
    _body = Map<String, dynamic>.from(body);
    return this;
  }

  /// Add body field
  MockResponseBuilder addBodyField(String key, dynamic value) {
    _body[key] = value;
    return this;
  }

  /// Set headers
  MockResponseBuilder withHeaders(Map<String, String> headers) {
    _headers = Map<String, String>.from(headers);
    return this;
  }

  /// Add header
  MockResponseBuilder addHeader(String key, String value) {
    _headers[key] = value;
    return this;
  }

  /// Build the final response
  Map<String, dynamic> build() {
    return {
      'statusCode': _statusCode,
      'body': _body,
      'headers': _headers,
    };
  }

  /// Reset builder
  MockResponseBuilder reset() {
    _statusCode = 200;
    _body.clear();
    _headers.clear();
    return this;
  }
}