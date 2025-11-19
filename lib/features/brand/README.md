# Brand Feature Documentation

## 📋 Overview

Brand feature adalah implementasi Clean Architecture untuk mengelola brand dan invitation management dalam aplikasi mobile. Fitur ini menggunakan BLoC pattern untuk state management dan dependency injection dengan GetIt untuk manajemen dependencies.

## 🏗️ Architecture

### Clean Architecture Implementation

Brand feature mengikuti prinsip Clean Architecture dengan tiga layer utama:

1. **Domain Layer** - Business logic dan entities
2. **Data Layer** - Repository implementation dan data sources
3. **Presentation Layer** - UI components dan state management

### Layer Dependencies

```
Presentation Layer
       ↓
   Domain Layer
       ↓
    Data Layer
```

## 📁 Folder Structure

```
apps/mobile/lib/features/brand/
├── di/                              # Dependency Injection
│   ├── brand_injection.dart         # Main DI configuration
│   └── brand_injection_test.dart    # Test DI configuration
├── domain/                          # Domain Layer
│   ├── entities/                    # Pure domain entities
│   │   ├── brand.dart              # Brand entity
│   │   └── brand_invitation.dart   # Brand invitation entity
│   ├── repositories/               # Repository interfaces
│   │   └── brand_repository.dart   # Brand repository interface
│   └── usecases/                  # Use cases (business logic)
│       ├── common/                # Common use case classes
│       │   ├── usecase.dart       # Base use case
│       │   └── params/            # Use case parameters
│       ├── brand/                 # Brand-related use cases
│       └── invitation/            # Invitation-related use cases
├── data/                          # Data Layer
│   ├── datasources/              # Data source implementations
│   │   ├── brand_remote_datasource.dart     # Remote data source interface
│   │   ├── brand_remote_datasource_impl.dart # Remote data source implementation
│   │   ├── brand_local_datasource.dart      # Local data source interface
│   │   └── brand_local_datasource_impl.dart # Local data source implementation
│   └── repositories/             # Repository implementations
│       └── brand_repository_impl.dart # Brand repository implementation
├── presentation/                # Presentation Layer
│   ├── bloc/                   # BLoC state management
│   │   ├── brand_management/   # Brand CRUD operations
│   │   ├── brand_list/         # Brand list management
│   │   ├── brand_search/       # Search functionality
│   │   ├── brand_switching/    # Brand switching
│   │   ├── brand_invitation/   # Invitation management
│   │   └── brand_bloc.dart     # Legacy BLoC (deprecated)
│   ├── providers/              # BLoC providers
│   │   └── brand_bloc_provider.dart # Multi-BLoC provider
│   ├── helpers/               # UI helpers and formatters
│   │   ├── brand_formatter.dart # Brand formatting utilities
│   │   └── invitation_formatter.dart # Invitation formatting
│   └── widgets/               # UI components
│       ├── brand_card.dart     # Brand card component
│       ├── brand_selector.dart # Brand selector
│       └── ...                 # Other UI components
└── README.md                  # This file
```

## 🔧 Components

### Domain Layer Components

#### Entities

**Brand Entity** ([`brand.dart`](domain/entities/brand.dart))
- Pure domain entity tanpa UI logic
- Berisi business rules untuk brand
- Methods: `copyWith()`, `displayName`, `hasLogo`, `isSubscriptionActive`, dll.

**BrandInvitation Entity** ([`brand_invitation.dart`](domain/entities/brand_invitation.dart))
- Pure domain entity untuk invitation management
- Berisi business rules untuk invitations
- Methods: `copyWith()`, `isPending`, `isAccepted`, `isValidForBusiness`, dll.

#### Use Cases

**Brand Use Cases**
- [`GetUserBrandsUseCase`](domain/usecases/brand/get_user_brands_usecase.dart) - Mendapatkan brands milik user
- [`GetAccessibleBrandsUseCase`](domain/usecases/brand/get_accessible_brands_usecase.dart) - Mendapatkan brands yang dapat diakses
- [`GetActiveBrandUseCase`](domain/usecases/brand/get_active_brand_usecase.dart) - Mendapatkan brand aktif
- [`CreateBrandUseCase`](domain/usecases/brand/create_brand_usecase.dart) - Membuat brand baru
- [`UpdateBrandUseCase`](domain/usecases/brand/update_brand_usecase.dart) - Update brand
- [`DeleteBrandUseCase`](domain/usecases/brand/delete_brand_usecase.dart) - Hapus brand

