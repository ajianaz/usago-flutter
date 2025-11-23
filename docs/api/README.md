# API Documentation

## 📋 **Overview**

Folder ini berisi dokumentasi terkait API endpoints, struktur data, dan integrasi backend untuk aplikasi mobile Usago.

---

## 📁 **Documents**

### 🔗 [Mobile API Documentation](./01-Mobile-API-Documentation.md)
Dokumentasi lengkap API endpoints yang sudah diimplementasikan untuk mobile apps:
- Authentication dengan Better Auth (✅ IMPLEMENTED)
- Brand Management lengkap (✅ IMPLEMENTED)
- Token Management system (✅ IMPLEMENTED)
- Context Management (✅ IMPLEMENTED)
- Error handling komprehensif (✅ IMPLEMENTED)

**Status**: ✅ **COMPLETE & TESTED**
**Priority**: High
**Last Updated**: November 23, 2025

### 🔑 [Token Management Guide](./02-Token-Management-Guide.md)
Panduan lengkap implementasi Token Management untuk mobile apps:
- Secure token storage dengan Flutter Secure Storage
- Automatic token refresh dengan queue management
- Device fingerprinting untuk enhanced security
- Token validation dan error handling
- UI components untuk token management

**Status**: ✅ **COMPLETE & TESTED**
**Priority**: High
**Last Updated**: November 23, 2025

### 🔗 [API Endpoints Structure](./01-API-Endpoints-Structure.md)
Struktur lengkap API endpoints untuk mobile apps:
- Base configuration
- Authentication endpoints
- Brand management endpoints
- Branch management endpoints
- Wallet management endpoints
- Invoice management endpoints
- Customer management endpoints
- Product management endpoints
- Analytics endpoints
- Reporting endpoints

**Status**: Ready to Implement
**Priority**: Medium
**Last Updated**: November 13, 2025

---

### 📱 [Mobile Flow Context Management](./02-Mobile-Flow-Context-Management.md)
Manajemen konteks dan flow di aplikasi mobile:
- Context switching strategy
- State management patterns
- User session handling
- Brand/branch context

**Status**: In Progress
**Priority**: Medium
**Last Updated**: November 13, 2025

---

### 🏢 [Brand Branch Focused Implementation](./03-Brand-Branch-Focused-Implementation.md)
Implementasi fokus pada Brand dan Branch management:
- Multi-brand architecture
- Branch hierarchy
- User permissions
- Role-based access

**Status**: Ready to Implement
**Priority**: High
**Last Updated**: November 13, 2025

---

### 📖 [Brand Branch Implementation Guide](./04-Brand-Branch-Implementation-Guide.md)
Panduan lengkap implementasi Brand dan Branch:
- Step-by-step implementation
- Code examples
- Best practices
- Common pitfalls

**Status**: Ready to Implement
**Priority**: High
**Last Updated**: November 13, 2025

---

### 💰 [Wallet API Preparation](./05-Wallet-API-Preparation.md)
Persiapan API untuk fitur Wallet:
- Wallet types and structure
- Transaction handling
- Balance management
- Security considerations

**Status**: In Progress
**Priority**: Medium
**Last Updated**: November 13, 2025

---

## 🎯 **Quick Navigation**

### Berdasarkan Fitur

**Authentication & Users**: [API Endpoints Structure](./01-API-Endpoints-Structure.md#-authentication-endpoints)

**Brand Management**: [Brand Branch Focused Implementation](./03-Brand-Branch-Focused-Implementation.md) → [Brand Branch Implementation Guide](./04-Brand-Branch-Implementation-Guide.md)

**Wallet & Transactions**: [Wallet API Preparation](./05-Wallet-API-Preparation.md) → [API Endpoints Structure](./01-API-Endpoints-Structure.md#-wallet-management-endpoints)

**Analytics & Reporting**: [API Endpoints Structure](./01-API-Endpoints-Structure.md#-analytics-endpoints) → [API Endpoints Structure](./01-API-Endpoints-Structure.md#-reporting-endpoints)

### Berdasarkan Priority

**Critical**: [Mobile API Documentation](./01-Mobile-API-Documentation.md) → [Token Management Guide](./02-Token-Management-Guide.md) → [Brand Branch Focused Implementation](./03-Brand-Branch-Focused-Implementation.md)

**Important**: [Mobile Flow Context Management](./02-Mobile-Flow-Context-Management.md) → [Brand Branch Implementation Guide](./04-Brand-Branch-Implementation-Guide.md)

**Future**: [API Endpoints Structure](./01-API-Endpoints-Structure.md) → [Wallet API Preparation](./05-Wallet-API-Preparation.md)

---

## 📊 **API Status**

| Category | Endpoints | Status | Documentation |
|----------|-----------|---------|----------------|
| Authentication | 8 | ✅ **IMPLEMENTED & TESTED** | [Mobile API Documentation](./01-Mobile-API-Documentation.md#-authentication-api-implemented--tested) |
| Token Management | 6 | ✅ **IMPLEMENTED & TESTED** | [Token Management Guide](./02-Token-Management-Guide.md) |
| Brand Management | 12 | ✅ **IMPLEMENTED & TESTED** | [Mobile API Documentation](./01-Mobile-API-Documentation.md#-brand-management-api-implemented--tested) |
| Branch Management | 8 | 🔄 **IN PROGRESS** | [Mobile API Documentation](./01-Mobile-API-Documentation.md#-branch-management-api-partially-implemented) |
| Wallet Management | 18 | 📋 **PLANNED** | [Wallet API](./05-Wallet-API-Preparation.md) |
| Invoice Management | 12 | 📋 **PLANNED** | [API Endpoints](./01-API-Endpoints-Structure.md#-invoice-management-endpoints) |

---

## 🔧 **Implementation Guidelines**

### Base Configuration
```dart
// Import dari Mobile API Documentation
import '../constants/api_constants.dart';
import '../constants/auth_endpoints.dart';
import '../constants/brand_endpoints.dart';

// Token Management
import '../core/services/token_manager.dart';
import '../core/services/device_info_service.dart';
```

### Usage Examples (IMPLEMENTED)
```dart
// Authentication dengan Better Auth
final response = await dioClient.post(AuthEndpoints.signIn, data: {
  'email': 'user@example.com',
  'password': 'password123'
});

// Brand Management dengan context headers
final brands = await secureApiClient.get(BrandEndpoints.getUserBrands);

// Token Management
await tokenManager.refreshToken();
final deviceFingerprint = await deviceInfoService.generateDeviceFingerprint();

// Secure API Client dengan automatic token refresh
final apiClient = SecureApiClient(dio, tokenManager, contextManager);
final userData = await apiClient.get('/auth/me');
```

---

## 🔄 **Related Documentation**

- [Architecture Documentation](../architecture/) - Clean Architecture implementation
- [Development Guides](../development/) - Implementation patterns
- [Task Reports](../task/) - Implementation analysis

---

## 📞 **Contact**

| Issue | Contact | Response Time |
|-------|----------|---------------|
| **API Design Question** | Backend Lead | 2 hours |
| **Endpoint Addition** | API Team | 1 week |
| **Integration Issue** | Mobile Team | 4 hours |
| **Documentation Update** | API Documentation | 1 business day |

---

## 📝 **API Versioning**

- **Current Version**: v1.0
- **Base URL**: `http://localhost:3000/api/v1`
- **Authentication**: Bearer Token
- **Content-Type**: `application/json`

---

**Last Updated**: November 23, 2025
**Next Review**: November 30, 2025