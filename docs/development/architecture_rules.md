# Flutter Feature-Based Monolithic Architecture
## Comprehensive Guide & Rules

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Core Principles](#core-principles)
3. [Project Structure](#project-structure)
4. [Dependency Rules](#dependency-rules)
5. [Layer Responsibilities](#layer-responsibilities)
6. [File Organization](#file-organization)
7. [Code Examples](#code-examples)
8. [Best Practices](#best-practices)
9. [Testing Strategy](#testing-strategy)
10. [Refactoring to Modular](#refactoring-to-modular)

---

## Architecture Overview

### Definition

**Feature-Based Monolithic Architecture** is a single Flutter project organized by business features rather than technical layers. Each feature is a self-contained unit with its own presentation, domain, and data layers, while maintaining clear boundaries to enable future refactoring into modular packages.

### Characteristics

- **Single Project**: One Flutter project with one pubspec.yaml
- **Feature-Oriented**: Code organized by business domains (auth, payment, profile, etc.)
- **Clean Architecture**: Each feature implements presentation → domain → data layer separation
- **Modular Mindset**: Clear boundaries prevent circular dependencies despite being monolithic
- **Scalable**: Can grow from MVP to large applications without restructuring
- **Future-Proof**: Easy to convert to multi-package modular architecture when needed

### When to Use

| Scenario | Recommendation |
|----------|----------------|
| MVP / Early Stage | ✅ Recommended |
| Small Team (1-3 devs) | ✅ Recommended |
| Medium App (5-15 features) | ✅ Recommended |
| Learning Clean Architecture | ✅ Recommended |
| Pre-modularization State | ✅ Recommended |
| Large Enterprise Team (5+) | ⚠️ Consider Modular |
| Massive App (20+ features) | ⚠️ Consider Modular |
| Need Multi-App Reusability | ⚠️ Consider Modular |

---

## Core Principles

### 1. Feature Independence

Each feature must be:
- **Self-contained**: Contains all code needed for that feature
- **Isolated**: Minimal dependencies on other features
- **Testable**: Can be tested independently
- **Reusable**: Logic can be reused in other projects (future modular)

```
✅ GOOD: Each feature has complete vertical slice
auth/ → entities + repositories + usecases + bloc + pages + widgets

❌ BAD: Feature depends on internal implementation of another feature
auth/ → imports internal datasources from payment/
```

### 2. Dependency Rule (Critical!)

**Dependency can only flow in this direction:**

```
UI Layer (Presentation)
    ↓
Domain Layer (Business Logic)
    ↓
Data Layer (Repositories & Datasources)
    ↓
Core & Shared (Utilities, Constants, Errors)
```

**NEVER allow:**
- Feature A imports Feature B's implementation
- Circular dependencies between features
- Data layer depending on presentation

**Example:**
```dart
// ✅ ALLOWED
import '../../domain/repositories/auth_repository.dart';
import '../../../core/errors/failure.dart';
import '../../../shared/widgets/common_button.dart';

// ❌ FORBIDDEN
import '../../payment/presentation/bloc/payment_bloc.dart'; // Different feature!
import '../../../features/profile/data/datasources/...'; // Implementation detail!
```

### 3. Separation of Concerns

Each layer has specific responsibility:

| Layer | Responsibility | Cannot Depend On |
|-------|----------------|------------------|
| **Presentation** | UI, State Management (BLoC), User Interaction | Other features' presentation |
| **Domain** | Business Logic, Use Cases, Interfaces | Data implementation details |
| **Data** | Repository Implementation, Datasources, Models | Presentation layer |
| **Core** | Cross-cutting concerns (errors, network, DI) | Any feature |
| **Shared** | Reusable components (widgets, themes, utilities) | Any feature |

### 4. Service Locator Pattern (Dependency Injection)

Use GetIt to register and resolve dependencies without tight coupling:

```dart
// Services are registered at startup
setupDependencies();

// Services are resolved without importing implementation
final authBloc = getIt<AuthBloc>();
final paymentService = getIt<PaymentService>();

// This enables feature independence and easy testing
```

### 5. Clear API Boundaries

Each feature exposes only what's necessary through a public interface:

```dart
// ✅ Good: Clear public API
export 'domain/entities/user.dart';
export 'presentation/pages/login_page.dart';

// ❌ Bad: Exposing internal details
export 'data/datasources/auth_remote_datasource.dart';
export 'data/models/user_model.dart';
```

---

## Project Structure

### Directory Tree (Complete)

```
my_app/
│
├── lib/
│   │
│   ├── main.dart                          # App entry point
│   │
│   ├── app/
│   │   ├── app.dart                      # MaterialApp configuration
│   │   └── routes.dart                   # AutoRouter setup
│   │
│   ├── core/                             # CORE LAYER - No feature dependencies
│   │   ├── constants/
│   │   │   └── app_constants.dart        # Global app constants
│   │   │
│   │   ├── errors/
│   │   │   ├── failure.dart              # Base failure class
│   │   │   ├── exception.dart            # Custom exceptions
│   │   │   └── error_handler.dart        # Error handling logic
│   │   │
│   │   ├── extensions/
│   │   │   ├── context_extension.dart    # BuildContext helpers
│   │   │   ├── string_extension.dart     # String helpers
│   │   │   └── num_extension.dart        # Number helpers
│   │   │
│   │   ├── network/
│   │   │   ├── dio_client.dart           # HTTP client setup
│   │   │   ├── api_endpoints.dart        # API base URLs
│   │   │   └── interceptors/             # Request/Response interceptors
│   │   │
│   │   ├── utils/
│   │   │   ├── logger.dart               # Logging utility
│   │   │   └── app_utils.dart            # Generic utilities
│   │   │
│   │   └── di/
│   │       └── injection_container.dart  # Dependency Injection registry
│   │
│   ├── shared/                           # SHARED LAYER - Common to all features
│   │   ├── widgets/
│   │   │   ├── custom_app_bar.dart
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   └── common_widgets.dart
│   │   │
│   │   ├── themes/
│   │   │   ├── app_colors.dart           # Color palette
│   │   │   ├── app_text_styles.dart      # Typography
│   │   │   ├── app_spacing.dart          # Spacing constants
│   │   │   └── theme.dart                # Complete theme config
│   │   │
│   │   └── utils/
│   │       ├── validators.dart           # Common validators
│   │       ├── formatters.dart           # Common formatters
│   │       └── converters.dart           # Common converters
│   │
│   └── features/
│       │
│       ├── auth/                         # FEATURE PACKAGE
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   ├── auth_remote_datasource.dart          # Abstract
│       │   │   │   ├── auth_remote_datasource_impl.dart     # Implementation
│       │   │   │   ├── auth_local_datasource.dart           # Abstract
│       │   │   │   └── auth_local_datasource_impl.dart      # Implementation
│       │   │   ├── models/
│       │   │   │   └── user_model.dart                       # API response model
│       │   │   └── repositories/
│       │   │       └── auth_repository_impl.dart             # Repository impl
│       │   │
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   └── user.dart                             # Business entity
│       │   │   ├── repositories/
│       │   │   │   └── auth_repository.dart                  # Abstract interface
│       │   │   └── usecases/
│       │   │       ├── login_usecase.dart
│       │   │       ├── register_usecase.dart
│       │   │       ├── logout_usecase.dart
│       │   │       └── check_auth_usecase.dart
│       │   │
│       │   ├── presentation/
│       │   │   ├── bloc/
│       │   │   │   ├── auth_bloc.dart
│       │   │   │   ├── auth_event.dart
│       │   │   │   └── auth_state.dart
│       │   │   ├── pages/
│       │   │   │   ├── login_page.dart
│       │   │   │   └── register_page.dart
│       │   │   └── widgets/
│       │   │       ├── login_form.dart
│       │   │       └── register_form.dart
│       │   │
│       │   └── di/
│       │       └── auth_injection.dart    # Feature-specific DI
│       │
│       ├── profile/                       # FEATURE PACKAGE
│       │   ├── data/
│       │   ├── domain/
│       │   ├── presentation/
│       │   └── di/
│       │
│       └── payment/                       # FEATURE PACKAGE
│           ├── data/
│           ├── domain/
│           ├── presentation/
│           └── di/
│
├── test/                                  # Unit & Widget tests
│   └── features/
│       ├── auth/
│       │   ├── data/
│       │   ├── domain/
│       │   └── presentation/
│       └── ...
│
└── pubspec.yaml                          # Single package descriptor
```

### Key Points About Structure

**Vertical Organization**: Each feature is a vertical slice containing all three layers (presentation, domain, data).

**Layer Consistency**: Each feature has identical internal structure for predictability and maintainability.

**Clear Boundaries**: Features only import from `core/` and `shared/`, not from other features' implementations.

**DI Per Feature**: Each feature has `di/` folder for feature-specific dependency registration.

---

## Dependency Rules

### Rule 1: Feature Isolation

```dart
// ✅ ALLOWED: Import from same feature
import '../domain/usecases/login_usecase.dart';
import '../data/models/user_model.dart';
import '../presentation/widgets/login_form.dart';

// ✅ ALLOWED: Import from core/shared
import '../../../core/errors/failure.dart';
import '../../../shared/themes/app_colors.dart';

// ❌ FORBIDDEN: Import from another feature's implementation
import '../../payment/data/datasources/payment_datasource.dart';
import '../../profile/domain/repositories/profile_repository.dart';

// ⚠️ CONDITIONAL: Use GetIt for cross-feature service access
final paymentService = getIt<PaymentService>(); // OK after setup
```

### Rule 2: Layer Import Direction

```dart
// PRESENTATION LAYER
// ✅ Can import from: Domain, Core, Shared
import '../../domain/usecases/login_usecase.dart';
import '../../../core/errors/failure.dart';

// ❌ Cannot import from: Data implementation
import '../../data/datasources/auth_datasource.dart'; // Wrong!

// DOMAIN LAYER
// ✅ Can import from: Core (errors, interfaces)
import '../../../core/errors/failure.dart';

// ❌ Cannot import from: Presentation, Data
import '../../data/models/user_model.dart'; // Wrong!
import '../../presentation/bloc/auth_bloc.dart'; // Wrong!

// DATA LAYER
// ✅ Can import from: Domain interfaces, Core
import '../../domain/repositories/auth_repository.dart';
import '../../../core/network/dio_client.dart';

// ❌ Cannot import from: Presentation, Domain implementation
import '../../presentation/bloc/auth_bloc.dart'; // Wrong!
```

### Rule 3: Circular Dependency Prevention

```dart
// ❌ FORBIDDEN PATTERN 1: Direct Feature-to-Feature
features/auth/
  └── imports from features/payment/ 
    └── imports from features/auth/ ← CIRCULAR!

// ❌ FORBIDDEN PATTERN 2: Cross-Feature Domain Sharing
features/auth/domain/usecases/
  └── imports features/profile/domain/entities/

// ✅ ALLOWED: Shared abstractions in core/
core/errors/failure.dart ← Both auth and profile can import

// ✅ ALLOWED: GetIt Service Locator
getIt<PaymentService>() // Runtime resolution, no import cycle
```

### Rule 4: Feature Communication Guidelines

```dart
// Pattern 1: Via Shared Interfaces
// core/services/user_service.dart - Interface that both features depend on
abstract class UserService {
  User getCurrentUser();
}

// Pattern 2: Via GetIt Service Locator
// No direct imports needed
final userService = getIt<UserService>();

// Pattern 3: Via BLoC Access from Widget Context
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    final paymentBloc = context.read<PaymentBloc>(); // Runtime access
  },
);

// Pattern 4: Shared Events/States in Core
// core/common_events.dart
class UserLoggedOutEvent { }

// Both features emit/listen to common events
```

---

## Layer Responsibilities

### Presentation Layer

**Responsibility:** Handle UI rendering and user interaction

**Contains:**
- BLoC (state management with flutter_bloc)
- Pages (full screen widgets with @RoutePage)
- Widgets (feature-specific UI components)

**Rules:**
- Only call BLoC methods, don't call repositories directly
- BLoC is injected via GetIt, not created in widget
- No business logic, only UI logic
- No access to data sources

**Example:**
```dart
// ✅ GOOD
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) return LoadingWidget();
        if (state is AuthSuccess) return SuccessWidget();
        if (state is AuthFailure) return ErrorWidget(state.message);
      },
    );
  }
}

// ❌ BAD
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Don't access repository directly
    final repo = AuthRepositoryImpl();
    final user = repo.login(...); // Wrong!
  }
}
```

### Domain Layer

**Responsibility:** Encapsulate business logic

**Contains:**
- Entities (domain models)
- Repositories (abstract interfaces)
- Use Cases (business logic, command pattern)

**Rules:**
- No external dependencies except core/errors
- No dependency on data layer implementation
- Pure business logic, testable with simple unit tests
- All collaborators are abstractions (interfaces)

**Example:**
```dart
// ✅ GOOD - Pure business logic
class LoginUsecase {
  final AuthRepository repository;
  
  LoginUsecase({required this.repository});
  
  Future<Either<Failure, User>> call(LoginParams params) {
    // Business validation
    if (params.email.isEmpty) {
      return Left(ValidationFailure(message: 'Email required'));
    }
    return repository.login(email: params.email, password: params.password);
  }
}

// ❌ BAD - Depends on data layer
class LoginUsecase {
  final AuthRemoteDatasource datasource; // Wrong! Depends on implementation
  
  Future<User> call(LoginParams params) {
    return datasource.login(...);
  }
}
```

### Data Layer

**Responsibility:** Handle data operations and persistence

**Contains:**
- Data Sources (remote API, local storage abstractions)
- Models (DTO, serialization/deserialization)
- Repositories (concrete implementations)

**Rules:**
- No dependency on presentation layer
- Models extend entities for serialization
- Datasources are abstract, implementations handle specifics
- Handle errors and convert to domain failures

**Example:**
```dart
// ✅ GOOD - Clear separation
abstract class AuthRemoteDatasource {
  Future<UserModel> login({required String email, required String password});
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient client;
  
  @override
  Future<UserModel> login({...}) async {
    final response = await client.post('/login', data: {...});
    return UserModel.fromJson(response);
  }
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;
  final AuthLocalDatasource local;
  
  @override
  Future<Either<Failure, User>> login({...}) async {
    try {
      final userModel = await remote.login(...);
      await local.saveUser(userModel);
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

### Core Layer

**Responsibility:** Provide cross-cutting utilities and infrastructure

**Contains:**
- Error classes and handling
- Network client configuration
- Dependency injection setup
- Constants and utilities
- Extensions

**Rules:**
- No dependency on any feature
- Reusable across all features
- Only adds framework utilities, not business logic
- Organized by concern, not by feature

### Shared Layer

**Responsibility:** Provide reusable UI components and design system

**Contains:**
- Common widgets (buttons, text fields, app bars)
- Theme configuration
- Common validators and formatters
- Design system tokens

**Rules:**
- No dependency on any feature
- Components are generic and configurable
- Theme is centralized
- Utilities are cross-cutting

---

## File Organization

### File Naming Conventions

```
GOOD naming:
- auth_bloc.dart
- auth_event.dart
- auth_state.dart
- login_usecase.dart
- auth_repository.dart (interface)
- auth_repository_impl.dart (implementation)
- user.dart (entity)
- user_model.dart (DTO)
- auth_injection.dart (DI setup)
- login_page.dart
- login_form.dart

BAD naming:
- authbloc.dart (no underscore)
- LoginBloc.dart (file name should be lowercase)
- repository.dart (not feature-specific)
- model.dart (ambiguous)
```

### Export Strategy

```dart
// ✅ GOOD: Use feature-level exports
// lib/features/auth/domain/repositories/auth_repository.dart
abstract interface class AuthRepository {
  Future<Either<Failure, User>> login({...});
}

// lib/features/auth/presentation/pages/login_page.dart
@RoutePage()
class LoginPage extends StatelessWidget { }

// ✅ Expose public API
// lib/features/auth/auth.dart or lib/features/auth/index.dart
export 'domain/entities/user.dart';
export 'domain/repositories/auth_repository.dart';
export 'presentation/pages/login_page.dart';
export 'presentation/bloc/auth_bloc.dart';

// ❌ WRONG: Don't export internal implementation
// These should remain private
// - auth_remote_datasource.dart
// - user_model.dart
// - auth_repository_impl.dart
```

### Comment/Documentation Structure

```dart
/// # Auth Feature
/// 
/// Handles all user authentication related functionality including:
/// - User login/registration
/// - Password management
/// - Authentication state
///
/// ## Public API
/// - [LoginPage]: Main login screen
/// - [User]: User entity
/// - [AuthBloc]: Authentication state management
///
/// ## Implementation Details
/// Uses Clean Architecture with BLoC pattern.
/// - Presentation: Handles UI and user interaction
/// - Domain: Business logic and use cases
/// - Data: API communication and local storage
library auth_feature;
```

---

## Code Examples

### Example 1: Complete Feature Structure - Authentication

#### Entity
```dart
// lib/features/auth/domain/entities/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profilePicture;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [id, email, name, profilePicture];
}
```

#### Repository Interface
```dart
// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User?>> checkAuthStatus();
}
```

#### Use Case
```dart
// lib/features/auth/domain/usecases/login_usecase.dart
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

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

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase({required this.repository});

  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(
      email: params.email,
      password: params.password,
    );
  }
}
```

#### BLoC
```dart
// lib/features/auth/presentation/bloc/auth_event.dart
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();

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

// lib/features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.logoutUsecase,
  }) : super(const AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<LogoutEvent>(_onLogoutEvent);
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
      (_) => emit(const AuthInitial()),
    );
  }
}
```

#### Page
```dart
// lib/features/auth/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../bloc/auth_bloc.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.router.replaceNamed('/home');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return const LoginForm();
          },
        ),
      ),
    );
  }
}
```

#### Dependency Injection
```dart
// lib/features/auth/di/auth_injection.dart
import 'package:get_it/get_it.dart';
import '../data/datasources/auth_remote_datasource.dart';
import '../data/datasources/auth_remote_datasource_impl.dart';
import '../data/datasources/auth_local_datasource.dart';
import '../data/datasources/auth_local_datasource_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../presentation/bloc/auth_bloc.dart';