**Invitation Use Cases**
- [`GetBrandInvitationsUseCase`](domain/usecases/invitation/get_brand_invitations_usecase.dart) - Mendapatkan invitations
- [`CreateBrandInvitationUseCase`](domain/usecases/invitation/create_brand_invitation_usecase.dart) - Membuat invitation
- [`AcceptBrandInvitationUseCase`](domain/usecases/invitation/accept_brand_invitation_usecase.dart) - Menerima invitation
- [`RejectBrandInvitationUseCase`](domain/usecases/invitation/reject_brand_invitation_usecase.dart) - Menolak invitation
- [`RevokeBrandInvitationUseCase`](domain/usecases/invitation/revoke_brand_invitation_usecase.dart) - Membatalkan invitation

#### Repository Interface

**BrandRepository** ([`brand_repository.dart`](domain/repositories/brand_repository.dart))
- Interface untuk semua brand operations
- Mendefinisikan contract untuk data layer
- Menggunakan `Either<Failure, T>` untuk error handling

### Data Layer Components

#### Data Sources

**BrandRemoteDataSource** ([`brand_remote_datasource.dart`](data/datasources/brand_remote_datasource.dart))
- Interface untuk remote API operations
- Methods untuk CRUD operations via API

**BrandLocalDataSource** ([`brand_local_datasource.dart`](data/datasources/brand_local_datasource.dart))
- Interface untuk local storage operations
- Methods untuk caching dan offline support

#### Repository Implementation

**BrandRepositoryImpl** ([`brand_repository_impl.dart`](data/repositories/brand_repository_impl.dart))
- Concrete implementation dari BrandRepository
- Menggabungkan remote dan local data sources
- Menghandle error scenarios dan fallback logic

### Presentation Layer Components

#### BLoCs

**BrandManagementBloc** ([`brand_management_bloc.dart`](presentation/bloc/brand_management/brand_management_bloc.dart))
- Bertanggung jawab untuk CRUD operations
- Events: CreateBrandEvent, UpdateBrandEvent, DeleteBrandEvent
- States: BrandManagementLoading, BrandManagementCreated, dll.

**BrandListBloc** ([`brand_list_bloc.dart`](presentation/bloc/brand_list/brand_list_bloc.dart))
- Bertanggung jawab untuk mengelola daftar brand
- Events: LoadUserBrandsEvent, LoadAccessibleBrandsEvent, dll.
- States: BrandListLoading, UserBrandsLoaded, dll.

**BrandSearchBloc** ([`brand_search_bloc.dart`](presentation/bloc/brand_search/brand_search_bloc.dart))
- Bertanggung jawab untuk fungsi pencarian
- Events: SearchBrandsEvent, ClearSearchEvent, dll.
- States: BrandSearchLoading, BrandSearchLoaded, dll.

**BrandSwitchingBloc** ([`brand_switching_bloc.dart`](presentation/bloc/brand_switching/brand_switching_bloc.dart))
- Bertanggung jawab untuk operasi switch active brand
- Events: SwitchActiveBrandEvent, GetActiveBrandStatusEvent, dll.
- States: BrandSwitchingLoading, BrandSwitchingSuccess, dll.

**BrandInvitationBloc** ([`brand_invitation_bloc.dart`](presentation/bloc/brand_invitation/brand_invitation_bloc.dart))
- Bertanggung jawab untuk operasi invitation
- Events: LoadInvitationsEvent, CreateInvitationEvent, dll.
- States: BrandInvitationLoading, BrandInvitationsLoaded, dll.

#### Providers

**BrandBlocProvider** ([`brand_bloc_provider.dart`](presentation/providers/brand_bloc_provider.dart))
- MultiBlocProvider untuk semua brand BLoCs
- Extensions untuk mudah mengakses BLoCs
- Specific providers untuk optimasi performance

#### Helpers

**BrandFormatter** ([`brand_formatter.dart`](presentation/helpers/brand_formatter.dart))
- Static methods untuk formatting brand data
- Methods: `formatBusinessType()`, `formatSubscriptionTier()`, dll.

## 🚀 Getting Started

### Setup Dependencies

```dart
// In main.dart
import 'package:get_it/get_it.dart';
import 'apps/mobile/lib/features/brand/di/brand_injection.dart';

final getIt = GetIt.instance;

void main() async {
  // Initialize brand dependencies
  await BrandInjection.init(getIt);

  runApp(MyApp());
}
```

### Initialize Brand Feature

```dart
// In app.dart
import 'apps/mobile/lib/features/brand/presentation/providers/brand_bloc_provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BrandBlocProvider(
      child: MaterialApp(
        // App configuration
      ),
    );
  }
}
```

### Basic Usage Examples

#### Accessing Brand Management

