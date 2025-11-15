import 'package:flutter/material.dart';
import '../../../i18n/app_localizations.g.dart';
import 'exceptions.dart';

/// Utility class for getting user-friendly error messages
/// Supports internationalization with AppLocalizations
class ErrorMessages {
  const ErrorMessages._();

  /// Get user-friendly message for AppException
  static String getMessage(BuildContext context, AppException exception) {
    final localizations = AppLocalizations.of(context);

    if (exception is NetworkException) {
      return _getNetworkMessage(context, exception);
    } else if (exception is AuthException) {
      return _getAuthMessage(context, exception);
    } else if (exception is ValidationException) {
      return _getValidationMessage(context, exception);
    } else if (exception is ServerException) {
      return _getServerMessage(context, exception);
    } else if (exception is CacheException) {
      return _getCacheMessage(context, exception);
    } else if (exception is PermissionException) {
      return _getPermissionMessage(context, exception);
    } else if (exception is ConfigurationException) {
      return _getConfigurationMessage(context, exception);
    } else if (exception is TimeoutException) {
      return _getTimeoutMessage(context, exception);
    } else if (exception is ParseException) {
      return _getParseMessage(context, exception);
    }

    // Fallback for unknown exceptions
    return localizations.messagesUnknownError;
  }

  /// Get user-friendly message for NetworkException
  static String _getNetworkMessage(BuildContext context, NetworkException exception) {
    final localizations = AppLocalizations.of(context);

    if (exception.statusCode != null) {
      switch (exception.statusCode) {
        case 400:
          return localizations.validationRequired;
        case 401:
          return localizations.messagesLoginFailed;
        case 403:
          return localizations.messagesUnknownError; // TODO: Add forbidden message
        case 404:
          return localizations.messagesUnknownError; // TODO: Add not found message
        case 408:
          return localizations.messagesNetworkError;
        case 429:
          return localizations.messagesRateLimitExceeded;
        case 500:
        case 502:
        case 503:
          return localizations.messagesServerError;
        default:
          if (exception.statusCode! >= 500) {
            return localizations.messagesServerError;
          }
      }
    }

    // Handle specific network error types
    if (exception.code != null) {
      switch (exception.code) {
        case 'CONNECTION_TIMEOUT':
        case 'SEND_TIMEOUT':
        case 'RECEIVE_TIMEOUT':
          return localizations.messagesNetworkError;
        case 'CONNECTION_ERROR':
          return localizations.messagesNetworkError;
        case 'CANCELLED':
          return localizations.messagesRequestCancelled;
      }
    }

    // Default network error
    return localizations.messagesNetworkError;
  }

  /// Get user-friendly message for AuthException
  static String _getAuthMessage(BuildContext context, AuthException exception) {
    final localizations = AppLocalizations.of(context);

    switch (exception.type) {
      case AuthExceptionType.unauthorized:
        return localizations.messagesLoginFailed;
      case AuthExceptionType.forbidden:
        return localizations.messagesAccessDenied;
      case AuthExceptionType.tokenExpired:
        return localizations.messagesTokenExpired;
      case AuthExceptionType.tokenInvalid:
        return localizations.messagesInvalidToken;
      case AuthExceptionType.invalidCredentials:
        return localizations.messagesLoginFailed;
      case AuthExceptionType.accountLocked:
        return localizations.messagesAccountLocked;
      case AuthExceptionType.accountNotVerified:
        return localizations.messagesAccountNotVerified;
      case AuthExceptionType.sessionExpired:
        return localizations.messagesSessionExpired;
      case AuthExceptionType.refreshTokenFailed:
        return localizations.messagesRefreshFailed;
      case AuthExceptionType.loginRequired:
        return localizations.authLogin;
    }
  }

  /// Get user-friendly message for ValidationException
  static String _getValidationMessage(BuildContext context, ValidationException exception) {
    final localizations = AppLocalizations.of(context);

    // Check for field-specific errors
    if (exception.fieldErrors != null && exception.fieldErrors!.isNotEmpty) {
      // Return the first field error for simplicity
      final firstFieldError = exception.fieldErrors!.entries.first;
      final field = firstFieldError.key;
      final error = firstFieldError.value;

      // Handle common field errors
      if (field.toLowerCase().contains('email')) {
        if (error.toLowerCase().contains('required') || error.toLowerCase().contains('empty')) {
          return localizations.validationRequired;
        } else {
          return localizations.validationEmailInvalid;
        }
      } else if (field.toLowerCase().contains('password')) {
        if (error.toLowerCase().contains('required') || error.toLowerCase().contains('empty')) {
          return localizations.validationRequired;
        } else if (error.toLowerCase().contains('short') || error.toLowerCase().contains('min')) {
          return localizations.validationPasswordTooShort;
        } else if (error.toLowerCase().contains('long') || error.toLowerCase().contains('max')) {
          return localizations.validationPasswordTooLong;
        }
      }

      // Return the specific error message if available
      if (error.isNotEmpty) {
        return error;
      }
    }

    // Default validation error
    return exception.message.isNotEmpty ? exception.message : localizations.validationRequired;
  }

