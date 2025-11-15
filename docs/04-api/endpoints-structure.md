# API Endpoints Structure
# Struktur API Endpoints untuk Mobile Apps

---

## 📋 **Document Metadata**

| Field | Value |
|-------|-------|
| **Document ID** | DOC-API-ENDPOINTS-STRUCTURE |
| **Version** | 1.0 |
| **Status** | Ready to Implement |
| **Category** | API Documentation |
| **Priority** | High |
| **Created Date** | November 13, 2025 |
| **Last Updated** | November 13, 2025 |
| **Next Review** | November 20, 2025 |
| **Author** | Mobile Development Team |
| **Reviewers** | Backend Lead, Frontend Lead |
| **Stakeholders** | Development Team, Product Management |

---

## 🎯 **Purpose**

Dokumen ini mendefinisikan struktur API endpoints yang terpisah untuk aplikasi mobile Usago. Pemisahan endpoints ini bertujuan untuk:

1. **Maintainability** - Memudahkan maintenance dan update
2. **Clarity** - Struktur yang jelas dan terorganisir
3. **Scalability** - Memudahkan penambahan endpoints baru
4. **Team Collaboration** - Memudahkan kerja tim lintas fungsi

---

## 📁 **Struktur Direktori API Endpoints**

```
apps/mobile/lib/core/constants/
├── api_constants.dart              # Base URL dan konfigurasi API
├── auth_endpoints.dart            # Authentication endpoints
├── brand_endpoints.dart           # Brand management endpoints
├── branch_endpoints.dart          # Branch management endpoints
├── wallet_endpoints.dart          # Wallet management endpoints
├── invoice_endpoints.dart         # Invoice management endpoints
├── customer_endpoints.dart        # Customer management endpoints
├── product_endpoints.dart         # Product management endpoints
├── analytics_endpoints.dart       # Analytics endpoints
├── reporting_endpoints.dart       # Reporting endpoints
└── storage_constants.dart         # Storage keys dan konstanti
```

---

## 🔗 **API Base Configuration**

### `api_constants.dart`
```dart
class ApiConstants {
  // Base Configuration
  static const String apiBaseUrl = 'http://localhost:3000';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const String apiVersion = 'v1';

  // Headers
  static const String contentTypeHeader = 'application/json';
  static const String acceptHeader = 'application/json';
  static const String bearerTokenHeader = 'Authorization';

  // Response Codes
  static const int successCode = 200;
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int serverErrorCode = 500;
}
```

---

## 🔐 **Authentication Endpoints**

### `auth_endpoints.dart`
```dart
class AuthEndpoints {
  // Authentication
  static const String signIn = '/api/auth/sign-in/email';
  static const String signUp = '/api/auth/sign-up/email';
  static const String signOut = '/api/auth/sign-out';
  static const String refreshToken = '/api/auth/refresh-token';

  // Email Verification
  static const String verifyEmail = '/api/auth/verify-email';
  static const String resendVerificationEmail = '/api/auth/resend-verification';

  // Password Management
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';
  static const String changePassword = '/api/auth/change-password';

  // Profile Management
  static const String updateProfile = '/api/auth/profile';
  static const String deleteAccount = '/api/auth/account';
  static const String getUserProfile = '/api/auth/profile';

  // Session Management
  static const String getSession = '/api/auth/session';
  static const String validateSession = '/api/auth/validate';
  static const String switchSession = '/api/auth/switch';
}
```

---

## 🏢 **Brand Management Endpoints**

### `brand_endpoints.dart`
```dart
class BrandEndpoints {
  // Brand CRUD
  static const String brands = '/api/brands';
  static const String createBrand = '/api/brands';
  static const String getBrand = '/api/brands/{id}';
  static const String updateBrand = '/api/brands/{id}';
  static const String deleteBrand = '/api/brands/{id}';
  static const String getBrandBySlug = '/api/brands/slug/{slug}';

  // User Brand Relations
  static const String getUserBrands = '/api/brands/user';
  static const String getAccessibleBrands = '/api/brands/accessible';
  static const String switchActiveBrand = '/api/brands/switch';

  // Brand Management
  static const String getBrandStats = '/api/brands/{id}/stats';
  static const String transferOwnership = '/api/brands/{id}/transfer';

  // Brand Invitations
  static const String inviteUser = '/api/brands/{id}/invite';
  static const String acceptInvitation = '/api/invitations/accept';
  static const String declineInvitation = '/api/invitations/{invitationId}/decline';
  static const String getBrandInvitations = '/api/brands/{id}/invitations';
}
```