```dart
class CreateBrandScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.brandManagement.add(
          CreateBrandEvent(
            name: 'My Brand',
            businessType: 'Retail',
            timezone: 'Asia/Jakarta',
            currency: 'IDR',
          ),
        );
      },
      child: Text('Create Brand'),
    );
  }
}
```

#### Watching Brand List

```dart
class BrandListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandListBloc, BrandListState>(
      builder: (context, state) {
        if (state is BrandListLoading) {
          return CircularProgressIndicator();
        } else if (state is UserBrandsLoaded) {
          return ListView.builder(
            itemCount: state.userBrands.length,
            itemBuilder: (context, index) {
              final brand = state.userBrands[index];
              return BrandCard(brand: brand);
            },
          );
        }
        return Container();
      },
    );
  }
}
```

## 📖 Usage Examples

### Multi-BLoC Provider Usage

```dart
// Using all BLoCs
BrandBlocProvider(
  child: YourWidget(),
)

// Using specific BLoCs for performance
BrandManagementBlocProvider(
  child: YourWidget(),
)

BrandInvitationBlocProvider(
  child: YourWidget(),
)
```

### Context Extensions

```dart
// Access BLoCs with extensions
context.brandManagement.add(CreateBrandEvent(...));
context.watchBrandList
context.brandSearch.add(SearchBrandsEvent(...))
context.brandSwitching.add(SwitchActiveBrandEvent(...))
context.brandInvitation.add(CreateInvitationEvent(...))
```

### Formatters Usage

```dart
// Format business type
final formattedType = BrandFormatter.formatBusinessType('RETAIL', context);

// Format subscription status
final formattedStatus = BrandFormatter.formatSubscriptionStatus('ACTIVE', context);

// Check if brand is new
final isNew = BrandFormatter.isNewBrand(brand.createdAt);
```

### Error Handling Patterns

```dart
BlocListener<BrandManagementBloc, BrandManagementState>(
  listener: (context, state) {
    if (state is BrandManagementError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    } else if (state is BrandManagementCreated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: YourWidget(),
)
```

## 🧪 Testing

### Test Setup

```dart
// In test file
import 'package:get_it/get_it.dart';
import 'apps/mobile/lib/features/brand/di/brand_injection.dart';

void main() {
  setUp(() async {
    final getIt = GetIt.asNewInstance();
    await BrandInjectionTest.initTest(getIt);
  });
}
```

### Test Helpers

```dart
// Create mock entities
final brand = BrandTestHelper.createMockBrand();
final invitation = BrandTestHelper.createMockInvitation();

// Create test widget
final testWidget = BrandTestHelper.createTestWidget(
  child: YourTestWidget(),
  brandManagementBloc: mockBloc,
);
```

### BLoC Testing

```dart
group('BrandManagementBloc', () {
  late BrandManagementBloc bloc;
  late MockCreateBrandUseCase mockCreateBrandUseCase;

  setUp(() {
    mockCreateBrandUseCase = MockCreateBrandUseCase();
    bloc = BrandManagementBloc(
      createBrandUseCase: mockCreateBrandUseCase,
      updateBrandUseCase: mockUpdateBrandUseCase,
      deleteBrandUseCase: mockDeleteBrandUseCase,
    );
  });

  test('should emit BrandManagementCreated when CreateBrandEvent is added', () async {
    // Arrange
    final brand = Brand(/* ... */);
    when(mockCreateBrandUseCase(any))
        .thenAnswer((_) async => Right(brand));

    // Act
    bloc.add(CreateBrandEvent(/* ... */));

    // Assert
    await expectLater(
      bloc.stream,
      emitsInOrder([
        BrandManagementLoading(),
        BrandManagementCreated(brand: brand, message: any),
      ]),
    );
  });
});
```

## 🔄 Migration Guide

### From Legacy BrandBloc

1. **Identify current BrandBloc usage**
   ```dart
   // Old way
   context.read<BrandBloc>().add(LoadBrandsEvent());
   ```

2. **Replace with appropriate new BLoCs**
   ```dart
   // New way
   context.brandList.add(LoadUserBrandsEvent());
   ```

3. **Update provider wrapping**
   ```dart
   // Old way
   BlocProvider(
     create: (context) => BrandBloc(),
     child: YourWidget(),
   )

   // New way
   BrandBlocProvider(
     child: YourWidget(),
   )
   ```

### From UI Logic in Domain

1. **Identify UI logic in entities**
   ```dart
   // Old way - UI logic in domain entity
   class Brand {
     String get formattedBusinessType {
       // UI formatting logic
     }
   }
   ```

2. **Move to formatters/helpers**
   ```dart
   // New way - UI logic in presentation layer
   class BrandFormatter {
     static String formatBusinessType(String businessType, BuildContext context) {
       // UI formatting logic
     }
   }
   ```

