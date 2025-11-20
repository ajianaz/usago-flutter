import 'dart:convert';

/// Utility class for sanitizing sensitive data in logs
class LogSanitizer {
  static const String _redactedPlaceholder = '[REDACTED]';
  static const String _filteredPlaceholder = '[FILTERED]';

  /// List of sensitive field patterns to detect and sanitize
  static const List<String> _sensitiveFields = [
    // Password fields
    'password',
    'pwd',
    'pass',
    'passwd',
    'user_password',
    'admin_password',

    // Token fields
    'token',
    'bearer',
    'authorization',
    'access_token',
    'refresh_token',
    'id_token',
    'jwt',
    'session_token',
    'csrf_token',
    'auth_token',

    // API keys
    'api_key',
    'apikey',
    'api_secret',
    'app_key',
    'app_secret',
    'client_id',
    'client_secret',
    'private_key',
    'public_key',

    // Secret fields
    'secret',
    'secret_key',
    'shared_secret',
    'webhook_secret',
    'signing_secret',

    // Credit card fields
    'credit_card',
    'card_number',
    'cardnumber',
    'cc_number',
    'cvv',
    'cvc',
    'expiry',
    'expiration',
    'card_holder',

    // Personal information (optional - can be enabled/disabled based on policy)
    'email',
    'phone',
    'phone_number',
    'ssn',
    'social_security',
    'national_id',
    'passport',
  ];

  /// List of patterns for detecting sensitive values
  static List<RegExp> get _sensitivePatterns => [
    // Credit card numbers (basic pattern)
    RegExp(r'\b\d{4}[-\s]?\d{4}[-\s]?\d{4}[-\s]?\d{4}\b'),

    // API keys (common patterns)
    RegExp(r'[A-Za-z0-9]{32,}', caseSensitive: false), // Long alphanumeric strings

    // JWT tokens
    RegExp(r'eyJ[A-Za-z0-9_-]*\.eyJ[A-Za-z0-9_-]*\.[A-Za-z0-9_-]*'),

    // Bearer tokens
    RegExp(r'Bearer\s+[A-Za-z0-9\-._~+\/]+=*', caseSensitive: false),

    // Basic auth
    RegExp(r'Basic\s+[A-Za-z0-9+/]+=*', caseSensitive: false),

    // Token patterns (more flexible)
    RegExp(r'\b\w*token\w*\b', caseSensitive: false),
    RegExp(r'\b\w*secret\w*\b', caseSensitive: false),
    RegExp(r'\b\w*key\w*\b', caseSensitive: false),

    // Email addresses (optional)
    RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'),

    // Phone numbers (basic pattern)
    RegExp(r'\b\d{3}[-.\s]?\d{3}[-.\s]?\d{4}\b'),
  ];

  /// Sanitize a map of data by removing sensitive information
  static Map<String, dynamic> sanitizeMap(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) {
      return {};
    }

    final sanitizedMap = <String, dynamic>{};

    for (final entry in data.entries) {
      final key = entry.key.toLowerCase();
      final value = entry.value;

      if (_isSensitiveField(key)) {
        sanitizedMap[entry.key] = _redactedPlaceholder;
      } else if (value is String) {
        sanitizedMap[entry.key] = _sanitizeStringValue(value);
      } else if (value is Map) {
        sanitizedMap[entry.key] = sanitizeMap(Map<String, dynamic>.from(value));
      } else if (value is List) {
        sanitizedMap[entry.key] = _sanitizeList(value);
      } else {
        sanitizedMap[entry.key] = value;
      }
    }