---

## 🏪 **Branch Management Endpoints**

### `branch_endpoints.dart`
```dart
class BranchEndpoints {
  // Branch CRUD
  static const String branches = '/api/branches';
  static const String createBranch = '/api/branches';
  static const String getBranch = '/api/branches/{id}';
  static const String updateBranch = '/api/branches/{id}';
  static const String deleteBranch = '/api/branches/{id}';
  static const String getBranchBySlug = '/api/branches/slug/{slug}';

  // User Branch Relations
  static const String getUserBranches = '/api/branches/user';
  static const String getAccessibleBranches = '/api/branches/user';
  static const String switchActiveBranch = '/api/branches/switch';

  // Branch Management
  static const String getBranchStats = '/api/branches/{id}/stats';
  static const String getBranchHierarchy = '/api/branches/hierarchy';
  static const String updateBranchHierarchy = '/api/branches/{id}/hierarchy';

  // Branch User Management
  static const String getBranchUsers = '/api/branches/{id}/users';
  static const String assignUserToBranch = '/api/branches/{id}/users';
  static const String updateUserBranchRole = '/api/branches/users/{roleId}';
  static const String removeUserBranchRole = '/api/branches/users/{roleId}';
}
```

---

## 💰 **Wallet Management Endpoints**

### `wallet_endpoints.dart`
```dart
class WalletEndpoints {
  // Wallet CRUD
  static const String wallets = '/api/wallets';
  static const String createWallet = '/api/wallets';
  static const String getWallet = '/api/wallets/{id}';
  static const String updateWallet = '/api/wallets/{id}';
  static const String deleteWallet = '/api/wallets/{id}';

  // Wallet Operations
  static const String getWalletBalance = '/api/wallets/{id}/balance';
  static const String getWalletTransactions = '/api/wallets/{id}/transactions';
  static const String transferFunds = '/api/wallets/transfer';
  static const String depositFunds = '/api/wallets/deposit';
  static const String withdrawFunds = '/api/wallets/withdraw';

  // Wallet Types
  static const String getOperationalWallets = '/api/wallets/operational';
  static const String getSavingsWallets = '/api/wallets/savings';
  static const String getProjectWallets = '/api/wallets/project';
  static const String getCommunityWallets = '/api/wallets/community';
  static const String getPersonalWallets = '/api/wallets/personal';
  static const String getCustomerWallets = '/api/wallets/customer';
  static const String getSupplierWallets = '/api/wallets/supplier';
  static const String getEscrowWallets = '/api/wallets/escrow';

  // Wallet Analytics
  static const String getWalletStats = '/api/wallets/{id}/stats';
  static const String getWalletReport = '/api/wallets/{id}/report';
}
```

---

## 🧾 **Invoice Management Endpoints**

### `invoice_endpoints.dart`
```dart
class InvoiceEndpoints {
  // Invoice CRUD
  static const String invoices = '/api/invoices';
  static const String createInvoice = '/api/invoices';
  static const String getInvoice = '/api/invoices/{id}';
  static const String updateInvoice = '/api/invoices/{id}';
  static const String deleteInvoice = '/api/invoices/{id}';

  // Invoice Operations
  static const String sendInvoice = '/api/invoices/{id}/send';
  static const String payInvoice = '/api/invoices/{id}/pay';
  static const String cancelInvoice = '/api/invoices/{id}/cancel';
  static const String duplicateInvoice = '/api/invoices/{id}/duplicate';

  // Invoice Management
  static const String getInvoicesByStatus = '/api/invoices/status/{status}';
  static const String getInvoicesByCustomer = '/api/invoices/customer/{customerId}';
  static const String getInvoicesByBranch = '/api/invoices/branch/{branchId}';
  static const String getInvoicesByDateRange = '/api/invoices/daterange';

  // Invoice Reports
  static const String getInvoiceStats = '/api/invoices/stats';
  static const String getInvoiceReport = '/api/invoices/report';
  static const String exportInvoices = '/api/invoices/export';
}
```

