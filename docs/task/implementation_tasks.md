# Implementation Tasks - Better Auth Integration

## 🎯 Phase 1: API Alignment (Days 1-3)

### Task 1.1: Update Auth Remote Datasource
**File:** `lib/features/auth/data/datasources/auth_remote_datasource_impl.dart`
**Priority:** High
**Estimated Time:** 4 hours

**Subtasks:**
- [ ] Update login endpoint to `/sign-in/email`
- [ ] Update register endpoint to `/sign-up/email`
- [ ] Add token extraction from `set-auth-token` header
- [ ] Update error handling for Better Auth format
- [ ] Add logout endpoint to `/sign-out`
- [ ] Add refresh token endpoint to `/refresh-token`

**Implementation Details:**
```dart
// Extract token from response headers
final authToken = response.headers['set-auth-token'];
if (authToken != null) {
  await _localDatasource.saveToken(authToken);
}

// Better Auth error format handling
catch (e) {
  if (e is DioException) {
    final errorData = e.response?.data;
    if (errorData?['code'] == 'INVALID_CREDENTIALS') {
      throw AuthException('Invalid email or password');
    }
  }
}
```

### Task 1.2: Update Auth Local Datasource
**File:** `lib/features/auth/data/datasources/auth_local_datasource_impl.dart`
**Priority:** High
**Estimated Time:** 2 hours

**Subtasks:**
- [ ] Add Bearer token storage method
- [ ] Update token retrieval for Bearer format
- [ ] Add session data storage
- [ ] Update token clearing logic

### Task 1.3: Update Dio Client Interceptor
**File:** `lib/core/network/dio_client.dart`
**Priority:** High
**Estimated Time:** 2 hours

**Subtasks:**
- [ ] Update AuthInterceptor for Bearer tokens
- [ ] Add token refresh logic
- [ ] Update error handling for 401 responses
- [ ] Add retry logic for token expiration

## 🎯 Phase 2: Repository & Use Cases (Days 4-6)

### Task 2.1: Update Auth Repository Implementation
**File:** `lib/features/auth/data/repositories/auth_repository_impl.dart`
**Priority:** High
**Estimated Time:** 3 hours

**Subtasks:**
- [ ] Update login method for Better Auth response
- [ ] Update register method for Better Auth response
- [ ] Add session management
- [ ] Update error handling with Better Auth errors
- [ ] Add token refresh integration

### Task 2.2: Update Login Use Case
**File:** `lib/features/auth/domain/usecases/login_usecase.dart`
**Priority:** Medium
**Estimated Time:** 1 hour

**Subtasks:**
- [ ] Update validation for Better Auth requirements
- [ ] Add Better Auth specific business rules
- [ ] Update error handling

### Task 2.3: Update Register Use Case
**File:** `lib/features/auth/domain/usecases/register_usecase.dart`
**Priority:** Medium
**Estimated Time:** 1 hour

**Subtasks:**
- [ ] Update validation for Better Auth requirements
- [ ] Add email verification handling
- [ ] Update error handling

### Task 2.4: Update Other Use Cases
**Files:** All use case files
**Priority:** Medium
**Estimated Time:** 2 hours

**Subtasks:**
- [ ] Update forgot password use case
- [ ] Update reset password use case
- [ ] Update email verification use case
- [ ] Update profile management use cases

## 🎯 Phase 3: BLoC & State Management (Days 7-9)

### Task 3.1: Update Auth BLoC
**File:** `lib/features/auth/presentation/bloc/auth_bloc.dart`
**Priority:** High
**Estimated Time:** 3 hours

**Subtasks:**
- [ ] Update event handlers for Better Auth responses
- [ ] Add token refresh event handling
- [ ] Update error state management
- [ ] Add session timeout handling

### Task 3.2: Update Auth Events
**File:** `lib/features/auth/presentation/bloc/auth_event.dart`
**Priority:** Medium
**Estimated Time:** 1 hour

**Subtasks:**
- [ ] Add token refresh event
- [ ] Add session timeout event
- [ ] Update existing events for Better Auth

### Task 3.3: Update Auth States
**File:** `lib/features/auth/presentation/bloc/auth_state.dart`
**Priority:** Medium
**Estimated Time:** 1 hour

**Subtasks:**
- [ ] Add token refresh state
- [ ] Add session timeout state
- [ ] Update existing states for Better Auth

## 🎯 Phase 4: UI Components (Days 10-12)

### Task 4.1: Update Login Form
**File:** `lib/features/auth/presentation/widgets/login_form.dart`
**Priority:** High
**Estimated Time:** 2 hours

**Subtasks:**
- [ ] Update validation messages for Better Auth
- [ ] Add loading states for Better Auth operations
- [ ] Update error display for Better Auth format
- [ ] Add forgot password navigation

### Task 4.2: Create Register Form
**File:** `lib/features/auth/presentation/widgets/register_form.dart`
**Priority:** High
**Estimated Time:** 3 hours

