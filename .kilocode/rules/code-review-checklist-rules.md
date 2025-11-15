# Code Review Checklist Rules
# Aturan Checklist Code Review

---

## 📋 **Document Metadata**

| Field | Value |
|-------|-------|
| **Document ID** | RULES-CODE-REVIEW-CHECKLIST |
| **Version** | 1.0 |
| **Status** | Active |
| **Category** | Development Rules |
| **Priority** | High |
| **Created Date** | November 15, 2025 |
| **Last Updated** | November 15, 2025 |
| **Next Review** | November 22, 2025 |
| **Author** | Mobile Development Team |
| **Reviewers** | Tech Lead, Senior Developers |
| **Stakeholders** | Development Team, QA Team, Tech Lead |

---

## 🎯 **Purpose**

Dokumen ini mendefinisikan checklist dan aturan code review yang wajib diikuti dalam pengembangan aplikasi Usago Mobile. Checklist ini memastikan konsistensi kode, kualitas, dan kepatuhan terhadap best practices.

---

## 📚 **Table of Contents**

1. [Code Structure Review](#code-structure-review)
2. [Architecture Review](#architecture-review)
3. [Security Review](#security-review)
4. [Performance Review](#performance-review)
5. [Testing Review](#testing-review)
6. [Documentation Review](#documentation-review)
7. [Flutter Specific Review](#flutter-specific-review)
8. [Code Style Review](#code-style-review)

---

## 🏗️ **Code Structure Review**

### **Checklist 1.1: File Organization**

- [ ] File name mengikuti snake_case convention
- [ ] File path sesuai dengan struktur direktori yang ditentukan
- [ ] Import statements diorganisir dengan benar (dart, flutter, package, local)
- [ ] Tidak ada unused imports
- [ ] File size tidak melebihi 500 lines (kecuali untuk generated files)

```dart
// ✅ BENAR: Organized imports
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/logger.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_form.dart';

// ❌ SALAH: Unorganized imports
import 'package:flutter/material.dart';
import 'dart:convert';
import '../bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import 'dart:async';
import '../widgets/auth_form.dart';
```

### **Checklist 1.2: Class Structure**

- [ ] Class name mengikuti PascalCase convention
- [ ] Setiap class memiliki single responsibility
- [ ] Constructor diorganisir dengan benar
- [ ] Properties diorganisir (public, private, static)
- [ ] Methods diorganisir (public, private, static)
- [ ] Getters dan setters digunakan dengan tepat

```dart
// ✅ BENAR: Well-organized class
class UserAuthenticator {
  // Public properties
  final UserRepository _repository;
  final SecureStorageService _storage;

  // Static properties
  static const Duration _sessionTimeout = Duration(hours: 24);

  // Constructor
  const UserAuthenticator({
    required UserRepository repository,
    required SecureStorageService storage,
  })  : _repository = repository,
        _storage = storage;

  // Public methods
  Future<Either<Failure, User>> authenticate(String email, String password) async {
    // Implementation
  }

  // Private methods
  bool _isValidEmail(String email) {
    // Implementation
  }

  // Static methods
  static bool isPasswordValid(String password) {
    // Implementation
  }

  // Getters
  bool get isSessionValid => _storage.hasValidSession();
}

// ❌ SALAH: Poorly organized class
class userauthenticator {
  var repo;
  var storage;

  userauthenticator(this.repo, this.storage);

  Future authenticate(email, password) {
    // Mixed public/private without organization
  }

  bool _checkEmail(email) {
    // Private method mixed with public
  }

  static checkPass(pass) {
    // Inconsistent naming
  }
}
```

### **Checklist 1.3: Method Organization**

- [ ] Method name mengikuti camelCase convention
- [ ] Method memiliki single responsibility
- [ ] Method length tidak melebihi 50 lines
- [ ] Parameter数量 tidak melebihi 5 parameters
- [ ] Return type didefinisikan dengan jelas
- [ ] Async/await digunakan dengan tepat

```dart
// ✅ BENAR: Well-organized method
Future<Either<Failure, User>> authenticateUser({
  required String email,
  required String password,
  bool rememberMe = false,
}) async {
  // Validate input
  final validationResult = _validateCredentials(email, password);
  if (validationResult.isLeft()) {
    return Left(validationResult.left());
  }

  // Authenticate with repository
  final authResult = await _repository.authenticate(
    email: email,
    password: password,
  );

  // Handle authentication result
  return authResult.fold(
    (failure) => Left(failure),
    (user) async {
      if (rememberMe) {
        await _storage.storeUserSession(user);
      }
      return Right(user);
    },
  );
}

// ❌ SALAH: Poorly organized method
Future authenticate(String email, String password, bool remember, String deviceId, String appVersion, String userAgent, bool biometric, Duration timeout) async {
  // Too many parameters
  // Method too long
  // Multiple responsibilities
  // No clear return type
  // Mixed sync/async operations
}
```

---

## 🏛️ **Architecture Review**

### **Checklist 2.1: Clean Architecture Compliance**

- [ ] Layer separation terjaga (presentation, domain, data)
- [ ] Dependencies mengarah ke dalam (inward dependencies)
- [ ] Use cases digunakan untuk business logic
- [ ] Repositories digunakan untuk data access
- [ ] BLoC/Provider digunakan untuk state management
- [ ] Tidak ada direct dependency antar layer

```dart
// ✅ BENAR: Clean architecture compliance
// Domain Layer
abstract class AuthRepository {
  Future<Either<Failure, User>> authenticate(AuthParams params);
}

// Data Layer
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Either<Failure, User>> authenticate(AuthParams params) async {
    // Implementation
  }
}

// Presentation Layer
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  final AuthenticateUser _authenticateUser;

  AuthBloc(this._authenticateUser) : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      // Implementation
    });
  }
}

// ❌ SALAH: Architecture violation
class AuthBloc {
  final Dio _dio; // Direct dependency on infrastructure

  Future<void> login(String email, String password) async {
    // Business logic in presentation layer
    final response = await _dio.post('/login', data: {
      'email': email,
      'password': password,
    });
    // Direct API call without repository
  }
}
```

### **Checklist 2.2: Dependency Injection**

- [ ] Dependency injection pattern digunakan
- [ ] Inversion of control diimplementasikan
- [ ] Service locator tidak digunakan secara langsung
- [ ] Dependencies di-inject melalui constructor
- [ ] Abstract classes digunakan untuk dependencies

```dart
// ✅ BENAR: Proper dependency injection
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  final AuthenticateUser _authenticateUser;
  final GetUserSession _getUserSession;

  const AuthBloc({
    required AuthenticateUser authenticateUser,
    required GetUserSession getUserSession,
  })  : _authenticateUser = authenticateUser,
        _getUserSession = getUserSession,
        super(const AuthState.initial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    // Implementation
  }
}

// ❌ SALAH: Service locator anti-pattern
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState.initial());

  void login(String email, String password) {
    final authenticateUser = getIt<AuthenticateUser>(); // Service locator
    // Implementation
  }
}
```

### **Checklist 2.3: SOLID Principles**

- [ ] **S**ingle Responsibility: Setiap class memiliki satu tanggung jawab
- [ ] **O**pen/Closed: Class terbuka untuk ekstensi, tertutup untuk modifikasi
- [ ] **L**iskov Substitution: Subclass dapat menggantikan parent class
- [ ] **I**nterface Segregation: Interface tidak terlalu besar
- [ ] **D**ependency Inversion: Dependencies pada abstraksi, bukan konkrit

```dart
// ✅ BENAR: SOLID principles
// Single Responsibility
class EmailValidator {
  bool isValid(String email) => _emailRegex.hasMatch(email);
}

class PasswordValidator {
  bool isValid(String password) => password.length >= 8;
}

// Open/Closed
abstract class NotificationService {
  void send(String message);
}

class EmailNotificationService implements NotificationService {
  @override
  void send(String message) => _sendEmail(message);
}

class PushNotificationService implements NotificationService {
  @override
  void send(String message) => _sendPush(message);
}

// Interface Segregation
abstract class ReadableRepository<T> {
  Future<T?> read(String id);
  Future<List<T>> readAll();
}

abstract class WritableRepository<T> {
  Future<void> create(T item);
  Future<void> update(String id, T item);
  Future<void> delete(String id);
}

// ❌ SALAH: SOLID violations
class UserService {
  // Multiple responsibilities
  void validateUser(User user) {}
  void saveUser(User user) {}
  void sendEmail(User user) {}
  void logActivity(User user) {}
  void generateReport(User user) {}
}
```

---

## 🔐 **Security Review**

### **Checklist 3.1: Data Protection**

- [ ] Sensitive data tidak di-log
- [ ] Sensitive data dienkripsi sebelum disimpan
- [ ] Input validation diimplementasikan
- [ ] SQL injection prevention
- [ ] XSS prevention
- [ ] Hardcoded secrets tidak ada

```dart
// ✅ BENAR: Secure data handling
class SecureUserRepository {
  final EnhancedSecureStorageService _secureStorage;
  final EncryptionService _encryption;

  Future<void> saveUserCredentials(UserCredentials credentials) async {
    // Encrypt sensitive data
    final encryptedPassword = await _encryption.encrypt(credentials.password);

    // Store securely
    await _secureStorage.storeSecureData(
      'user_credentials',
      jsonEncode({
        'email': credentials.email,
        'password': encryptedPassword,
      }),
    );

    // Log without sensitive data
    logger.info('User credentials saved for ${credentials.email}');
  }
}

// ❌ SALAH: Insecure data handling
class InsecureUserRepository {
  Future<void> saveUserCredentials(UserCredentials credentials) async {
    // Store without encryption
    await _preferences.setString('user_password', credentials.password);

    // Log sensitive data
    logger.info('Password saved: ${credentials.password}'); // Security risk!
  }
}
```

### **Checklist 3.2: Authentication & Authorization**

- [ ] Token management yang aman
- [ ] Session management yang tepat
- [ ] Permission checking diimplementasikan
- [ ] Rate limiting untuk authentication
- [ ] Secure logout implementation

```dart
// ✅ BENAR: Secure authentication
class SecureAuthService {
  final TokenManager _tokenManager;
  final SecureStorageService _storage;

  Future<Either<Failure, User>> authenticate(String email, String password) async {
    // Rate limiting
    if (await _isRateLimited(email)) {
      return const Left(AuthFailure.tooManyAttempts());
    }

    // Authenticate
    final result = await _authenticateUser(email, password);

    return result.fold(
      (failure) => Left(failure),
      (user) async {
        // Store tokens securely
        await _tokenManager.storeTokens(user.tokens);
        return Right(user);
      },
    );
  }
}

// ❌ SALAH: Insecure authentication
class InsecureAuthService {
  Future<User> authenticate(String email, String password) async {
    // No rate limiting
    final response = await _dio.post('/login', data: {
      'email': email,
      'password': password,
    });

    // Store tokens in plain storage
    await _preferences.setString('access_token', response.data['token']);

    return User.fromJson(response.data['user']);
  }
}
```

---

## ⚡ **Performance Review**

### **Checklist 4.1: Memory Management**

- [ ] Memory leaks dihindari
- [ ] Proper disposal of resources
- [ ] Efficient data structures
- [ ] Image caching yang tepat
- [ ] Stream subscriptions di-cancel dengan benar

```dart
// ✅ BENAR: Proper memory management
class UserProfileWidget extends StatefulWidget {
  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  StreamSubscription<User>? _userSubscription;

  @override
  void initState() {
    super.initState();
    _userSubscription = _userService.userStream.listen((user) {
      setState(() => _user = user);
    });
  }

  @override
  void dispose() {
    _userSubscription?.cancel(); // Prevent memory leak
    super.dispose();
  }
}

// ❌ SALAH: Memory leak
class UserProfileWidget extends StatefulWidget {
  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  @override
  void initState() {
    super.initState();
    _userService.userStream.listen((user) {
      setState(() => _user = user);
    }); // Stream subscription not cancelled!
  }

  @override
  void dispose() {
    super.dispose();
    // Missing stream subscription cancellation
  }
}
```

### **Checklist 4.2: Algorithm Efficiency**

- [ ] Efficient algorithms digunakan
- [ ] Time complexity dipertimbangkan
- [ ] Space complexity dipertimbangkan
- [ ] Caching diimplementasikan jika perlu
- [ ] Lazy loading untuk large datasets

```dart
// ✅ BENAR: Efficient algorithm
class EfficientSearchService {
  final List<User> _users;
  final Map<String, List<User>> _searchIndex = {};

  EfficientSearchService(this._users) {
    _buildSearchIndex();
  }

  void _buildSearchIndex() {
    for (final user in _users) {
      final keywords = _extractKeywords(user.name);
      for (final keyword in keywords) {
        _searchIndex.putIfAbsent(keyword, () => []).add(user);
      }
    }
  }

  List<User> search(String query) {
    final keywords = _extractKeywords(query);
    if (keywords.isEmpty) return [];

    final results = _searchIndex[keywords.first] ?? [];
    return results.where((user) =>
      keywords.every((keyword) => user.name.toLowerCase().contains(keyword))
    ).toList();
  }
}

// ❌ SALAH: Inefficient algorithm
class InefficientSearchService {
  final List<User> _users;

  InefficientSearchService(this._users);

  List<User> search(String query) {
    final results = <User>[];

    // O(n*m) complexity - inefficient
    for (final user in _users) {
      if (user.name.toLowerCase().contains(query.toLowerCase())) {
        results.add(user);
      }
    }

    return results;
  }
}
```

---

## 🧪 **Testing Review**

### **Checklist 5.1: Test Coverage**

- [ ] Unit tests untuk business logic
- [ ] Widget tests untuk UI components
- [ ] Integration tests untuk user flows
- [ ] Test coverage minimal 80%
- [ ] Edge cases ter-cover
- [ ] Error scenarios ter-test

```dart
// ✅ BENAR: Comprehensive test
void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockAuthenticateUser mockAuthenticateUser;

    setUp(() {
      mockAuthenticateUser = MockAuthenticateUser();
      authBloc = AuthBloc(mockAuthenticateUser);
    });

    tearDown(() {
      authBloc.close();
    });

    test('should emit AuthState.loading when AuthenticateEvent is added', () async {
      // Arrange
      when(mockAuthenticateUser.call(any))
          .thenAnswer((_) async => const Right(testUser));

      // Act
      authBloc.add(const AuthenticateEvent(email: 'test@test.com', password: 'password'));

      // Assert
      expectLater(authBloc.stream, emitsInOrder([
        const AuthState.loading(),
        const AuthState.loaded(testUser),
      ]));
    });

    test('should emit AuthState.error when authentication fails', () async {
      // Arrange
      when(mockAuthenticateUser.call(any))
          .thenAnswer((_) async => const Left(AuthFailure.invalidCredentials()));

      // Act
      authBloc.add(const AuthenticateEvent(email: 'test@test.com', password: 'wrong'));

      // Assert
      expectLater(authBloc.stream, emitsInOrder([
        const AuthState.loading(),
        const AuthState.error(AuthFailure.invalidCredentials()),
      ]));
    });
  });
}

// ❌ SALAH: Insufficient test
void main() {
  test('auth test', () {
    // No setup
    // No arrange
    // No act
    // No assert
    print('test passed'); // Always passes
  });
}
```

### **Checklist 5.2: Test Quality**

- [ ] Test names descriptive
- [ ] AAA pattern (Arrange, Act, Assert) digunakan
- [ ] Mock objects digunakan dengan tepat
- [ ] Test isolation terjaga
- [ ] Test data terpisah dari production data

```dart
// ✅ BENAR: Quality test
void main() {
  group('PasswordValidator', () {
    test('should return false when password is shorter than 8 characters', () {
      // Arrange
      const password = '123';
      final validator = PasswordValidator();

      // Act
      final result = validator.isValid(password);

      // Assert
      expect(result, isFalse);
    });

    test('should return true when password meets all requirements', () {
      // Arrange
      const password = 'ValidPass123!';
      final validator = PasswordValidator();

      // Act
      final result = validator.isValid(password);

      // Assert
      expect(result, isTrue);
    });
  });
}

// ❌ SALAH: Poor quality test
void main() {
  test('password', () {
    final validator = PasswordValidator();
    expect(validator.isValid('123'), false);
    expect(validator.isValid('ValidPass123!'), true);
    // Multiple assertions in one test
    // No descriptive name
    // No AAA pattern
  });
}
```

---

## 📝 **Documentation Review**

### **Checklist 6.1: Code Documentation**

- [ ] Class-level documentation ada
- [ ] Method-level documentation ada
- [ ] Complex logic dijelaskan
- [ ] Public API documented
- [ ] Usage examples disediakan
- [ ] TODO/FIXME comments justified

```dart
// ✅ BENAR: Well-documented code
/// Service responsible for user authentication operations.
///
/// This service handles user login, logout, and session management.
/// It uses secure storage for token management and implements
/// rate limiting to prevent brute force attacks.
///
/// Example:
/// ```dart
/// final authService = AuthService();
/// final result = await authService.authenticate('user@example.com', 'password');
/// ```
class AuthService {
  final UserRepository _repository;
  final SecureStorageService _storage;

  /// Creates an [AuthService] instance.
  ///
  /// [repository] is used for user data operations.
  /// [storage] is used for secure token storage.
  const AuthService({
    required UserRepository repository,
    required SecureStorageService storage,
  })  : _repository = repository,
        _storage = storage;

  /// Authenticates a user with email and password.
  ///
  /// Returns [Right<User>] on successful authentication,
  /// or [Left<AuthFailure>] on failure.
  ///
  /// Parameters:
  /// - [email] User's email address
  /// - [password] User's password
  ///
  /// Throws:
  /// - [NetworkException] if network error occurs
  /// - [ServerException] if server error occurs
  Future<Either<AuthFailure, User>> authenticate(
    String email,
    String password,
  ) async {
    // Implementation with inline comments for complex logic
    final sanitizedEmail = _sanitizeEmail(email);

    // Rate limiting check to prevent brute force
    if (await _isRateLimited(sanitizedEmail)) {
      return const Left(AuthFailure.tooManyAttempts());
    }

    // Authentication logic
    final result = await _repository.authenticate(sanitizedEmail, password);

    return result.fold(
      (failure) => Left(failure),
      (user) async {
        // Store session securely
        await _storage.storeSession(user.session);
        return Right(user);
      },
    );
  }
}

// ❌ SALAH: Poorly documented code
class AuthService {
  final UserRepository _repo;
  final SecureStorageService _store;

  AuthService(this._repo, this._store);

  Future<Either<AuthFailure, User>> auth(String email, String pass) async {
    // No documentation
    final result = await _repo.auth(email, pass);
    return result.fold(
      (failure) => Left(failure),
      (user) async {
        await _store.store(user.session);
        return Right(user);
      },
    );
  }
}
```

---

## 🎨 **Flutter Specific Review**

### **Checklist 7.1: Widget Implementation**

- [ ] StatelessWidget vs StatefulWidget digunakan dengan tepat
- [ ] Keys digunakan dengan benar
- [ ] Build method dioptimasi
- [ ] Const constructors digunakan
- [ ] Widget lifecycle di-manage dengan benar

```dart
// ✅ BENAR: Proper widget implementation
class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;

  const UserCard({
    Key? key,
    required this.user,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.avatarUrl),
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

// ❌ SALAH: Poor widget implementation
class UserCard extends StatelessWidget {
  User user; // Should be final

  UserCard({this.user}); // Missing key parameter

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.avatarUrl),
        ),
        title: Text(user.name), // No const constructor
        subtitle: Text(user.email),
        trailing: Icon(Icons.arrow_forward_ios), // No const constructor
        onTap: () {
          // Inline function that creates new function on every build
          print('Tapped on ${user.name}');
        },
      ),
    );
  }
}
```

### **Checklist 7.2: State Management**

- [ ] BLoC pattern digunakan dengan benar
- [ ] State classes immutable
- [ ] Event classes immutable
- [ ] Proper state transitions
- [ ] Error handling dalam BLoC

```dart
// ✅ BENAR: Proper BLoC implementation
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthenticateEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthenticateEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthLoaded extends AuthState {
  final User user;

  const AuthLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class AuthError extends AuthState {
  final AuthFailure failure;

  const AuthError(this.failure);

  @override
  List<Object> get props => [failure];
}

// ❌ SALAH: Poor BLoC implementation
class AuthEvent {
  String email;
  String password;

  AuthEvent(this.email, this.password);
}

class AuthState {
  User? user;
  bool isLoading;
  String? error;

  AuthState({this.user, this.isLoading = false, this.error});
}
```

---

## 🎨 **Code Style Review**

### **Checklist 8.1: Dart Style Guide**

- [ ] Mengikuti official Dart style guide
- [ ] Consistent indentation (2 spaces)
- [ ] Line length tidak melebihi 80 characters
- [ ] Proper naming conventions
- [ ] Consistent spacing
- [ ] Trailing commas digunakan

```dart
// ✅ BENAR: Proper Dart style
class User {
  final String name;
  final String email;
  final int age;

  const User({
    required this.name,
    required this.email,
    required this.age,
  });

  User copyWith({
    String? name,
    String? email,
    int? age,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is User &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            email == other.email &&
            age == other.age;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ age.hashCode;

  @override
  String toString() => 'User(name: $name, email: $email, age: $age)';
}

// ❌ SALAH: Poor Dart style
class user{
  String name;
  String email;
  int age;

  user({required this.name,required this.email,required this.age});

  user copyWith({String? name,String? email,int? age}){
    return user(name:name??this.name,email:email??this.email,age:age??this.age);
  }
}
```

### **Checklist 8.2: Linting Rules**

- [ ] Tidak ada linting warnings
- [ ] Prefer const constructors
- [ ] Prefer final fields
- [ ] Avoid unnecessary imports
- [ ] Use proper type annotations
- [ ] Avoid print statements in production

```dart
// ✅ BENAR: Linting compliant
class UserRepository {
  final Dio _dio;

  const UserRepository(this._dio);

  Future<Either<Failure, User>> getUser(String id) async {
    try {
      final response = await _dio.get('/users/$id');
      final user = User.fromJson(response.data);
      return Right(user);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Unknown error'));
    }
  }
}

// ❌ SALAH: Linting violations
class UserRepository {
  Dio _dio; // Should be final

  UserRepository(this._dio); // Missing const

  Future<Either<Failure, User>> getUser(String id) async {
    try {
      final response = await _dio.get('/users/$id');
      final user = User.fromJson(response.data);
      return Right(user);
    } catch (e) { // Too broad catch
      print('Error: $e'); // Print statement
      return Left(ServerFailure('Unknown error'));
    }
  }
}
```

---

## ✅ **Final Review Checklist**

### **Before Merge**
- [ ] All checklist items completed
- [ ] No TODO/FIXME comments without justification
- [ ] No debug code in production
- [ ] No hardcoded values
- [ ] All tests passing
- [ ] Code coverage ≥ 80%
- [ ] Performance benchmarks met
- [ ] Security review passed
- [ ] Documentation updated

### **Review Process**
1. **Self-Review**: Developer reviews own code
2. **Peer Review**: Another developer reviews code
3. **Tech Lead Review**: Tech lead gives final approval
4. **Automated Checks**: CI/CD pipeline validates code
5. **Merge**: Code merged to main branch

---

## 🔗 **Related Documentation**

- [`../flutter-development-guidelines.md`](./flutter-development-guidelines.md) - Flutter development guidelines
- [`../security-implementation-rules.md`](./security-implementation-rules.md) - Security implementation rules
- [`../performance-monitoring-rules.md`](./performance-monitoring-rules.md) - Performance monitoring rules
- [`../testing-strategies-rules.md`](./testing-strategies-rules.md) - Testing strategies rules
- [`../api-integration-patterns.md`](./api-integration-patterns.md) - API integration patterns

---

## 📞 **Contact Information**

### **Development Team**

| Role | Contact | Response Time |
|-------|----------|---------------|
| **Code Review** | dev-team@usago.id | 4 hours |
| **Architecture Review** | tech-lead@usago.id | 2 hours |
| **Security Review** | security@usago.id | 1 hour |
| **Performance Review** | performance@usago.id | 2 hours |

---

## 📝 **Notes**

### **Review Tools**
- GitHub Pull Request reviews
- SonarQube for code quality
- Codacy for automated code review
- Flutter analyze for static analysis
- Test coverage reports

### **Review Metrics**
- Code review turnaround time
- Code review approval rate
- Code quality score
- Test coverage percentage
- Security vulnerabilities found

---

**Document End**

**Go Digital, Grow Together.**