# Flutter Feature-Based Monolithic Architecture
## Implementation Guide & Patterns

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Complete Feature Implementation Walkthrough](#complete-feature-implementation-walkthrough)
3. [Dependency Injection Patterns](#dependency-injection-patterns)
4. [Common Patterns & Solutions](#common-patterns--solutions)
5. [Folder Organization Commands](#folder-organization-commands)
6. [Troubleshooting Common Issues](#troubleshooting-common-issues)
7. [Performance Optimization](#performance-optimization)
8. [Team Collaboration Guidelines](#team-collaboration-guidelines)

---

## Getting Started

### Project Initialization

```bash
# 1. Create new Flutter project
flutter create my_app
cd my_app

# 2. Add required dependencies
flutter pub add flutter_bloc bloc equatable auto_route get_it fpdart dio hive logger shared_preferences

# 3. Add dev dependencies
flutter pub add --dev build_runner auto_route_generator injectable_generator bloc_test mocktail

# 4. Create folder structure
mkdir -p lib/{app,core/{constants,errors,extensions,network,utils,di},shared/{widgets,themes,utils},features}

# 5. Create initial features
mkdir -p lib/features/{auth,profile,payment}/{data,domain,presentation,di}
mkdir -p lib/features/{auth,profile,payment}/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
```

### pubspec.yaml Template

```yaml
name: my_app
description: Feature-based scalable Flutter application
publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.0
  bloc: ^8.1.0
  equatable: ^2.0.0
  
  # Navigation
  auto_route: ^7.0.0
  
  # Dependency Injection
  get_it: ^7.6.0
  injectable: ^2.3.0
  
  # Network
  dio: ^5.0.0
  
  # Storage
  shared_preferences: ^2.0.0
  hive: ^2.2.0
  hive_flutter: ^1.1.0
  
  # Utilities
  logger: ^2.0.0
  fpdart: ^0.3.0
  equatable: ^2.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  
  # Code Generation
  build_runner: ^2.4.0
  auto_route_generator: ^7.0.0
  injectable_generator: ^2.3.0
  
  # Testing
  bloc_test: ^9.1.0
  mocktail: ^1.0.0
```

---

## Complete Feature Implementation Walkthrough

### Feature: Authentication (Complete Working Example)

#### Step 1: Domain Layer - Entities

```dart
// lib/features/auth/domain/entities/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profilePicture;
  final bool isEmailVerified;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.profilePicture,
    required this.isEmailVerified,
    required this.createdAt,
  });

  /// Returns a copy of this User with modified fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profilePicture,
    bool? isEmailVerified,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    profilePicture,
    isEmailVerified,
    createdAt,
  ];
}
```

#### Step 2: Domain Layer - Repository Interface

```dart
// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user.dart';

abstract interface class AuthRepository {
  /// Login with email and password
  /// Returns [User] on success or [Failure] on error
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Register new user
  /// Returns [User] on success or [Failure] on error
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  });

  /// Logout current user
  /// Returns [void] on success or [Failure] on error
  Future<Either<Failure, void>> logout();

  /// Check if user is authenticated
  /// Returns cached [User] if exists, null if not
  Future<Either<Failure, User?>> checkAuthStatus();

  /// Refresh authentication token
  /// Used when token is expired
  Future<Either<Failure, User>> refreshToken();
}
```

#### Step 3: Domain Layer - Use Cases

```dart
// lib/features/auth/domain/usecases/login_usecase.dart
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Parameters for login usecase
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Login use case - handles business logic for user login
class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase({required this.repository});

  /// Execute login with email and password
  /// 
  /// Validates input before calling repository
  /// Returns Either<Failure, User>
  Future<Either<Failure, User>> call(LoginParams params) async {
    // Business logic validation
    if (params.email.isEmpty) {
      return Left(ValidationFailure(message: 'Email cannot be empty'));
    }
    if (!_isValidEmail(params.email)) {
      return Left(ValidationFailure(message: 'Invalid email format'));
    }
    if (params.password.isEmpty) {
      return Left(ValidationFailure(message: 'Password cannot be empty'));
    }
    if (params.password.length < 6) {
      return Left(ValidationFailure(message: 'Password must be at least 6 characters'));
    }

    // Delegate to repository
    return repository.login(
      email: params.email,
      password: params.password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  }
}

// lib/features/auth/domain/usecases/logout_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase({required this.repository});

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}

// lib/features/auth/domain/usecases/check_auth_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class CheckAuthUsecase {
  final AuthRepository repository;

  CheckAuthUsecase({required this.repository});

  Future<Either<Failure, User?>> call() {
    return repository.checkAuthStatus();
  }
}
```

#### Step 4: Data Layer - Models

```dart
// lib/features/auth/data/models/user_model.dart
import '../../domain/entities/user.dart';

/// User Data Transfer Object
/// Used for API serialization/deserialization
class UserModel extends User {
  const UserModel({
    required String id,
    required String email,
    required String name,
    String? profilePicture,
    required bool isEmailVerified,
    required DateTime createdAt,
  }) : super(
    id: id,
    email: email,
    name: name,
    profilePicture: profilePicture,
    isEmailVerified: isEmailVerified,
    createdAt: createdAt,
  );

  /// Create from JSON API response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profilePicture: json['profilePicture'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profilePicture': profilePicture,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
```

#### Step 5: Data Layer - Datasources

```dart
// lib/features/auth/data/datasources/auth_remote_datasource.dart
import '../models/user_model.dart';

/// Abstract remote datasource
/// Defines contract for remote API calls
abstract interface class AuthRemoteDatasource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });

  Future<void> logout();

  Future<UserModel> refreshToken();
}

// lib/features/auth/data/datasources/auth_remote_datasource_impl.dart
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

/// Remote datasource implementation
/// Handles all API calls
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _dioClient;

  AuthRemoteDatasourceImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return UserModel.fromJson(response['user']);
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.message}');
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _dioClient.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );
      return UserModel.fromJson(response['user']);
    } on DioException catch (e) {
      throw Exception('Registration failed: ${e.message}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.post('/auth/logout');
    } on DioException catch (e) {
      throw Exception('Logout failed: ${e.message}');
    }
  }

  @override
  Future<UserModel> refreshToken() async {
    try {
      final response = await _dioClient.post('/auth/refresh-token');
      return UserModel.fromJson(response['user']);
    } on DioException catch (e) {
      throw Exception('Token refresh failed: ${e.message}');
    }
  }
}

// lib/features/auth/data/datasources/auth_local_datasource.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

/// Abstract local datasource
/// Defines contract for local storage
abstract interface class AuthLocalDatasource {
  Future<void> saveUser(UserModel user);

  Future<UserModel?> getUser();

  Future<void> clearUser();

  Future<void> saveToken(String token);

  Future<String?> getToken();
}

// lib/features/auth/data/datasources/auth_local_datasource_impl.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  static const String _userKey = 'cached_user';
  static const String _tokenKey = 'auth_token';

  final SharedPreferences _prefs;

  AuthLocalDatasourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;

    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
    await _prefs.remove(_tokenKey);
  }

  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }
}
```

#### Step 6: Data Layer - Repository Implementation

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final AuthLocalDatasource _localDatasource;

  AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
    required AuthLocalDatasource localDatasource,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _remoteDatasource.login(
        email: email,
        password: password,
      );
      
      // Cache user locally
      await _localDatasource.saveUser(userModel);
      
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userModel = await _remoteDatasource.register(
        email: email,
        password: password,
        name: name,
      );
      
      await _localDatasource.saveUser(userModel);
      
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDatasource.logout();
      await _localDatasource.clearUser();
      return const Right(null);
    } catch (e) {
      // Even if remote logout fails, clear local cache
      await _localDatasource.clearUser();
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> checkAuthStatus() async {
    try {
      final cachedUser = await _localDatasource.getUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> refreshToken() async {
    try {
      final userModel = await _remoteDatasource.refreshToken();
      await _localDatasource.saveUser(userModel);
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

#### Step 7: Presentation Layer - BLoC

```dart
// lib/features/auth/presentation/bloc/auth_event.dart
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();

  @override
  List<Object?> get props => [];
}

// lib/features/auth/presentation/bloc/auth_state.dart
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  List<Object?> get props => [];
}

class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();

  @override
  List<Object?> get props => [];
}

// lib/features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/check_auth_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final CheckAuthUsecase checkAuthUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.checkAuthUsecase,
  }) : super(const AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    
    final result = await loginUsecase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> _onLogoutEvent(LogoutEvent event, Emitter<AuthState> emit) async {
    final result = await logoutUsecase();

    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (_) => emit(const AuthLoggedOut()),
    );
  }

  Future<void> _onCheckAuthStatusEvent(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await checkAuthUsecase();

    result.fold(
      (failure) => emit(const AuthLoggedOut()),
      (user) {
        if (user != null) {
          emit(AuthSuccess(user: user));
        } else {
          emit(const AuthLoggedOut());
        }
      },
    );
  }
}
```

#### Step 8: Presentation Layer - Pages

```dart
// lib/features/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/login_form.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Navigate to home page
            context.router.replaceNamed('/home');
          } else if (state is AuthFailure) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 40),
                  const LoginForm(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
```

#### Step 9: Dependency Injection

```dart
// lib/features/auth/di/auth_injection.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/datasources/auth_local_datasource.dart';
import '../data/datasources/auth_local_datasource_impl.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/datasources/auth_remote_datasource_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/check_auth_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../presentation/bloc/auth_bloc.dart';
import '../../../../core/network/dio_client.dart';

/// Register auth feature dependencies
void setupAuthDependencies(GetIt getIt) {
  // Get existing instances from core
  final dioClient = getIt<DioClient>();
  final sharedPreferences = getIt<SharedPreferences>();

  // Register datasources
  getIt.registerSingleton<AuthRemoteDatasource>(
    AuthRemoteDatasourceImpl(dioClient: dioClient),
  );

  getIt.registerSingleton<AuthLocalDatasource>(
    AuthLocalDatasourceImpl(prefs: sharedPreferences),
  );

  // Register repository
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDatasource: getIt(),
      localDatasource: getIt(),
    ),
  );

  // Register usecases
  getIt.registerSingleton(
    LoginUsecase(repository: getIt()),
  );

  getIt.registerSingleton(
    LogoutUsecase(repository: getIt()),
  );

  getIt.registerSingleton(
    CheckAuthUsecase(repository: getIt()),
  );

  // Register BLoC
  getIt.registerSingleton(
    AuthBloc(
      loginUsecase: getIt(),
      logoutUsecase: getIt(),
      checkAuthUsecase: getIt(),
    ),
  );
}
```

---

## Dependency Injection Patterns

### Core DI Setup

```dart
// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../../features/auth/di/auth_injection.dart';
import '../../features/profile/di/profile_injection.dart';
import '../../features/payment/di/payment_injection.dart';

final getIt = GetIt.instance;

/// Setup all dependencies
/// Call this in main() before runApp()
Future<void> setupDependencies() async {
  // 1. Register core/infrastructure services
  await _setupCoreServices();

  // 2. Register feature-specific services
  setupAuthDependencies(getIt);
  setupProfileDependencies(getIt);
  setupPaymentDependencies(getIt);
}

/// Setup core layer services
/// These have no dependencies on features
Future<void> _setupCoreServices() async {
  // Register shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton(sharedPreferences);

  // Register Dio HTTP client
  getIt.registerSingleton(DioClient());

  // Register other core services
  // getIt.registerSingleton(Logger());
  // getIt.registerSingleton(LocalStorage());
}
```

### Lazy Registration Pattern

```dart
// Use for expensive objects that might not be used
getIt.registerLazySingleton<HeavyService>(
  () => HeavyService(), // Only created when first accessed
);

// Access later
final service = getIt<HeavyService>();
```

### Factory Pattern

```dart
// Use for objects that need new instance each time
getIt.registerFactory<PageState>(
  () => PageState(),
);

// Each access gets new instance
final state1 = getIt<PageState>();
final state2 = getIt<PageState>(); // Different instance
```

---

## Common Patterns & Solutions

### Pattern 1: Handling API Errors

```dart
// lib/core/errors/failure.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final dynamic originalError;

  const Failure({
    required this.message,
    this.originalError,
  });
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required String message,
    this.statusCode,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);

  @override
  List<Object?> get props => [message, statusCode];
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required String message,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);

  @override
  List<Object?> get props => [message];
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    dynamic originalError,
  }) : super(message: message, originalError: originalError);

  @override
  List<Object?> get props => [message];
}
```

### Pattern 2: Cross-Feature Communication

**Without circular dependencies:**

```dart
// Option 1: Via shared interface in core
// core/services/user_service.dart
abstract interface class CurrentUserProvider {
  User? getCurrentUser();
}

// Both features depend on this interface
// auth_feature implements it
// profile_feature uses it via GetIt

// Option 2: Via GetIt at runtime
final authBloc = getIt<AuthBloc>();
final user = authBloc.state; // Access state if needed

// Option 3: Via shared BLoC events
// core/events/app_events.dart
class UserLoggedOutEvent { }

// Any feature can listen to this
```

### Pattern 3: Offline-First Architecture

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, User>> login({...}) async {
    try {
      // Try remote first
      final userModel = await _remoteDatasource.login(...);
      
      // Cache it
      await _localDatasource.saveUser(userModel);
      
      return Right(userModel);
    } on NetworkException catch (e) {
      // If network error, try cache
      final cachedUser = await _localDatasource.getUser();
      if (cachedUser != null) {
        return Right(cachedUser); // Return stale data
      }
      return Left(NetworkFailure(message: e.toString()));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

### Pattern 4: BLoC with Initial State Check

```dart
// Check auth status on app startup
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter().config(
        navigatorObservers: () => [
          AuthRouteObserver(), // Observes route changes
        ],
      ),
    );
  }
}

// Or in main
void main() {
  setupDependencies();
  
  // Check auth status before launching app
  final authBloc = getIt<AuthBloc>();
  authBloc.add(CheckAuthStatusEvent());
  
  runApp(const MyApp());
}
```

---

## Folder Organization Commands

### Create Complete Feature Scaffold

```bash
#!/bin/bash
# save as: create_feature.sh

FEATURE_NAME=$1

# Create feature folder structure
mkdir -p lib/features/$FEATURE_NAME/{data,domain,presentation,di}
mkdir -p lib/features/$FEATURE_NAME/data/{datasources,models,repositories}
mkdir -p lib/features/$FEATURE_NAME/domain/{entities,repositories,usecases}
mkdir -p lib/features/$FEATURE_NAME/presentation/{bloc,pages,widgets}

# Create placeholder files
touch lib/features/$FEATURE_NAME/data/datasources/${FEATURE_NAME}_datasource.dart
touch lib/features/$FEATURE_NAME/data/models/${FEATURE_NAME}_model.dart
touch lib/features/$FEATURE_NAME/data/repositories/${FEATURE_NAME}_repository_impl.dart
touch lib/features/$FEATURE_NAME/domain/entities/${FEATURE_NAME}.dart
touch lib/features/$FEATURE_NAME/domain/repositories/${FEATURE_NAME}_repository.dart
touch lib/features/$FEATURE_NAME/domain/usecases/${FEATURE_NAME}_usecase.dart
touch lib/features/$FEATURE_NAME/presentation/bloc/${FEATURE_NAME}_bloc.dart
touch lib/features/$FEATURE_NAME/presentation/pages/${FEATURE_NAME}_page.dart
touch lib/features/$FEATURE_NAME/di/${FEATURE_NAME}_injection.dart

echo "Feature $FEATURE_NAME created successfully!"
```

**Usage:**
```bash
chmod +x create_feature.sh
./create_feature.sh payment
```

---

## Troubleshooting Common Issues

### Issue 1: Circular Import Detected

```dart
// ❌ Problem
// auth/presentation imports payment/data
// payment/data imports auth/presentation

// ✅ Solution
// Use GetIt to break the cycle
final paymentService = getIt<PaymentService>(); // Runtime, no import needed
```

### Issue 2: BLoC Not Updating UI

```dart
// ❌ Problem
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AuthBloc(); // New instance each build!
  }
}

// ✅ Solution
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // BLoC from context (provided via BlocProvider)
      },
    );
  }
}
```

### Issue 3: Model Serialization Errors

```dart
// ❌ Problem
class User extends Equatable { // No serialization methods
  final String id;
}

// ✅ Solution
class UserModel extends User { // Model handles serialization
  factory UserModel.fromJson(Map<String, dynamic> json) {...}
  Map<String, dynamic> toJson() {...}
}
```

### Issue 4: DI Registration Order Matters

```dart
// ❌ Problem
void setupDependencies() {
  setupAuthDependencies(getIt); // Auth depends on core!
  _setupCoreServices(); // Core setup AFTER features
}

// ✅ Solution
Future<void> setupDependencies() async {
  await _setupCoreServices(); // Core FIRST
  setupAuthDependencies(getIt);
}
```

---

## Performance Optimization

### Lazy Loading Features

```dart
// Load features only when needed
void main() {
  setupDependencies();
  
  runApp(const MyApp());
}

// Setup feature dependencies when navigating to that feature
class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Setup feature dependencies just before navigation
        setupPaymentDependencies(getIt);
        context.router.pushNamed('/payment');
      },
      child: const Text('Go to Payment'),
    );
  }
}
```

### Optimize Build Sizes

```dart
// Use modular imports to reduce app size
// ✅ Good - Import only what's needed
import 'package:flutter/material.dart';

// ❌ Bad - Imports entire library
import 'package:flutter/material.dart' show Scaffold, AppBar, Text;
```

---

## Team Collaboration Guidelines

### Code Review Checklist for Feature

- [ ] Feature folder is in `lib/features/{feature_name}/`
- [ ] Contains complete vertical slice (presentation, domain, data)
- [ ] No imports from other features' implementations
- [ ] Clear public API via exports
- [ ] Unit tests for domain/data layers
- [ ] BLoC follows event/state pattern
- [ ] Repository uses Either<Failure, Success>
- [ ] DI setup in di/ folder
- [ ] README documenting the feature

### Feature Handoff Template

```dart
// FEATURE HANDOFF - Payment Feature
// Developed by: Team A
// Status: Ready for integration

/// Feature Entry Points
/// - PaymentPage: Entry page for payment flow
/// - PaymentBloc: State management
/// - PaymentRepository: Business logic

/// Public API (what other features can use)
export 'domain/entities/transaction.dart';
export 'presentation/pages/payment_page.dart';

/// Known Limitations
/// - Only supports card payments (crypto coming soon)
/// - No offline support (requires connectivity)

/// Integration Steps
/// 1. Import PaymentPage into AutoRouter
/// 2. Add setupPaymentDependencies(getIt) to injection_container.dart
/// 3. Add PaymentRoute to router.dart

/// Questions? Contact Team A
```

---

## Summary

This implementation guide provides production-ready patterns for:
- ✅ Complete feature structure
- ✅ Proper dependency injection
- ✅ Error handling patterns
- ✅ Testing strategies
- ✅ Team collaboration

Follow these patterns to maintain scalability, testability, and code organization as your monolithic application grows.