void setupAuthDependencies(GetIt getIt) {
  // Data Sources
  getIt.registerSingleton<AuthRemoteDatasource>(
    AuthRemoteDatasourceImpl(dioClient: getIt()),
  );

  getIt.registerSingleton<AuthLocalDatasource>(
    AuthLocalDatasourceImpl(),
  );

  // Repository
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDatasource: getIt(),
      localDatasource: getIt(),
    ),
  );

  // Use Cases
  getIt.registerSingleton(
    LoginUsecase(repository: getIt()),
  );
  getIt.registerSingleton(
    LogoutUsecase(repository: getIt()),
  );

  // Bloc
  getIt.registerSingleton(
    AuthBloc(
      loginUsecase: getIt(),
      logoutUsecase: getIt(),
    ),
  );
}
```

### Example 2: Main App Setup

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup all dependencies at startup
  await setupDependencies();
  
  runApp(const MyApp());
}

// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import '../../features/auth/di/auth_injection.dart';
import '../../features/profile/di/profile_injection.dart';
import '../../features/payment/di/payment_injection.dart';
import '../network/dio_client.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Core layer setup first
  _setupCoreServices();
  
  // Feature-specific setup (can depend on core)
  setupAuthDependencies(getIt);
  setupProfileDependencies(getIt);
  setupPaymentDependencies(getIt);
}

void _setupCoreServices() {
  getIt.registerSingleton(DioClient());
  // ... other core services
}

// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/di/injection_container.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';
import 'routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<ProfileBloc>()),
      ],
      child: MaterialApp.router(
        title: 'My App',
        theme: ThemeData(useMaterial3: true),
        routerConfig: AppRouter().config(),
      ),
    );
  }
}
```