**Subtasks:**
- [ ] Create registration form UI
- [ ] Add validation for Better Auth requirements
- [ ] Add email verification handling
- [ ] Add loading states

### Task 4.3: Create Register Page
**File:** `lib/features/auth/presentation/pages/register_page.dart`
**Priority:** High
**Estimated Time:** 2 hours

**Subtasks:**
- [ ] Create registration page
- [ ] Add navigation to login
- [ ] Add success/error handling
- [ ] Add email verification flow

### Task 4.4: Update Login Page
**File:** `lib/features/auth/presentation/pages/login_page.dart`
**Priority:** Medium
**Estimated Time:** 1 hour

**Subtasks:**
- [ ] Add navigation to register
- [ ] Update error handling for Better Auth
- [ ] Add loading states

## 🎯 Phase 5: Advanced Features (Days 13-15)

### Task 5.1: Email Verification Flow
**Files:** New files needed
**Priority:** Medium
**Estimated Time:** 4 hours

**Subtasks:**
- [ ] Create email verification page
- [ ] Create email verification form
- [ ] Add verification BLoC events
- [ ] Add verification states

### Task 5.2: Password Reset Flow
**Files:** New files needed
**Priority:** Medium
**Estimated Time:** 4 hours

**Subtasks:**
- [ ] Create forgot password page
- [ ] Create reset password page
- [ ] Add password reset forms
- [ ] Add reset BLoC events

### Task 5.3: Profile Management
**Files:** New files needed
**Priority:** Low
**Estimated Time:** 3 hours

**Subtasks:**
- [ ] Create profile page
- [ ] Create profile form
- [ ] Add profile update functionality
- [ ] Add profile picture upload

## 🎯 Phase 6: Testing & Documentation (Days 16-18)

### Task 6.1: Unit Tests
**Files:** Test files
**Priority:** High
**Estimated Time:** 6 hours

**Subtasks:**
- [ ] Test datasource implementations
- [ ] Test repository implementations
- [ ] Test use cases
- [ ] Test BLoC functionality

### Task 6.2: Integration Tests
**Files:** Test files
**Priority:** Medium
**Estimated Time:** 4 hours

**Subtasks:**
- [ ] Test complete auth flow
- [ ] Test token refresh
- [ ] Test error scenarios
- [ ] Test session management

### Task 6.3: Documentation
**Files:** Documentation files
**Priority:** Medium
**Estimated Time:** 2 hours

**Subtasks:**
- [ ] Update API documentation
- [ ] Create integration guide
- [ ] Update README
- [ ] Create troubleshooting guide

## 📋 Daily Breakdown

### Day 1
- Morning: Task 1.1 (Part 1 - Login endpoint)
- Afternoon: Task 1.1 (Part 2 - Register endpoint)

### Day 2
- Morning: Task 1.1 (Part 3 - Token extraction)
- Afternoon: Task 1.2 (Local datasource updates)

### Day 3
- Morning: Task 1.3 (Dio interceptor)
- Afternoon: Testing Phase 1

### Day 4
- Morning: Task 2.1 (Repository updates)
- Afternoon: Task 2.2 (Login use case)

### Day 5
- Morning: Task 2.3 (Register use case)
- Afternoon: Task 2.4 (Other use cases)

### Day 6
- Morning: Testing Phase 2
- Afternoon: Bug fixes and refinements

### Day 7
- Morning: Task 3.1 (Auth BLoC updates)
- Afternoon: Task 3.2 (Auth events)

### Day 8
- Morning: Task 3.3 (Auth states)
- Afternoon: Testing Phase 3

### Day 9
- Morning: Task 4.1 (Login form updates)
- Afternoon: Task 4.2 (Register form creation)

### Day 10
- Morning: Task 4.3 (Register page)
- Afternoon: Task 4.4 (Login page updates)

### Day 11
- Morning: Task 5.1 (Email verification)
- Afternoon: Task 5.2 (Password reset)

### Day 12
- Morning: Task 5.3 (Profile management)
- Afternoon: Testing Phase 4

### Day 13-15
- Advanced features implementation
- Bug fixes and optimizations
- Performance improvements

### Day 16-18
- Comprehensive testing
- Documentation
- Deployment preparation

## 🎯 Success Criteria

### Technical Success
- [ ] All API endpoints working with Better Auth
- [ ] Token management functioning correctly
- [ ] Error handling covering all scenarios
- [ ] Test coverage > 80%

### User Experience Success
- [ ] Login flow working smoothly
- [ ] Registration flow complete
- [ ] Error messages clear and helpful
- [ ] Loading states appropriate

### Integration Success
- [ ] Backend integration complete
- [ ] Session management working
- [ ] Token refresh functioning
- [ ] Security measures in place

---

**Total Estimated Time:** 18 days
**Buffer Time:** 3 days (for unexpected issues)
**Target Completion:** 3 weeks from start date