---

## 👥 **Customer Management Endpoints**

### `customer_endpoints.dart`
```dart
class CustomerEndpoints {
  // Customer CRUD
  static const String customers = '/api/customers';
  static const String createCustomer = '/api/customers';
  static const String getCustomer = '/api/customers/{id}';
  static const String updateCustomer = '/api/customers/{id}';
  static const String deleteCustomer = '/api/customers/{id}';

  // Customer Search
  static const String searchCustomers = '/api/customers/search';
  static const String getCustomersByBranch = '/api/customers/branch/{branchId}';
  static const String getCustomersByBrand = '/api/customers/brand/{brandId}';

  // Customer Management
  static const String getCustomerStats = '/api/customers/{id}/stats';
  static const String getCustomerOrders = '/api/customers/{id}/orders';
  static const String getCustomerInvoices = '/api/customers/{id}/invoices';
  static const String addCustomerNote = '/api/customers/{id}/notes';
  static const String getCustomerNotes = '/api/customers/{id}/notes';
}
```

---

## 📦 **Product Management Endpoints**

### `product_endpoints.dart`
```dart
class ProductEndpoints {
  // Product CRUD
  static const String products = '/api/products';
  static const String createProduct = '/api/products';
  static const String getProduct = '/api/products/{id}';
  static const String updateProduct = '/api/products/{id}';
  static const String deleteProduct = '/api/products/{id}';

  // Product Management
  static const String getProductsByBranch = '/api/products/branch/{branchId}';
  static const String getProductsByCategory = '/api/products/category/{categoryId}';
  static const String searchProducts = '/api/products/search';
  static const String getProductInventory = '/api/products/{id}/inventory';
  static const String updateProductInventory = '/api/products/{id}/inventory';

  // Product Categories
  static const String categories = '/api/products/categories';
  static const String createCategory = '/api/products/categories';
  static const String updateCategory = '/api/products/categories/{id}';
  static const String deleteCategory = '/api/products/categories/{id}';

  // Product Analytics
  static const String getProductStats = '/api/products/{id}/stats';
  static const String getProductReport = '/api/products/report';
}
```

---

## 📊 **Analytics Endpoints**

### `analytics_endpoints.dart`
```dart
class AnalyticsEndpoints {
  // General Analytics
  static const String getDashboardStats = '/api/analytics/dashboard';
  static const String getBrandAnalytics = '/api/analytics/brand/{brandId}';
  static const String getBranchAnalytics = '/api/analytics/branch/{branchId}';

  // Sales Analytics
  static const String getSalesAnalytics = '/api/analytics/sales';
  static const String getRevenueAnalytics = '/api/analytics/revenue';
  static const String getCustomerAnalytics = '/api/analytics/customers';
  static const String getProductAnalytics = '/api/analytics/products';

  // Performance Analytics
  static const String getPerformanceMetrics = '/api/analytics/performance';
  static const String getConversionRates = '/api/analytics/conversions';
  static const String getRetentionAnalytics = '/api/analytics/retention';

  // Reports
  static const String generateReport = '/api/analytics/reports';
  static const String exportAnalytics = '/api/analytics/export';
  static const String scheduleReport = '/api/analytics/schedule';
}
```

---

## 📈 **Reporting Endpoints**

