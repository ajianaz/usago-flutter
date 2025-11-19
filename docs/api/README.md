# API Documentation

## 📋 **Overview**

Folder ini berisi dokumentasi terkait API endpoints, struktur data, dan integrasi backend untuk aplikasi mobile Usago.

---

## 📁 **Documents**

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
**Priority**: High
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

**Critical**: [API Endpoints Structure](./01-API-Endpoints-Structure.md) → [Brand Branch Focused Implementation](./03-Brand-Branch-Focused-Implementation.md) → [Brand Branch Implementation Guide](./04-Brand-Branch-Implementation-Guide.md)

**Important**: [Mobile Flow Context Management](./02-Mobile-Flow-Context-Management.md) → [Wallet API Preparation](./05-Wallet-API-Preparation.md)

---

## 📊 **API Status**

| Category | Endpoints | Status | Documentation |
|----------|-----------|---------|----------------|
| Authentication | 10 | ✅ Complete | [API Endpoints](./01-API-Endpoints-Structure.md#-authentication-endpoints) |
| Brand Management | 12 | ✅ Complete | [API Endpoints](./01-API-Endpoints-Structure.md#-brand-management-endpoints) |
| Branch Management | 15 | ✅ Complete | [API Endpoints](./01-API-Endpoints-Structure.md#-branch-management-endpoints) |
| Wallet Management | 18 | 🔄 In Progress | [Wallet API](./05-Wallet-API-Preparation.md) |
| Invoice Management | 12 | 🔄 In Progress | [API Endpoints](./01-API-Endpoints-Structure.md#-invoice-management-endpoints) |

---

## 🔧 **Implementation Guidelines**

### Base Configuration
```dart
// Import dari API Endpoints Structure
import '../constants/api_constants.dart';
import '../constants/auth_endpoints.dart';
import '../constants/brand_endpoints.dart';
```

### Usage Examples
```dart
// Authentication
final response = await dioClient.post(AuthEndpoints.signIn, data: {...});

// Brand Management
final brands = await dioClient.get(BrandEndpoints.getUserBrands);

// Wallet Operations
final balance = await dioClient.get(WalletEndpoints.getWalletBalance);
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

**Last Updated**: November 19, 2025
**Next Review**: November 26, 2025