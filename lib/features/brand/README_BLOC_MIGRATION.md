# Migrasi dari BrandBloc ke Multiple BLoCs

## Overview

BrandBloc yang sebelumnya memiliki 325 lines dan 18 event handlers yang melanggar Single Responsibility Principle. Sekarang telah dipecah menjadi 5 BLoCs yang lebih fokus:

## 1. Brand Management BLoC

**Lokasi:** `lib/features/brand/presentation/bloc/brand_management/`

**Responsibilities:**
- CRUD operations (Create, Read, Update, Delete)
- Brand data management
- Brand validation

**Use Cases:**
- `CreateBrandUseCase`
- `UpdateBrandUseCase`
- `DeleteBrandUseCase`

**Events:**
- `CreateBrandEvent`
- `UpdateBrandEvent`
- `DeleteBrandEvent`
- `RefreshBrandEvent`
- `ResetBrandManagementEvent`

**States:**
- `BrandManagementInitial`
- `BrandManagementLoading`
- `BrandManagementLoaded`
- `BrandManagementCreated`
- `BrandManagementUpdated`
- `BrandManagementDeleted`
- `BrandManagementError`
- `BrandManagementValidationError`
- `BrandManagementDeleteConfirmation`

## 2. Brand List BLoC

**Lokasi:** `lib/features/brand/presentation/bloc/brand_list/`

**Responsibilities:**
- Load user brands
- Load accessible brands
- Get active brand
- Brand list state management
- Filter brands

**Use Cases:**
- `GetUserBrandsUseCase`
- `GetAccessibleBrandsUseCase`
- `GetActiveBrandUseCase`

**Events:**
- `LoadUserBrandsEvent`
- `LoadAccessibleBrandsEvent`
- `GetActiveBrandEvent`
- `LoadAllBrandDataEvent`
- `RefreshBrandListEvent`
- `ResetBrandListEvent`
- `FilterBrandsEvent`
- `ClearBrandFilterEvent`

**States:**
- `BrandListInitial`
- `BrandListLoading`
- `BrandListLoaded`
- `UserBrandsLoaded`
- `AccessibleBrandsLoaded`
- `ActiveBrandLoaded`
- `BrandListError`
- `BrandListEmpty`
- `NoActiveBrandState`

## 3. Brand Search BLoC

**Lokasi:** `lib/features/brand/presentation/bloc/brand_search/`

**Responsibilities:**
- Search functionality
- Filter brands
- Pagination untuk search results
- Search suggestions
- Recent searches

**Use Cases:**
- `SearchBrandsUseCase`

**Events:**
- `SearchBrandsEvent`
- `ClearSearchEvent`
- `LoadMoreSearchResultsEvent`
- `ResetSearchEvent`
- `UpdateSearchFiltersEvent`
- `ClearSearchFiltersEvent`
- `GetSearchSuggestionsEvent`
- `SaveRecentSearchEvent`
- `GetRecentSearchesEvent`
- `ClearRecentSearchesEvent`

**States:**
- `BrandSearchInitial`
- `BrandSearchLoading`
- `BrandSearchLoaded`
- `BrandSearchEmpty`
- `BrandSearchError`
- `BrandSearchSuggestionsLoaded`
- `BrandRecentSearchesLoaded`
- `BrandSearchFiltersLoaded`
- `BrandSearchLoadingMore`

## 4. Brand Switching BLoC

**Lokasi:** `lib/features/brand/presentation/bloc/brand_switching/`

**Responsibilities:**
- Switch active brand
- Handle brand switching flow
- Update local storage
- Switching history
- Brand access validation

**Use Cases:**
- `SwitchActiveBrandUseCase`
- `GetActiveBrandUseCase`