---

## Best Practices

### 1. Dependency Injection Principles

**Rule:** All dependencies should be registered in DI container, not created inline.

```dart
// ✅ GOOD: Register at startup
void main() {
  setupDependencies();
  runApp(const MyApp());
}

// ❌ BAD: Create inline in widget
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = AuthBloc(...); // Wrong! Should use getIt
  }
}
```

### 2. Error Handling

**Rule:** Use Either<Failure, Success> for consistent error handling.

```dart
// ✅ GOOD: Consistent error handling with fpdart
Future<Either<Failure, User>> login({...}) async {
  try {
    final user = await remote.login(...);
    return Right(user);
  } on SocketException {
    return Left(NetworkFailure(message: 'No internet'));
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message));
  }
}

// ❌ BAD: Inconsistent error handling
Future<User> login({...}) async {
  try {
    return await remote.login(...);
  } catch (e) {
    throw e; // Inconsistent
  }
}
```

### 3. Entity vs Model Distinction

```dart
// ✅ GOOD: Clear separation
// domain/entities/user.dart - Pure business entity
class User extends Equatable {
  final String id;
  final String email;
  // No serialization logic
}

// data/models/user_model.dart - API response model
class UserModel extends User {
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(...);
  Map<String, dynamic> toJson() => {...};
}

// ❌ BAD: Mixed concerns
class User {
  final String id;
  final String email;
  
  factory User.fromJson(...) { } // Serialization in entity
  Map<String, dynamic> toJson() { } // Wrong place
}
```

