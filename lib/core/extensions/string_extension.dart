import 'package:fpdart/fpdart.dart';

/// Extension methods on String
extension StringExtension on String {
  /// Check if string is empty or only whitespace
  bool get isNullOrEmpty => trim().isEmpty;

  /// Check if string is not empty and not only whitespace
  bool get isNotNullOrNotEmpty => trim().isNotEmpty;

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalize first letter of each word
  String get capitalizeWords {
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string contains only numbers
  bool get isNumeric {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(this);
  }

  /// Check if string is a valid phone number (Indonesia format)
  bool get isValidPhoneNumber {
    final phoneRegex = RegExp(r'^(\+62|62|0)8[1-9][0-9]{6,9}$');
    return phoneRegex.hasMatch(this);
  }

  /// Check if string contains only alphabets
  bool get isAlphabetic {
    final alphaRegex = RegExp(r'^[a-zA-Z]+$');
    return alphaRegex.hasMatch(this);
  }

  /// Check if string contains only alphabets and spaces
  bool get isAlphabeticWithSpace {
    final alphaSpaceRegex = RegExp(r'^[a-zA-Z\s]+$');
    return alphaSpaceRegex.hasMatch(this);
  }

  /// Check if password is strong
  /// Strong password: min 8 chars, contains uppercase, lowercase, number, and special character
  bool get isStrongPassword {
    if (length < 8) return false;

    final hasUppercase = contains(RegExp(r'[A-Z]'));
    final hasLowercase = contains(RegExp(r'[a-z]'));
    final hasNumber = contains(RegExp(r'[0-9]'));
    final hasSpecialChar = contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return hasUppercase && hasLowercase && hasNumber && hasSpecialChar;
  }

  /// Check if password is medium strength
  /// Medium password: min 6 chars, contains at least 2 of: uppercase, lowercase, number, special
  bool get isMediumPassword {
    if (length < 6) return false;

    final hasUppercase = contains(RegExp(r'[A-Z]'));
    final hasLowercase = contains(RegExp(r'[a-z]'));
    final hasNumber = contains(RegExp(r'[0-9]'));
    final hasSpecialChar = contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    final strengthScore = [
      hasUppercase,
      hasLowercase,
      hasNumber,
      hasSpecialChar
    ].where((condition) => condition).length;

    return strengthScore >= 2;
  }

  /// Remove all whitespace
  String get removeAllWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Convert to title case
  String get toTitleCase =>
      split(' ').map((word) => word.isEmpty ? word : word.capitalize).join(' ');

  /// Truncate string and add ellipsis
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Remove HTML tags
  String get removeHtmlTags {
    final htmlTagRegex =
        RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return replaceAll(htmlTagRegex, '');
  }

  /// Convert to currency format (Indonesia Rupiah)
  String get toCurrency {
    if (isEmpty) return 'Rp 0';

    final number = double.tryParse(replaceAll(RegExp(r'[^0-9.]'), ''));
    if (number == null) return this;

    return 'Rp ${number.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  /// Mask email for privacy
  String get maskEmail {
    if (!isValidEmail) return this;

    final parts = split('@');
    if (parts.length != 2) return this;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) return this;

    final maskedUsername =
        '${username[0]}${'*' * (username.length - 2)}${username[username.length - 1]}';
    return '$maskedUsername@$domain';
  }

  /// Mask phone number for privacy
  String get maskPhoneNumber {
    if (length <= 4) return this;

    final visibleChars = substring(0, 3);
    final maskedChars = '*' * (length - 6);
    final lastChars = substring(length - 3);

    return '$visibleChars$maskedChars$lastChars';
  }

  /// Convert to Either for validation
  Either<String, String> validateEmail() {
    if (isNullOrEmpty) {
      return const Left('Email cannot be empty');
    }
    if (!isValidEmail) {
      return const Left('Please enter a valid email address');
    }
    return Right(this);
  }

  /// Convert to Either for password validation
  Either<String, String> validatePassword({
    int minLength = 6,
    bool requireStrong = false,
  }) {
    if (isNullOrEmpty) {
      return const Left('Password cannot be empty');
    }
    if (length < minLength) {
      return Left('Password must be at least $minLength characters');
    }
    if (requireStrong && !isStrongPassword) {
      return const Left(
          'Password must contain uppercase, lowercase, number, and special character');
    }
    return Right(this);
  }

  /// Convert to Either for phone validation
  Either<String, String> validatePhoneNumber() {
    if (isNullOrEmpty) {
      return const Left('Phone number cannot be empty');
    }
    if (!isValidPhoneNumber) {
      return const Left('Please enter a valid Indonesian phone number');
    }
    return Right(this);
  }
}