  /// Get user-friendly message for ServerException
  static String _getServerMessage(BuildContext context, ServerException exception) {
    final localizations = AppLocalizations.of(context);

    if (exception.statusCode != null) {
      switch (exception.statusCode) {
        case 400:
          return localizations.validationRequired;
        case 401:
          return localizations.messagesLoginFailed;
        case 403:
          return localizations.messagesAccessDenied;
        case 404:
          return localizations.messagesNotFound;
        case 500:
        case 502:
        case 503:
          return localizations.messagesServerError;
        default:
          if (exception.statusCode! >= 500) {
            return localizations.messagesServerError;
          }
      }
    }

    // Default server error
    return exception.message.isNotEmpty
        ? exception.message
        : localizations.messagesUnknownError;
  }

  /// Get user-friendly message for CacheException
  static String _getCacheMessage(BuildContext context, CacheException exception) {
    final localizations = AppLocalizations.of(context);

    // Handle specific cache operations
    if (exception.operation != null) {
      switch (exception.operation) {
        case 'read':
        case 'get':
          return localizations.messagesCacheReadError;
        case 'write':
        case 'save':
        case 'set':
          return localizations.messagesCacheWriteError;
        case 'delete':
        case 'clear':
          return localizations.messagesCacheDeleteError;
      }
    }

    // Default cache error
    return localizations.messagesUnknownError;
  }

  /// Get user-friendly message for PermissionException
  static String _getPermissionMessage(BuildContext context, PermissionException exception) {
    final localizations = AppLocalizations.of(context);

    // Handle specific permissions
    if (exception.permission != null) {
      switch (exception.permission) {
        case 'camera':
          return localizations.messagesCameraPermissionDenied;
        case 'microphone':
          return localizations.messagesMicrophonePermissionDenied;
        case 'location':
          return localizations.messagesLocationPermissionDenied;
        case 'storage':
          return localizations.messagesStoragePermissionDenied;
        case 'photos':
          return localizations.messagesPhotosPermissionDenied;
      }
    }

    // Default permission error
    return localizations.messagesUnknownError;
  }

  /// Get user-friendly message for ConfigurationException
  static String _getConfigurationMessage(BuildContext context, ConfigurationException exception) {
    final localizations = AppLocalizations.of(context);

    // Handle specific configuration keys
    if (exception.configKey != null) {
      if (exception.configKey!.toLowerCase().contains('api')) {
        return localizations.messagesApiConfigError;
      } else if (exception.configKey!.toLowerCase().contains('database')) {
        return localizations.messagesDatabaseConfigError;
      }
    }

    // Default configuration error
    return localizations.messagesUnknownError;
  }

  /// Get user-friendly message for TimeoutException
  static String _getTimeoutMessage(BuildContext context, TimeoutException exception) {
    final localizations = AppLocalizations.of(context);

    // Handle specific operations
    if (exception.operation != null) {
      switch (exception.operation) {
        case 'network':
        case 'api':
        case 'http':
          return localizations.messagesNetworkError;
        case 'database':
          return localizations.messagesDatabaseTimeout;
        case 'cache':
          return localizations.messagesCacheTimeout;
      }
    }

    // Default timeout error
    return localizations.messagesNetworkError;
  }

  /// Get user-friendly message for ParseException
  static String _getParseMessage(BuildContext context, ParseException exception) {
    final localizations = AppLocalizations.of(context);

    // Handle specific data types
    if (exception.dataType != null) {
      switch (exception.dataType) {
        case 'json':
          return localizations.messagesJsonParseError;
        case 'xml':
          return localizations.messagesXmlParseError;
        case 'date':
        case 'datetime':
          return localizations.messagesDateParseError;
        case 'number':
        case 'int':
        case 'double':
          return localizations.messagesNumberParseError;
      }
    }

    // Default parse error
    return localizations.messagesUnknownError;
  }
}

/// Extension on AppException to easily get user-friendly messages
extension AppExceptionExtension on AppException {
  String getUserFriendlyMessage(BuildContext context) {
    return ErrorMessages.getMessage(context, this);
  }
}