### 4. State Management Pattern

```dart
// ✅ GOOD: BLoC pattern with clear events and states
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({...}) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    // ... logic
  }
}

// ❌ BAD: Complex state updates
class AuthBloc extends Bloc<dynamic, AuthState> {
  void updateUser(User user) {
    state = AuthSuccess(user: user); // Bypassing BLoC pattern
  }
}
```

### 5. Testing Structure

```dart
// lib/features/auth/test/domain/usecases/login_usecase_test.dart
void main() {
  group('LoginUsecase', () {
    late MockAuthRepository mockRepository;
    late LoginUsecase usecase;

    setUp(() {
      mockRepository = MockAuthRepository();
      usecase = LoginUsecase(repository: mockRepository);
    });

    test('should return User on success', () async {
      when(() => mockRepository.login(...))
          .thenAnswer((_) async => Right(testUser));

      final result = await usecase(testParams);

      expect(result, Right(testUser));
      verify(() => mockRepository.login(...)).called(1);
    });
  });
}
```

### 6. Feature Public API

Always create clear public API for each feature:

```dart
// lib/features/auth/index.dart or lib/features/auth/auth.dart
export 'domain/entities/user.dart';
export 'domain/repositories/auth_repository.dart';
export 'presentation/bloc/auth_bloc.dart';
export 'presentation/pages/login_page.dart';
export 'presentation/pages/register_page.dart';

// DO NOT export:
// - Implementation details (auth_repository_impl.dart)
// - Data models (user_model.dart)
// - Datasources (auth_remote_datasource.dart)
// - Internal widgets (login_form.dart)
```