**Events:**
- `SwitchActiveBrandEvent`
- `GetActiveBrandStatusEvent`
- `ResetBrandSwitchingEvent`
- `PreCheckBrandSwitchEvent`
- `ConfirmBrandSwitchEvent`
- `CancelBrandSwitchEvent`
- `GetSwitchingHistoryEvent`
- `ClearSwitchingHistoryEvent`
- `ValidateBrandAccessEvent`
- `SyncBrandDataEvent`

**States:**
- `BrandSwitchingInitial`
- `BrandSwitchingLoading`
- `BrandSwitchingSuccess`
- `ActiveBrandStatusLoaded`
- `BrandSwitchingError`
- `NoActiveBrandState`
- `BrandSwitchingConfirmation`
- `BrandSwitchPreCheckCompleted`
- `SwitchingHistoryLoaded`
- `BrandAccessValidationCompleted`
- `BrandDataSyncCompleted`

## 5. Brand Invitation BLoC

**Lokasi:** `lib/features/brand/presentation/bloc/brand_invitation/`

**Responsibilities:**
- Invitation CRUD operations
- Accept/reject invitations
- Invitation status management
- Invitation validation

**Use Cases:**
- `GetBrandInvitationsUseCase`
- `CreateBrandInvitationUseCase`
- `AcceptBrandInvitationUseCase`
- `RejectBrandInvitationUseCase`
- `RevokeBrandInvitationUseCase`

**Events:**
- `LoadInvitationsEvent`
- `CreateInvitationEvent`
- `AcceptInvitationEvent`
- `RejectInvitationEvent`
- `RevokeInvitationEvent`
- `RefreshInvitationsEvent`
- `ResetInvitationStateEvent`
- `GetReceivedInvitationsEvent`
- `GetSentInvitationsEvent`
- `ResendInvitationEvent`
- `ValidateInvitationTokenEvent`
- `GetInvitationByIdEvent`
- `UpdateInvitationEvent`

**States:**
- `BrandInvitationInitial`
- `BrandInvitationLoading`
- `BrandInvitationsLoaded`
- `BrandInvitationCreated`
- `BrandInvitationAccepted`
- `BrandInvitationRejected`
- `BrandInvitationRevoked`
- `BrandInvitationError`
- `BrandInvitationEmpty`
- `ReceivedInvitationsLoaded`
- `SentInvitationsLoaded`
- `BrandInvitationResent`
- `InvitationTokenValidated`
- `InvitationDetailLoaded`
- `BrandInvitationUpdated`
- `InvitationDeleteConfirmation`
- `InvitationValidationError`

## Dependency Injection

Semua BLoCs baru telah didaftarkan di `brand_injection.dart`:

```dart
// Brand Management BLoC
getIt.registerSingleton<BrandManagementBloc>(
  BrandManagementBloc(
    createBrandUseCase: getIt(),
    updateBrandUseCase: getIt(),
    deleteBrandUseCase: getIt(),
  ),
);

// Brand List BLoC
getIt.registerSingleton<BrandListBloc>(
  BrandListBloc(
    getUserBrandsUseCase: getIt(),
    getAccessibleBrandsUseCase: getIt(),
    getActiveBrandUseCase: getIt(),
  ),
);

// Brand Search BLoC
getIt.registerSingleton<BrandSearchBloc>(
  BrandSearchBloc(
    searchBrandsUseCase: getIt(),
  ),
);

// Brand Switching BLoC
getIt.registerSingleton<BrandSwitchingBloc>(
  BrandSwitchingBloc(
    switchActiveBrandUseCase: getIt(),
    getActiveBrandUseCase: getIt(),
  ),
);

// Brand Invitation BLoC
getIt.registerSingleton<BrandInvitationBloc>(
  BrandInvitationBloc(
    getBrandInvitationsUseCase: getIt(),
    createBrandInvitationUseCase: getIt(),
    acceptBrandInvitationUseCase: getIt(),
    rejectBrandInvitationUseCase: getIt(),
    revokeBrandInvitationUseCase: getIt(),
  ),
);
```