### `reporting_endpoints.dart`
```dart
class ReportingEndpoints {
  // Report Generation
  static const String generateReport = '/api/reports/generate';
  static const String getReports = '/api/reports';
  static const String getReport = '/api/reports/{id}';
  static const String deleteReport = '/api/reports/{id}';

  // Report Types
  static const String getFinancialReports = '/api/reports/financial';
  static const String getSalesReports = '/api/reports/sales';
  static const String getCustomerReports = '/api/reports/customers';
  static const String getPerformanceReports = '/api/reports/performance';

  // Report Management
  static const String scheduleReport = '/api/reports/schedule';
  static const String getScheduledReports = '/api/reports/scheduled';
  static const String cancelScheduledReport = '/api/reports/schedule/{id}';
  static const String exportReport = '/api/reports/{id}/export';

  // Report Templates
  static const String getReportTemplates = '/api/reports/templates';
  static const String createReportTemplate = '/api/reports/templates';
  static const String updateReportTemplate = '/api/reports/templates/{id}';
  static const String deleteReportTemplate = '/api/reports/templates/{id}';
}
```

---

## 🔑 **Storage Constants**

### `storage_constants.dart`
```dart
class StorageConstants {
  // Authentication Keys
  static const String authTokenKey = 'auth_token';
  static const String bearerTokenKey = 'bearer_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String sessionDataKey = 'session_data';

  // User Context Keys
  static const String activeBrandKey = 'active_brand';
  static const String activeBranchKey = 'active_branch';
  static const String userRoleKey = 'user_role';
  static const String permissionsKey = 'user_permissions';

  // App State Keys
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String appFirstLaunchKey = 'app_first_launch';
  static const String lastSyncTimeKey = 'last_sync_time';

  // Cache Keys
  static const String cachedBrandsKey = 'cached_brands';
  static const String cachedBranchesKey = 'cached_branches';
  static const String cachedWalletsKey = 'cached_wallets';
  static const String cachedCustomersKey = 'cached_customers';
  static const String cachedProductsKey = 'cached_products';

  // Settings Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  static const String notificationsKey = 'notifications_enabled';
  static const String biometricEnabledKey = 'biometric_enabled';
}
```

---

## 🔄 **Usage Examples**

### **Contoh Penggunaan di Repository**
```dart
import '../constants/auth_endpoints.dart';
import '../constants/brand_endpoints.dart';
import '../constants/branch_endpoints.dart';

class AuthRepository {
  Future<User> login(String email, String password) async {
    final response = await dioClient.post(
      AuthEndpoints.signIn,
      data: {
        'email': email,
        'password': password,
      },
    );
    return User.fromJson(response.data);
  }

  Future<List<Brand>> getUserBrands() async {
    final response = await dioClient.get(BrandEndpoints.getUserBrands);
    return (response.data as List)
        .map((json) => Brand.fromJson(json))
        .toList();
  }

  Future<List<Branch>> getBranches(String brandId) async {
    final response = await dioClient.get(
      '${BranchEndpoints.branches}?brandId=$brandId',
    );
    return (response.data as List)
        .map((json) => Branch.fromJson(json))
        .toList();
  }
}
```

---

## 📋 **Implementation Guidelines**

### **1. Endpoint Organization**
- Group endpoints by functionality
- Use consistent naming conventions
- Include HTTP methods in comments
- Document required parameters

### **2. Version Management**
- Include API version in base URL
- Maintain backward compatibility
- Document deprecation timelines

### **3. Error Handling**
- Use consistent error response format
- Include error codes and messages
- Handle network timeouts gracefully

### **4. Security**
- Always use HTTPS in production
- Include authentication headers
- Validate input parameters
- Handle sensitive data properly

---

## 🔗 **Related Documentation**

- [`../core/network/dio_client.dart`](../core/network/dio_client.dart) - HTTP Client Implementation
- [`../features/auth/data/repositories/auth_repository_impl.dart`](../features/auth/data/repositories/auth_repository_impl.dart) - Repository Pattern
- [`../core/di/injection_container.dart`](../core/di/injection_container.dart) - Dependency Injection
- [`../../docs/06-Data-API/01-API-Documentation.md`](../../../docs/06-Data-API/01-API-Documentation.md) - Complete API Documentation

---

## 📞 **Contact Information**

### **Development Team**

| Role | Name | Contact |
|-------|-------|----------|
| **Mobile Lead** | [Name] | [Email] |
| **Backend Lead** | [Name] | [Email] |
| **API Documentation** | [Name] | [Email] |

### **Support**