---

## Testing Strategy

### Unit Testing (Domain Layer)

```dart
// test/features/auth/domain/usecases/login_usecase_test.dart
void main() {
  group('LoginUsecase', () {
    test('returns Right(User) when login succeeds', () async {
      // Arrange
      final params = LoginParams(email: 'test@test.com', password: 'password');
      when(() => mockRepo.login(...)).thenAnswer((_) async => Right(testUser));

      // Act
      final result = await loginUsecase(params);

      // Assert
      expect(result, Right(testUser));
    });

    test('returns Left(Failure) when login fails', () async {
      // Arrange
      when(() => mockRepo.login(...))
          .thenAnswer((_) async => Left(ServerFailure(message: 'Error')));

      // Act
      final result = await loginUsecase(params);

      // Assert
      expect(result, isA<Left<Failure, User>>());
    });
  });
}
```

### BLoC Testing

```dart
// test/features/auth/presentation/bloc/auth_bloc_test.dart
void main() {
  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when LoginEvent succeeds',
      build: () => authBloc,
      setUp: () {
        when(() => mockLoginUsecase(any()))
            .thenAnswer((_) async => Right(testUser));
      },
      act: (bloc) => bloc.add(LoginEvent(email: 'test@test.com', password: 'pwd')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>(),
      ],
    );
  });
}
```