## Cara Penggunaan

### Contoh 1: Menggunakan BrandManagementBloc

```dart
// Di dalam widget
BlocProvider(
  create: (context) => BrandManagementBloc(
    createBrandUseCase: context.read<CreateBrandUseCase>(),
    updateBrandUseCase: context.read<UpdateBrandUseCase>(),
    deleteBrandUseCase: context.read<DeleteBrandUseCase>(),
  ),
  child: Builder(
    builder: (context) {
      return ElevatedButton(
        onPressed: () {
          context.read<BrandManagementBloc>().add(
            CreateBrandEvent(
              name: 'Nama Brand',
              businessType: 'Retail',
              timezone: 'Asia/Jakarta',
              currency: 'IDR',
            ),
          );
        },
        child: Text('Buat Brand'),
      );
    },
  ),
)

// Listener untuk state changes
BlocListener<BrandManagementBloc, BrandManagementState>(
  listener: (context, state) {
    if (state is BrandManagementCreated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    } else if (state is BrandManagementError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: /* UI */,
)
```

### Contoh 2: Menggunakan Multiple BLoCs

```dart
// Di dalam widget dengan multiple BLoCs
MultiBlocProvider(
  providers: [
    BlocProvider(create: (context) => context.read<BrandListBloc>()),
    BlocProvider(create: (context) => context.read<BrandSearchBloc>()),
    BlocProvider(create: (context) => context.read<BrandSwitchingBloc>()),
  ],
  child: Builder(
    builder: (context) {
      return Column(
        children: [
          // Search bar
          TextField(
            onChanged: (query) {
              context.read<BrandSearchBloc>().add(
                SearchBrandsEvent(query: query),
              );
            },
          ),

          // Brand list
          Expanded(
            child: BlocBuilder<BrandListBloc, BrandListState>(
              builder: (context, state) {
                if (state is BrandListLoaded) {
                  return ListView.builder(
                    itemCount: state.allBrands.length,
                    itemBuilder: (context, index) {
                      final brand = state.allBrands[index];
                      return ListTile(
                        title: Text(brand.name),
                        onTap: () {
                          context.read<BrandSwitchingBloc>().add(
                            SwitchActiveBrandEvent(brandId: brand.id),
                          );
                        },
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      );
    },
  ),
)
```

## Migration Strategy

### Backward Compatibility
- BrandBloc lama tetap ada dan ditandai sebagai `@deprecated`
- BLoCs baru dapat digunakan secara bertahap
- Tidak ada breaking changes pada use cases

### Rekomendasi
1. Gunakan BLoCs baru untuk fitur baru
2. Pertimbangkan untuk menggabungkan BLoCs saat diperlukan
3. Manfaatkan MultiBlocProvider/Listener untuk multiple BLoCs
4. Pastikan untuk dispose BLoCs yang tidak digunakan

### Contoh Implementasi Lengkap

Lihat file contoh:
- `brand_list_example_page.dart` - Contoh penggunaan multiple BLoCs
- `create_brand_page_new.dart` - Contoh penggunaan BrandManagementBloc

## Keuntungan Arsitektur Baru

1. **Single Responsibility**: Setiap BLoC memiliki satu tanggung jawab yang jelas
2. **Maintainability**: Lebih mudah untuk maintain dan test
3. **Reusability**: BLoCs dapat digunakan ulang di berbagai bagian aplikasi
4. **Testability**: Setiap BLoC dapat di-test secara independen
5. **Performance**: Lebih efisien dengan state yang lebih spesifik

## Best Practices

1. Gunakan constructor injection untuk dependencies
2. Implement proper error handling dengan user-friendly messages
3. Gunakan Equatable untuk state comparison
4. Validasi input di BLoC level
5. Gunakan Bahasa Indonesia untuk documentation dan comments
6. Follow naming conventions yang konsisten
7. Implement proper loading dan error states