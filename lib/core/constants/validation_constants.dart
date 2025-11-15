/// Konstanta validasi yang digunakan di seluruh aplikasi
class ValidationConstants {
  const ValidationConstants._();

  // ==================== Password Validation ====================

  /// Minimum panjang password (6 karakter)
  static const int passwordMinLength = 6;

  /// Maximum panjang password (50 karakter)
  static const int passwordMaxLength = 50;

  /// Minimum jumlah uppercase character dalam password
  static const int passwordMinUppercase = 1;

  /// Minimum jumlah lowercase character dalam password
  static const int passwordMinLowercase = 1;

  /// Minimum jumlah digit dalam password
  static const int passwordMinDigits = 1;

  /// Minimum jumlah special character dalam password
  static const int passwordMinSpecialChars = 1;

  // ==================== Username Validation ====================

  /// Maximum panjang username (30 karakter)
  static const int usernameMaxLength = 30;

  /// Minimum panjang username (3 karakter)
  static const int usernameMinLength = 3;

  // ==================== ID Validation ====================

  /// Panjang ID yang diharapkan (16 karakter)
  static const int idLength = 16;

  /// Minimum panjang ID
  static const int idMinLength = 8;

  /// Maximum panjang ID
  static const int idMaxLength = 32;

  // ==================== Postal Code Validation ====================

  /// Panjang postal code (5 karakter)
  static const int postalCodeLength = 5;

  /// Minimum panjang postal code
  static const int postalCodeMinLength = 4;

  /// Maximum panjang postal code
  static const int postalCodeMaxLength = 10;

  // ==================== Phone Number Validation ====================

  /// Minimum panjang nomor telepon
  static const int phoneNumberMinLength = 8;

  /// Maximum panjang nomor telepon
  static const int phoneNumberMaxLength = 15;

  // ==================== Email Validation ====================

  /// Maximum panjang email
  static const int emailMaxLength = 100;

  /// Minimum panjang email
  static const int emailMinLength = 5;

  // ==================== Name Validation ====================

  /// Maximum panjang nama depan
  static const int firstNameMaxLength = 50;

  /// Maximum panjang nama belakang
  static const int lastNameMaxLength = 50;

  /// Maximum panjang nama lengkap
  static const int fullNameMaxLength = 100;

  // ==================== Address Validation ====================

  /// Maximum panjang alamat
  static const int addressMaxLength = 200;

  /// Maximum panjang kota
  static const int cityMaxLength = 50;

  /// Maximum panjang provinsi
  static const int provinceMaxLength = 50;

  /// Maximum panjang negara
  static const int countryMaxLength = 50;

  // ==================== Text Validation ====================

  /// Maximum panjang untuk text field umum
  static const int textMaxLength = 255;

  /// Maximum panjang untuk textarea
  static const int textareaMaxLength = 1000;

  /// Maximum panjang untuk deskripsi
  static const int descriptionMaxLength = 500;

  // ==================== File Validation ====================

  /// Maximum file size dalam bytes (5MB)
  static const int maxFileSizeBytes = 5 * 1024 * 1024;

  /// Maximum file size untuk gambar (2MB)
  static const int maxImageSizeBytes = 2 * 1024 * 1024;

  /// Maximum file size untuk dokumen (10MB)
  static const int maxDocumentSizeBytes = 10 * 1024 * 1024;

  // ==================== OTP Validation ====================

  /// Panjang kode OTP
  static const int otpLength = 6;

  /// Masa berlaku OTP dalam menit
  static const int otpExpiryMinutes = 5;

  // ==================== Card Validation ====================

  /// Panjang nomor kartu kredit
  static const int cardNumberLength = 16;

  /// Panjang CVV
  static const int cvvLength = 3;

  /// Panjang expiry month
  static const int expiryMonthLength = 2;

  /// Panjang expiry year
  static const int expiryYearLength = 4;
}