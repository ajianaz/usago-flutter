# Better Auth Integration Plan

## 📋 Overview

Backend menggunakan Better Auth dengan email/password authentication dan Bearer token plugin. Perlu menyesuaikan implementasi Flutter auth feature agar compatible dengan Better Auth API.

## 🎯 Integration Requirements

### Backend Configuration (Better Auth)
- ✅ Email & Password authentication enabled
- ✅ Bearer plugin for token-based authentication
- ✅ JWT tokens for API authentication
- ✅ Session management with Bearer tokens

### Frontend Requirements (Flutter)
- 🔄 Adapt existing auth flow to Better Auth API endpoints
- 🔄 Update token management for Bearer tokens
- 🔄 Integrate with Better Auth response format
- 🔄 Update error handling for Better Auth error responses

## 📊 Current Implementation vs Better Auth API

### Current Auth Flow
```dart
// Current implementation
final response = await _dioClient.post('/auth/login', data: {
  'email': email,
  'password': password,
});
// Expected: { user: {...} }
```

### Better Auth API Flow
```typescript
// Better Auth expected flow
const { data, error } = await authClient.signIn.email({
  email,
  password,
});
// Expected: { user: {...}, session: {...} }
// Headers: set-auth-token: "Bearer token"
```

## 🚀 Integration Tasks

### Priority 1: API Endpoint Alignment
- [ ] Update API endpoints to match Better Auth routes
- [ ] Adapt request/response format
- [ ] Update token extraction from headers

### Priority 2: Token Management
- [ ] Implement Bearer token storage
- [ ] Update Dio interceptor for Bearer tokens
- [ ] Add token refresh logic

### Priority 3: Error Handling
- [ ] Update error handling for Better Auth format
- [ ] Add specific error types for Better Auth
- [ ] Update user feedback messages

### Priority 4: Feature Parity
- [ ] Email verification flow
- [ ] Password reset flow
- [ ] Session management
- [ ] User profile management

## 📝 Detailed Task Breakdown

### Task 1: API Endpoint Updates
**File:** `lib/features/auth/data/datasources/auth_remote_datasource_impl.dart`

**Changes Needed:**
```dart
// Update endpoints
@override
Future<UserModel> login({required String email, required String password}) async {
  try {
    final response = await _dioClient.post(
      '/sign-in/email', // Better Auth endpoint
      data: {
        'email': email.trim(),
        'password': password,
      },
    );

    // Extract token from headers
    final authToken = response.headers['set-auth-token'];
    if (authToken != null) {
      await _localDatasource.saveToken(authToken);
    }

    return UserModel.fromJson(response['user']);
  } catch (e) {
    // Handle Better Auth error format
    _handleBetterAuthError(e);
  }
}
```

### Task 2: Bearer Token Integration
**File:** `lib/core/network/dio_client.dart`

**Changes Needed:**
```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Get Bearer token from storage
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('bearer_token');

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
```

### Task 3: Update Auth Repository
**File:** `lib/features/auth/data/repositories/auth_repository_impl.dart`

**Changes Needed:**
```dart
@override
Future<Either<Failure, User>> login({
  required String email,
  required String password,
}) async {
  return _errorHandler.safeExecute(() async {
    _logger.info('Login attempt for email: $email');

    // Call Better Auth endpoint
    final userModel = await _remoteDatasource.login(
      email: email,
      password: password,
    );

    // Cache user and token
    await _localDatasource.saveUser(userModel);
    // Token is saved in datasource implementation

    _logger.info('Login successful for user: ${userModel.id}');

    return userModel.toEntity();
  });
}
```

### Task 4: Update Use Cases
**Files:** `lib/features/auth/domain/usecases/*.dart`

**Changes Needed:**
- Update parameter validation to match Better Auth requirements
- Add Better Auth specific business logic
- Update error handling

### Task 5: Update BLoC Events & States
**Files:** `lib/features/auth/presentation/bloc/*.dart`

**Changes Needed:**
- Add new events for Better Auth specific flows
- Update state handling for Better Auth responses
- Add loading states for async operations

### Task 6: Update UI Components
**Files:** `lib/features/auth/presentation/pages/*.dart`

**Changes Needed:**
- Update form validation to match Better Auth requirements
- Add email verification UI
- Update error message display
- Add loading indicators

## 🔧 Configuration Updates

### pubspec.yaml Dependencies
```yaml
dependencies:
  # Add Better Auth client if available
  # better_auth_client: ^1.0.0

  # Existing dependencies
  flutter_bloc: ^8.1.0
  dio: ^5.0.0
  shared_preferences: ^2.0.0
```

### Environment Configuration
**File:** `lib/core/constants/app_constants.dart`

```dart
class AppConstants {
  // Update API endpoints for Better Auth
  static const String signInEndpoint = '/sign-in/email';
  static const String signUpEndpoint = '/sign-up/email';
  static const String signOutEndpoint = '/sign-out';
  static const String refreshTokenEndpoint = '/refresh-token';

  // Token storage keys
  static const String bearerTokenKey = 'bearer_token';
  static const String sessionDataKey = 'session_data';
}
```

## 🧪 Testing Strategy

### Unit Tests
- [ ] Test Better Auth API integration
- [ ] Test token management
- [ ] Test error handling
- [ ] Test use cases with Better Auth format

### Integration Tests
- [ ] Test complete auth flow
- [ ] Test token refresh
- [ ] Test session management
- [ ] Test error scenarios

### Widget Tests
- [ ] Test login form with Better Auth validation
- [ ] Test registration flow
- [ ] Test error display
- [ ] Test loading states

## 📈 Success Metrics

### Technical Metrics
- [ ] API response time < 2 seconds
- [ ] Token refresh success rate > 99%
- [ ] Error handling coverage > 95%
- [ ] Test coverage > 80%

### User Experience Metrics
- [ ] Login success rate > 95%
- [ ] Form validation feedback < 1 second
- [ ] Error message clarity score > 90%
- [ ] Session persistence > 99%

## 🚨 Risks & Mitigations

### Risk 1: API Compatibility
- **Risk:** Better Auth API format changes
- **Mitigation:** Use version-specific endpoints, implement fallback logic

### Risk 2: Token Management
- **Risk:** Token expiration handling
- **Mitigation:** Implement proactive token refresh, add retry logic

### Risk 3: Error Handling
- **Risk:** Better Auth error format changes
- **Mitigation:** Implement flexible error parsing, add logging

## 📅 Timeline

### Week 1: Foundation
- Day 1-2: API endpoint updates
- Day 3-4: Token management implementation
- Day 5: Basic testing

### Week 2: Integration
- Day 1-2: Repository and use case updates
- Day 3-4: BLoC and UI updates
- Day 5: Integration testing

### Week 3: Polish & Testing
- Day 1-2: Advanced features (email verification, password reset)
- Day 3-4: Comprehensive testing
- Day 5: Documentation and deployment prep

## 🎯 Next Steps

1. **Immediate:** Start with API endpoint alignment
2. **Short-term:** Implement token management
3. **Medium-term:** Complete UI integration
4. **Long-term:** Add advanced features and optimization

---

**Last Updated:** 2025-11-11
**Status:** Planning Phase
**Next Review:** After API endpoint completion