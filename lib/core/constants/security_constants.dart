import 'dart:async';

/// Konstanta security yang digunakan di seluruh aplikasi
class SecurityConstants {
  const SecurityConstants._();

  // ==================== Encryption ====================

  /// AES key length (256 bits)
  static const int aesKeyLength = 256;

  /// IV (Initialization Vector) size (16 bytes)
  static const int ivSize = 16;

  /// Random key length untuk generate (32 bytes)
  static const int randomKeyLength = 32;

  /// Salt length untuk hashing
  static const int saltLength = 16;

  /// PBKDF2 iterations
  static const int pbkdf2Iterations = 10000;

  // ==================== Authentication ====================

  /// Maximum retry attempts untuk login
  static const int maxRetryAttempts = 3;

  /// Maximum failed attempts sebelum lockout
  static const int maxFailedAttempts = 5;

  /// Lockout duration setelah failed attempts (15 menit)
  static const Duration lockoutDuration = Duration(minutes: 15);

  /// Session timeout duration (24 jam)
  static const Duration sessionTimeout = Duration(hours: 24);

  /// Remember me duration (30 hari)
  static const Duration rememberMeDuration = Duration(days: 30);

  // ==================== Key Management ====================

  /// Key rotation interval (30 hari)
  static const Duration keyRotationInterval = Duration(days: 30);

  /// Maximum key age sebelum rotation
  static const Duration maxKeyAge = Duration(days: 30);

  /// Key derivation iteration count
  static const int keyDerivationIterations = 100000;

  /// Minimum key strength score
  static const int minKeyStrengthScore = 80;

  // ==================== Token Management ====================

  /// Access token expiry (1 jam)
  static const Duration accessTokenExpiry = Duration(hours: 1);

  /// Refresh token expiry (7 hari)
  static const Duration refreshTokenExpiry = Duration(days: 7);

  /// Reset token expiry (1 jam)
  static const Duration resetTokenExpiry = Duration(hours: 1);

  /// Verification token expiry (24 jam)
  static const Duration verificationTokenExpiry = Duration(hours: 24);

  /// OTP token expiry (5 menit)
  static const Duration otpTokenExpiry = Duration(minutes: 5);

  // ==================== Password Security ====================

  /// Password history length (prevent reuse)
  static const int passwordHistoryLength = 5;

  /// Minimum password strength score
  static const int minPasswordStrengthScore = 60;

  /// Password change cooldown (1 jam)
  static const Duration passwordChangeCooldown = Duration(hours: 1);

  /// Force password change interval (90 hari)
  static const Duration forcePasswordChangeInterval = Duration(days: 90);

  // ==================== Rate Limiting ====================

  /// Login rate limit per minute
  static const int loginRateLimitPerMinute = 5;

  /// API rate limit per minute
  static const int apiRateLimitPerMinute = 100;

  /// Password reset rate limit per hour
  static const int passwordResetRateLimitPerHour = 3;

  /// OTP request rate limit per minute
  static const int otpRequestRateLimitPerMinute = 3;

  // ==================== Session Security ====================

  /// Maximum concurrent sessions per user
  static const int maxConcurrentSessions = 3;

  /// Session inactivity timeout (30 menit)
  static const Duration sessionInactivityTimeout = Duration(minutes: 30);

  /// Session warning timeout (25 menit)
  static const Duration sessionWarningTimeout = Duration(minutes: 25);

  /// Session refresh interval (15 menit)
  static const Duration sessionRefreshInterval = Duration(minutes: 15);

  // ==================== Certificate & SSL ====================

  /// Certificate pinning refresh interval (7 hari)
  static const Duration certificatePinRefreshInterval = Duration(days: 7);

  /// SSL handshake timeout (10 detik)
  static const Duration sslHandshakeTimeout = Duration(seconds: 10);

  /// Certificate validation depth
  static const int certificateValidationDepth = 3;

  // ==================== Audit & Logging ====================

  /// Audit log retention period (1 tahun)
  static const Duration auditLogRetention = Duration(days: 365);

  /// Security log retention period (6 bulan)
  static const Duration securityLogRetention = Duration(days: 180);

  /// Failed login log retention (30 hari)
  static const Duration failedLoginLogRetention = Duration(days: 30);

  // ==================== Biometric Security ====================

  /// Biometric timeout (30 detik)
  static const Duration biometricTimeout = Duration(seconds: 30);

  /// Maximum biometric attempts
  static const int maxBiometricAttempts = 3;

  /// Biometric fallback cooldown (1 menit)
  static const Duration biometricFallbackCooldown = Duration(minutes: 1);

  // ==================== Device Security ====================

  /// Device registration timeout (5 menit)
  static const Duration deviceRegistrationTimeout = Duration(minutes: 5);

  /// Maximum devices per user
  static const int maxDevicesPerUser = 5;

  /// Device trust duration (30 hari)
  static const Duration deviceTrustDuration = Duration(days: 30);

  /// Device cleanup interval (7 hari)
  static const Duration deviceCleanupInterval = Duration(days: 7);

  // ==================== Network Security ====================

  /// VPN detection timeout (5 detik)
  static const Duration vpnDetectionTimeout = Duration(seconds: 5);

  /// Network security check interval (1 jam)
  static const Duration networkSecurityCheckInterval = Duration(hours: 1);

  /// Maximum network redirects
  static const int maxNetworkRedirects = 3;

  /// HTTP request timeout (30 detik)
  static const Duration httpRequestTimeout = Duration(seconds: 30);
}