| Issue | Contact | Response Time |
|-------|----------|---------------|
| **API Issue** | [Name] | 2 hours |
| **Documentation Update** | [Name] | 4 hours |
| **Endpoint Addition** | [Name] | 1 week |

---

## 📝 **Notes**

### **Current Status (November 13, 2025)**
- ✅ **Structure Defined**: API endpoints structure telah didefinisikan dengan lengkap
- ✅ **Documentation Created**: Dokumentasi lengkap untuk setiap endpoint category
- ✅ **Best Practices**: Guidelines untuk implementasi telah disertakan
- 🔄 **Implementation**: Perlu implementasi di codebase mobile
- 🔄 **Integration**: Perlu integrasi dengan backend API documentation

### **Next Steps**
1. Implementasikan struktur endpoints di codebase mobile
2. Update repository pattern untuk menggunakan endpoints baru
3. Integrasikan dengan existing authentication flow
4. Test semua endpoints dengan backend
5. Update documentation berdasarkan implementasi aktual

---

## 🔗 **Error Handling Patterns**

### Centralized Error Handling

Aplikasi menggunakan centralized error handling dengan [`ErrorHandlerUtils`](../lib/core/utils/error_handler_utils.dart:9) untuk konsistensi dan tracking.

```dart
// Error handling pattern di datasource
return await safeApiCall<UserModel>(
  () async {
    final response = await _dioClient.post('/auth/login', data: loginData);
    return parseResponse(response, (data) => UserModel.fromJson(data));
  },
  method: 'POST',
  endpoint: '/auth/login',
  correlationId: correlationId,
  metadata: {'email': email},
);
```

### Error Response Format

Semua error responses mengikuti format standar:

```json
{
  "error": "Validation failed",
  "message": "Email is required",
  "userMessage": "Please enter your email address",
  "errors": {
    "email": ["Email is required"],
    "password": ["Password must be at least 8 characters"]
  },
  "code": "VALIDATION_ERROR",
  "correlationId": "abc12345"
}
```

### Error Types and Handling

| Error Type | HTTP Status | Handling Pattern | User Message |
|-------------|---------------|------------------|--------------|
| Validation Error | 400/422 | Form validation | Field-specific errors |
| Authentication Error | 401 | Redirect to login | Session expired |
| Authorization Error | 403 | Show permission error | Access denied |
| Not Found | 404 | Show 404 page | Resource not found |
| Rate Limit | 429 | Retry with backoff | Too many requests |
| Server Error | 500+ | Retry mechanism | Server error |

---

## 📊 **Correlation ID Tracking**

### Correlation ID Generation

Setiap request memiliki correlation ID unik untuk tracking:

```dart
// Generate correlation ID
final correlationId = ErrorHandlerUtils.generateCorrelationId();

// Include in request headers
final options = Options(
  headers: {
    'X-Correlation-ID': correlationId,
    'Content-Type': 'application/json',
  },
);

// Log dengan correlation ID
ErrorHandlerUtils.logError(
  error,
  correlationId: correlationId,
  operation: 'Login',
  metadata: {'endpoint': '/auth/login'},
);
```

### Request Chain Tracking

Correlation ID memungkinkan tracking request chain:

```
User Action (CID: abc12345)
    │
    ▼
BLoC Event (CID: abc12345)
    │
    ▼
Use Case (CID: abc12345)
    │
    ▼
Repository (CID: abc12345)
    │
    ▼
Data Source (CID: abc12345)
    │
    ▼
API Request (CID: abc12345)
```

### Debugging dengan Correlation ID

```dart
// Debug helper untuk tracing
class DebugTracer {
  static void trace(String operation, String correlationId, String message) {
    if (AppConfig.enableLogging) {
      print('[$correlationId] $operation: $message');
    }
  }
}

// Usage
DebugTracer.trace('API_CALL', correlationId, 'POST /auth/login');
```

---

## 📈 **Performance Monitoring**

### API Performance Tracking

Setiap API call di-track performancenya:

```dart
// Performance tracking di DataSourceMixin
class DataSourceMixin {
  Future<Either<Exception, T>> safeApiCall<T>(
    Future<T> Function() apiCall, {
    required String method,
    required String endpoint,
    String? correlationId,
  }) async {
    final stopwatch = Stopwatch()..start();
    final corrId = correlationId ?? generateCorrelationId();

    try {
      final result = await apiCall();
      stopwatch.stop();

      // Log performance metrics
      _logApiPerformance(
        method: method,
        endpoint: endpoint,
        duration: stopwatch.elapsed,
        success: true,
        correlationId: corrId,
      );

      return Right(result);
    } catch (e) {
      stopwatch.stop();

      // Log performance metrics
      _logApiPerformance(
        method: method,
        endpoint: endpoint,
        duration: stopwatch.elapsed,
        success: false,
        correlationId: corrId,
        error: e.toString(),
      );

      return Left(e);
    }
  }
}
```

### Performance Metrics

Metrics yang dikumpulkan untuk setiap API call:

```dart
class ApiPerformanceMetrics {
  final String method;
  final String endpoint;
  final Duration duration;
  final bool success;
  final String correlationId;
  final int? statusCode;
  final String? error;
  final DateTime timestamp;

  const ApiPerformanceMetrics({
    required this.method,
    required this.endpoint,
    required this.duration,
    required this.success,
    required this.correlationId,
    this.statusCode,
    this.error,
    required this.timestamp,
  });

  // Check if performance is slow
  bool get isSlow => duration.inMilliseconds > 1000;

  // Check if performance is critical
  bool get isCritical => duration.inMilliseconds > 5000;

  // Get performance level
  String get performanceLevel {
    if (isCritical) return 'CRITICAL';
    if (isSlow) return 'SLOW';
    return 'NORMAL';
  }
}
```

### Performance Alerts

System akan mengirim alert untuk performance issues:

```dart
class PerformanceAlertManager {
  static void checkAndAlert(ApiPerformanceMetrics metrics) {
    if (metrics.isCritical) {
      _sendCriticalAlert(metrics);
    } else if (metrics.isSlow) {
      _sendSlowAlert(metrics);
    }
  }

  static void _sendCriticalAlert(ApiPerformanceMetrics metrics) {
    // Send alert to monitoring system
    ErrorHandlerUtils.logError(
      'Critical API performance detected',
      correlationId: metrics.correlationId,
      operation: 'PerformanceAlert',
      metadata: {
        'method': metrics.method,
        'endpoint': metrics.endpoint,
        'duration': metrics.duration.inMilliseconds,
        'performanceLevel': metrics.performanceLevel,
      },
    );
  }
}
```

### Performance Dashboard

Metrics dikumpulkan untuk performance dashboard:

```dart
class PerformanceDashboard {
  static List<ApiPerformanceMetrics> getRecentMetrics({Duration? timeRange}) {
    final range = timeRange ?? const Duration(hours: 1);
    final now = DateTime.now();
    final cutoff = now.subtract(range);

    return _metrics.where((m) => m.timestamp.isAfter(cutoff)).toList();
  }

  static Map<String, dynamic> getPerformanceSummary() {
    final recent = getRecentMetrics();

    return {
      'totalRequests': recent.length,
      'successRate': _calculateSuccessRate(recent),
      'averageResponseTime': _calculateAverageResponseTime(recent),
      'slowestEndpoint': _findSlowestEndpoint(recent),
      'mostErrorProneEndpoint': _findMostErrorProneEndpoint(recent),
      'performanceDistribution': _getPerformanceDistribution(recent),
    };
  }
}
```

---

## 🔄 **Retry Mechanisms**

### Exponential Backoff

Implementasi retry dengan exponential backoff:

```dart
class RetryManager {
  static Future<Either<Failure, T>> retryWithBackoff<T>(
    Future<Either<Failure, T>> Function() operation, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
    double backoffMultiplier = 2.0,
    String? operationName,
  }) async {
    var delay = initialDelay;
    var attempt = 0;

    while (attempt <= maxRetries) {
      final result = await operation();

      if (result.isRight()) {
        return result;
      }

      final failure = result.fold((l) => l, (r) => null)!;

      // Check if failure is recoverable
      if (!ErrorHandlerUtils.isRecoverableFailure(failure)) {
        return result;
      }

      attempt++;

      if (attempt <= maxRetries) {
        await Future.delayed(delay);
        delay = Duration(
          milliseconds: (delay.inMilliseconds * backoffMultiplier).round(),
        );

        // Log retry attempt
        ErrorHandlerUtils.logWarning(
          'Retrying operation (attempt $attempt/$maxRetries)',
          correlationId: ErrorHandlerUtils.generateCorrelationId(),
          operation: operationName ?? 'RetryOperation',
          metadata: {
            'delay': delay.inMilliseconds,
            'failure': failure.message,
          },
        );
      }
    }

    return const Left(ServerFailure(message: 'Max retries exceeded'));
  }
}
```

### Retry Configuration

Retry behavior dapat dikonfigurasi per endpoint:

```dart
class RetryConfig {
  final int maxRetries;
  final Duration initialDelay;
  final double backoffMultiplier;
  final List<String> recoverableErrors;

  const RetryConfig({
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.backoffMultiplier = 2.0,
    this.recoverableErrors = const ['TIMEOUT', 'CONNECTION_ERROR'],
  });
}

// Usage
final authRetryConfig = RetryConfig(
  maxRetries: 2,
  initialDelay: const Duration(milliseconds: 500),
  recoverableErrors: ['TIMEOUT'],
);

final dataRetryConfig = RetryConfig(
  maxRetries: 5,
  initialDelay: const Duration(seconds: 2),
  recoverableErrors: ['TIMEOUT', 'CONNECTION_ERROR', 'SERVER_ERROR'],
);
```

---

## 🛡️ **Security Headers**

### Standard Security Headers

Semua API requests menyertakan security headers:

```dart
class SecurityHeaders {
  static Map<String, String> getStandardHeaders({
    String? correlationId,
    String? authToken,
  }) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Client-Version': AppConfig.appVersion,
      'X-Platform': Platform.operatingSystem,
      'X-Device-ID': DeviceInfo.deviceId,
    };

    if (correlationId != null) {
      headers['X-Correlation-ID'] = correlationId!;
    }

    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    return headers;
  }

  static Map<String, String> getAuthenticatedHeaders({
    required String authToken,
    String? correlationId,
  }) {
    return {
      ...getStandardHeaders(correlationId: correlationId),
      'Authorization': 'Bearer $authToken',
    };
  }
}
```

### Request Signing

Untuk endpoint kritis, request dapat di-sign:

```dart
class RequestSigner {
  static String signRequest(
    String method,
    String endpoint,
    Map<String, dynamic> data,
    String secretKey,
  ) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final payload = '$method:$endpoint:$timestamp:${jsonEncode(data)}';

    final hmac = Hmac(sha256, utf8.encode(secretKey));
    final digest = hmac.convert(utf8.encode(payload));

    return base64Encode(digest.bytes);
  }

  static Map<String, String> getSignedHeaders({
    required String method,
    required String endpoint,
    required Map<String, dynamic> data,
    required String secretKey,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final signature = signRequest(method, endpoint, data, secretKey);

    return {
      'X-Timestamp': timestamp,
      'X-Signature': signature,
      'X-Algorithm': 'HMAC-SHA256',
    };
  }
}
```

---

## 📝 **Notes**

### **Current Status (November 15, 2025)**
- ✅ **API Endpoints**: Complete endpoint structure defined
- ✅ **Error Handling**: Centralized error handling with correlation tracking
- ✅ **Performance Monitoring**: Built-in performance tracking for API calls
- ✅ **Retry Mechanisms**: Exponential backoff with configurable retry
- ✅ **Security Headers**: Standard security headers implementation
- ✅ **Request Signing**: HMAC-based request signing for critical endpoints

### **Future Enhancements**
- 🔄 **GraphQL Support**: GraphQL endpoint structure
- 🔄 **WebSocket Support**: Real-time communication patterns
- 🔄 **Caching Strategy**: Intelligent API response caching
- 🔄 **Rate Limiting**: Client-side rate limiting implementation
- 🔄 **Circuit Breaker**: Circuit breaker pattern for resilience

---

**Document End**

**Go Digital, Grow Together.**