3. **Update UI components**
   ```dart
   // Old way
   Text(brand.formattedBusinessType)

   // New way
   Text(BrandFormatter.formatBusinessType(brand.businessType, context))
   ```

### Migration Checklist

- [ ] Identify BrandBloc usage in codebase
- [ ] Replace with appropriate new BLoCs
- [ ] Update dependency injection setup
- [ ] Move UI logic from domain to presentation
- [ ] Update UI components to use formatters
- [ ] Update tests to use new BLoCs
- [ ] Verify functionality works correctly
- [ ] Update documentation

## 📚 Best Practices

### Clean Architecture Principles

1. **Domain Layer Purity**
   - Entities tidak boleh memiliki dependencies ke framework
   - Use cases hanya berisi business logic
   - Repository interfaces hanya mendefinisikan contract

2. **Dependency Rules**
   - Inner layers tidak boleh depend pada outer layers
   - Gunakan dependency inversion principle
   - Use constructor injection untuk dependencies

3. **Layer Separation**
   - Jangan skip layers (misal: presentation langsung ke data source)
   - Setiap layer memiliki responsibility yang jelas
   - Gunakan interfaces untuk abstraksi

### BLoC Patterns

1. **Single Responsibility**
   - Satu BLoC untuk satu domain concern
   - Events dan states yang spesifik
   - Avoid bloated BLoCs

2. **Event/State Design**
   - Events untuk actions
   - States untuk UI representation
   - Include relevant data in states

3. **Error Handling**
   - Handle errors di BLoC level
   - Provide user-friendly error messages
   - Include error codes for debugging

### Performance Optimization

1. **Lazy Loading**
   - Gunakan LazySingleton untuk heavy objects
   - Load data hanya saat dibutuhkan
   - Implement caching strategies

2. **Memory Management**
   - Gunakan Factory pattern untuk BLoCs
   - Proper cleanup di dispose
   - Avoid memory leaks

3. **UI Optimization**
   - Gunakan SpecificBrandBlocProvider untuk BLoCs yang dibutuhkan saja
   - Implement pagination untuk large data sets
   - Use const constructors untuk widgets

## 🔍 Troubleshooting

### Common Issues

1. **GetIt Conflicts**
   ```dart
   // Problem: Import conflicts
   import 'package:get_it/get_it.dart' as get_it1;
   import 'package:get_it/get_it.dart' as get_it2;

   // Solution: Use aliases
   import 'package:get_it/get_it.dart';
   final getIt = GetIt.instance;
   ```

2. **BLoC Not Found**
   ```dart
   // Problem: BLoC not found in widget tree
   context.read<BrandManagementBloc>()

   // Solution: Ensure provider is in widget tree
   BrandBlocProvider(
     child: YourWidget(),
   )
   ```

3. **Memory Leaks**
   ```dart
   // Problem: BLoC not disposed properly
   BlocProvider(create: (context) => BrandBloc())

   // Solution: Use factory pattern
   getIt.registerFactory<BrandManagementBloc>(() => BrandManagementBloc(...));
   ```

4. **Test Failures**
   ```dart
   // Problem: Mocks not registered
   final bloc = BrandManagementBloc(useCase: mockUseCase);

   // Solution: Register mocks properly
   await BrandInjectionTest.setupTestEnvironment(
     getIt,
     brandRepository: mockRepository,
   );
   ```

### Debug Tips

```dart
// Check registered dependencies
print(getIt.allReadySync());

// Reset dependencies for testing
await BrandInjection.reset(getIt);

// Check specific dependency
final bloc = getIt.isRegistered<BrandManagementBloc>()
    ? getIt<BrandManagementBloc>()
    : null;

// Debug BLoC states
BlocListener<BrandManagementBloc, BrandManagementState>(
  listener: (context, state) {
    print('BrandManagementState: $state');
  },
  child: YourWidget(),
)
```

## 📝 Changelog

### Version 2.0.0 - Clean Architecture Refactor

#### Breaking Changes
- Replaced single `BrandBloc` with multiple focused BLoCs
- Moved UI logic from domain entities to presentation layer
- Updated dependency injection configuration
- Changed provider structure

#### New Features
- Clean Architecture implementation
- Multiple BLoCs for different concerns
- Improved error handling
- Better testability
- Enhanced performance with specific providers

#### Migration Required
- All `BrandBloc` usage needs to be updated to new BLoCs
- UI components using entity methods need to use formatters
- Provider wrapping needs to be updated
- Tests need to be updated for new structure

### Version 1.0.0 - Initial Implementation

- Basic brand management functionality
- Single BrandBloc for all operations
- Simple state management
- Basic CRUD operations