### Feature Integration Testing

```dart
// test/features/auth/auth_feature_test.dart
// Tests entire feature flow from presentation to data
void main() {
  group('Auth Feature Integration', () {
    test('Login flow from page to repository', () async {
      // Setup mocks
      setupAuthDependencies(testGetIt);
      
      // Test complete flow
      final bloc = testGetIt<AuthBloc>();
      bloc.add(LoginEvent(...));
      
      await expectLater(bloc.stream, emitsInOrder([...]));
    });
  });
}
```

---

## Refactoring to Modular

When your monolithic app grows and you need to modularize:

### Step 1: Create Package Structure

```bash
flutter create --template=package features/auth
flutter create --template=package features/profile
flutter create --template=package core
flutter create --template=package shared
```

### Step 2: Move Code to Packages

```
Before (Monolith):
lib/features/auth/ → After (Modular):
                     features/auth/lib/

lib/core/ → core/lib/
lib/shared/ → shared/lib/
```

### Step 3: Update pubspec.yaml

Each package gets its own pubspec.yaml:

```yaml
# features/auth/pubspec.yaml
name: auth_feature
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.0.0
  core:
    path: ../core
  shared:
    path: ../shared

# Main app pubspec.yaml
dependencies:
  auth_feature:
    path: features/auth
  profile_feature:
    path: features/profile
  core:
    path: core
  shared:
    path: shared
```