    return sanitizedMap;
  }

  /// Sanitize a string value by detecting sensitive patterns
  static String _sanitizeStringValue(String value) {
    if (value.isEmpty) {
      return value;
    }

    String sanitized = value;

    // Check against sensitive patterns
    for (final pattern in _sensitivePatterns) {
      if (pattern.hasMatch(sanitized)) {
        return _filteredPlaceholder;
      }
    }

    return sanitized;
  }

  /// Public method to sanitize a string value by detecting sensitive patterns
  static String sanitizeString(String value) {
    return _sanitizeStringValue(value);
  }

  /// Sanitize a list of values
  static List<dynamic> _sanitizeList(List list) {
    return list.map((item) {
      if (item is Map) {
        return sanitizeMap(Map<String, dynamic>.from(item));
      } else if (item is String) {
        return _sanitizeStringValue(item);
      } else {
        return item;
      }
    }).toList();
  }

  /// Check if a field name is considered sensitive
  static bool _isSensitiveField(String fieldName) {
    final lowerFieldName = fieldName.toLowerCase();

    // Direct matches
    if (_sensitiveFields.contains(lowerFieldName)) {
      return true;
    }

    // Partial matches (e.g., 'user_password' contains 'password')
    for (final sensitiveField in _sensitiveFields) {
      if (lowerFieldName.contains(sensitiveField)) {
        return true;
      }
    }

    return false;
  }

  /// Sanitize headers specifically
  static Map<String, dynamic> sanitizeHeaders(Map<String, dynamic>? headers) {
    if (headers == null || headers.isEmpty) {
      return {};
    }

    final sanitizedHeaders = <String, dynamic>{};

    for (final entry in headers.entries) {
      final key = entry.key.toLowerCase();
      final value = entry.value;

      // Always sanitize common sensitive headers
      if (_isSensitiveHeader(key)) {
        sanitizedHeaders[entry.key] = _redactedPlaceholder;
      } else if (value is String) {
        sanitizedHeaders[entry.key] = _sanitizeStringValue(value);
      } else {
        sanitizedHeaders[entry.key] = value;
      }
    }

    return sanitizedHeaders;
  }

  /// Check if a header is considered sensitive
  static bool _isSensitiveHeader(String headerName) {
    final lowerHeaderName = headerName.toLowerCase();

    const sensitiveHeaders = [
      'authorization',
      'x-api-key',
      'x-auth-token',
      'x-access-token',
      'x-session-token',
      'x-csrf-token',
      'cookie',
      'set-cookie',
      'x-forwarded-for',
      'x-real-ip',
    ];

    if (sensitiveHeaders.contains(lowerHeaderName)) {
      return true;
    }

    // Check for partial matches
    for (final sensitiveHeader in sensitiveHeaders) {
      if (lowerHeaderName.contains(sensitiveHeader)) {
        return true;
      }
    }

    return false;
  }

  /// Sanitize JSON string
  static String sanitizeJsonString(String jsonString) {
    try {
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final sanitized = sanitizeMap(jsonData);
      return json.encode(sanitized);
    } catch (e) {
      // If it's not valid JSON, sanitize as string
      return _sanitizeStringValue(jsonString);
    }
  }

  /// Custom sanitization with field-specific rules
  static Map<String, dynamic> sanitizeWithCustomRules(
    Map<String, dynamic>? data, {
    List<String>? additionalSensitiveFields,
    List<RegExp>? additionalPatterns,
    bool sanitizeEmails = true,
    bool sanitizePhones = true,
  }) {
    if (data == null || data.isEmpty) {
      return {};
    }

    // Create custom field list based on parameters
    final customSensitiveFields = List<String>.from(_sensitiveFields);
    if (additionalSensitiveFields != null) {
      customSensitiveFields.addAll(additionalSensitiveFields);
    }

    // If email/phone sanitization is disabled, remove them from the list
    if (!sanitizeEmails) {
      customSensitiveFields.remove('email');
    }
    if (!sanitizePhones) {
      customSensitiveFields.remove('phone');
      customSensitiveFields.remove('phone_number');
    }

    final sanitizedMap = <String, dynamic>{};

    for (final entry in data.entries) {
      final key = entry.key.toLowerCase();
      final value = entry.value;

      if (_isSensitiveFieldCustom(key, customSensitiveFields)) {
        sanitizedMap[entry.key] = _redactedPlaceholder;
      } else if (value is String) {
        sanitizedMap[entry.key] = _sanitizeStringValueWithCustomPatterns(
          value,
          additionalPatterns ?? [],
          sanitizeEmails,
          sanitizePhones,
        );
      } else if (value is Map) {
        sanitizedMap[entry.key] = sanitizeWithCustomRules(
          Map<String, dynamic>.from(value),
          additionalSensitiveFields: additionalSensitiveFields,
          additionalPatterns: additionalPatterns,
          sanitizeEmails: sanitizeEmails,
          sanitizePhones: sanitizePhones,
        );
      } else if (value is List) {
        sanitizedMap[entry.key] = _sanitizeListWithCustomPatterns(
          value,
          additionalPatterns ?? [],
          sanitizeEmails,
          sanitizePhones,
        );
      } else {
        sanitizedMap[entry.key] = value;
      }
    }

    return sanitizedMap;
  }

  /// Check if a field name is sensitive with custom rules
  static bool _isSensitiveFieldCustom(String fieldName, List<String> sensitiveFields) {
    final lowerFieldName = fieldName.toLowerCase();

    if (sensitiveFields.contains(lowerFieldName)) {
      return true;
    }

    for (final sensitiveField in sensitiveFields) {
      if (lowerFieldName.contains(sensitiveField)) {
        return true;
      }
    }

    return false;
  }

  /// Sanitize string value with custom patterns
  static String _sanitizeStringValueWithCustomPatterns(
    String value,
    List<RegExp> additionalPatterns, [
    bool sanitizeEmails = true,
    bool sanitizePhones = true,
  ]) {
    if (value.isEmpty) {
      return value;
    }

    String sanitized = value;

    // Check against default patterns (with email/phone filtering)
    for (final pattern in _sensitivePatterns) {
      // Skip email pattern if email sanitization is disabled
      if (!sanitizeEmails && pattern.toString().contains('@')) {
        continue;
      }
      // Skip phone pattern if phone sanitization is disabled
      if (!sanitizePhones && pattern.toString().contains('\\d{3}')) {
        continue;
      }

      if (pattern.hasMatch(sanitized)) {
        return _filteredPlaceholder;
      }
    }

    // Check against additional patterns
    for (final pattern in additionalPatterns) {
      if (pattern.hasMatch(sanitized)) {
        return _filteredPlaceholder;
      }
    }

    return sanitized;
  }

  /// Sanitize list with custom patterns
  static List<dynamic> _sanitizeListWithCustomPatterns(
    List list,
    List<RegExp> additionalPatterns, [
    bool sanitizeEmails = true,
    bool sanitizePhones = true,
  ]) {
    return list.map((item) {
      if (item is Map) {
        return sanitizeWithCustomRules(
          Map<String, dynamic>.from(item),
          additionalPatterns: additionalPatterns,
          sanitizeEmails: sanitizeEmails,
          sanitizePhones: sanitizePhones,
        );
      } else if (item is String) {
        return _sanitizeStringValueWithCustomPatterns(
          item,
          additionalPatterns,
          sanitizeEmails,
          sanitizePhones,
        );
      } else {
        return item;
      }
    }).toList();
  }
}