### Step 4: Create Public APIs

```dart
// features/auth/lib/auth.dart
export 'src/domain/entities/user.dart';
export 'src/presentation/bloc/auth_bloc.dart';
export 'src/presentation/pages/login_page.dart';

// features/auth/lib/src/ - All internal code here (private)
// Note: Internal folder structure stays exactly the same
```

### Step 5: No Logic Changes Needed

- **Architecture stays the same**: Same layer structure
- **Dependencies stay the same**: Core → Features pattern
- **Code location only changes**: Folder movement
- **Refactoring effort is minimal**: Because structure was already modular

---

## Conclusion: Architecture Decision Matrix

| Criteria | Use Monolithic | Consider Modular |
|----------|---|---|
| Team Size | < 5 devs | 5+ devs |
| App Complexity | Small-Medium | Large/Enterprise |
| Reusability Needs | Within single app | Multi-app reuse |
| Build Performance | Not critical | Critical |
| Feature Independence | Important | Critical |
| Timeline | Startup phase | Mature phase |

**Recommendation:** Start with **Scalable Monolithic**, migrate to **Modular** only when:
1. Team grows significantly
2. Multiple teams need independence
3. Features need to be reused across projects
4. Build performance becomes a bottleneck
5. Business requirements demand it

The clean boundary structure you build from day one ensures the migration cost is minimal (move folders → add pubspec.yaml → create exports).

---

## Summary Checklist

- ✅ Organized by features, not layers
- ✅ Each feature self-contained (presentation, domain, data)
- ✅ Dependencies flow downward only (no circular)
- ✅ Features access each other only via GetIt or public interfaces
- ✅ Clear boundary between internal implementation and public API
- ✅ Core and shared layers have no feature dependencies
- ✅ Each feature has its own DI registration function
- ✅ Testing supports feature isolation
- ✅ Structure can be converted to modular with minimal changes
- ✅ New team members can understand feature independently

