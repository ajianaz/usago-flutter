# Brand Feature

## Overview

Brand feature pada aplikasi mobile Usago menyediakan fungsionalitas lengkap untuk manajemen brand, termasuk CRUD operations, invitation system, dan brand switching. Fitur ini mengimplementasikan Clean Architecture dengan BLoC pattern untuk state management.

## Struktur File

```
apps/mobile/lib/features/brand/
├── domain/
│   ├── entities/
│   │   ├── brand.dart              # Brand entity
│   │   └── brand_invitation.dart   # BrandInvitation entity
│   └── repositories/
│       └── brand_repository.dart     # Abstract repository interface
├── data/
│   ├── datasources/
│   │   ├── brand_remote_datasource.dart      # Abstract datasource interface
│   │   └── brand_remote_datasource_impl.dart # Remote datasource implementation
│   ├── models/
│   │   ├── brand_model.dart               # Brand model for JSON serialization
│   │   └── brand_invitation_model.dart    # BrandInvitation model for JSON serialization
│   └── repositories/
│       └── brand_repository_impl.dart     # Repository implementation
├── presentation/
│   ├── bloc/
│   │   ├── brand_bloc.dart              # Brand BLoC for state management
│   │   ├── brand_event.dart             # Brand events
│   │   └── brand_state.dart            # Brand states
│   ├── pages/
│   │   ├── brand_selection_page.dart     # Brand selection page
│   │   ├── create_brand_page.dart       # Create brand page
│   │   ├── edit_brand_page.dart         # Edit brand page
│   │   ├── brand_invitation_list_page.dart # Invitation list page
│   │   ├── brand_stats_page.dart       # Brand statistics page
│   │   └── brand_transfer_page.dart    # Brand transfer page
│   └── widgets/
│       ├── brand_card.dart              # Brand card widget
│       ├── brand_selector.dart          # Brand selector widget
│       ├── create_brand_form.dart       # Create brand form
│       ├── invite_user_form.dart        # Invite user form
│       ├── invitation_card.dart        # Invitation card widget
│       └── brand_card_skeleton.dart    # Loading skeleton
└── README.md                         # Dokumentasi ini
```

## Entity Models

### Brand

```dart
class Brand extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String ownerId;
  final String? logoUrl;
  final String businessType;
  final String? industry;
  final String? description;
  final Map<String, dynamic> settings;
  final String timezone;
  final String currency;
  final String subscriptionTier;
  final String subscriptionStatus;
  final DateTime? subscriptionExpiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Constructor, copyWith, getters, and props...
}
```

### BrandInvitation

```dart
class BrandInvitation extends Equatable {
  final String id;
  final String brandId;
  final String brandName;
  final String inviterId;
  final String inviterName;
  final String inviteeEmail;
  final String role;
  final String status;
  final List<String> branchIds;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Constructor, copyWith, getters, and props...
}
```

## Data Models

### BrandModel

```dart
@JsonSerializable()
class BrandModel extends Brand {
  const BrandModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.ownerId,
    super.logoUrl,
    required super.businessType,
    super.industry,
    super.description,
    required super.settings,
    required super.timezone,
    required super.currency,
    required super.subscriptionTier,
    required super.subscriptionStatus,
    super.subscriptionExpiresAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandModelToJson(this);

  Brand toEntity() => Brand(/* ... */);
}
```

### BrandInvitationModel

```dart
@JsonSerializable(includeIfNull: false)
class BrandInvitationModel extends BrandInvitation {
  const BrandInvitationModel({
    required super.id,
    required super.brandId,
    required super.brandName,
    required super.inviterId,
    required super.inviterName,
    required super.inviteeEmail,
    required super.role,
    required super.status,
    @JsonKey(defaultValue: []) final super.branchIds,
    super.expiresAt,
    required super.createdAt,
    super.updatedAt,
  });

  factory BrandInvitationModel.fromJson(Map<String, dynamic> json) {
    // Handle backward compatibility and field mapping
    final id = json['id'] ?? json['invitationId'] ?? '';
    final inviterId = json['inviterId'] ?? '';
    final inviteeEmail = json['inviteeEmail'] ?? json['email'] ?? '';
    final status = json['status'] ?? 'PENDING';

    return BrandInvitationModel(/* ... */);
  }

  Map<String, dynamic> toJson() => _$BrandInvitationModelToJson(this);

  BrandInvitation toEntity() => BrandInvitation(/* ... */);
}
```

## Repository Pattern

### Abstract Repository

```dart
abstract class BrandRepository {
  Future<Either<Failure, List<Brand>>> getUserBrands();
  Future<Either<Failure, List<Brand>>> getAccessibleBrands();
  Future<Either<Failure, Brand>> getBrandById(String id);
  Future<Either<Failure, Brand>> getBrandBySlug(String slug);
  Future<Either<Failure, Brand>> createBrand(Map<String, dynamic> brandData);
  Future<Either<Failure, Brand>> updateBrand(String id, Map<String, dynamic> brandData);
  Future<Either<Failure, void>> deleteBrand(String id);
  Future<Either<Failure, Brand>> switchActiveBrand(String brandId);
  Future<Either<Failure, void>> transferOwnership(String brandId, String newOwnerId, String confirmationCode);
  Future<Either<Failure, BrandInvitation>> inviteUser(String brandId, Map<String, dynamic> invitationData);
  Future<Either<Failure, void>> acceptInvitation(String invitationId, String token);
  Future<Either<Failure, void>> declineInvitation(String invitationId);
  Future<Either<Failure, List<BrandInvitation>>> getBrandInvitations(String brandId);
  Future<Either<Failure, List<BrandInvitation>>> getUserInvitations();
  Future<Either<Failure, void>> cancelInvitation(String invitationId);
  Future<Either<Failure, void>> resendInvitation(String invitationId);
  Future<Either<Failure, Map<String, dynamic>>> getBrandStats(String brandId);
  Future<Either<Failure, Brand?>> getActiveBrand();
  // Cache and storage methods...
}
```

### Repository Implementation

```dart
class BrandRepositoryImpl implements BrandRepository {
  final BrandRemoteDataSource _remoteDataSource;
  final AppLogger _logger;

  BrandRepositoryImpl(this._remoteDataSource, this._logger);

  @override
  Future<Either<Failure, List<Brand>>> getUserBrands() async {
    try {
      final brands = await _remoteDataSource.getUserBrands();
      return Right(brands);
    } catch (e) {
      _logger.error('Failed to get user brands: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Brand>> createBrand(Map<String, dynamic> brandData) async {
    try {
      final brand = await _remoteDataSource.createBrand(brandData);
      return Right(brand);
    } catch (e) {
      _logger.error('Failed to create brand: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  // Other method implementations...
}
```

## Remote Data Source

### Abstract Interface

```dart
abstract class BrandRemoteDataSource {
  Future<List<Brand>> getUserBrands();
  Future<List<Brand>> getAccessibleBrands();
  Future<Brand> getBrandById(String id);
  Future<Brand> getBrandBySlug(String slug);
  Future<Brand> createBrand(Map<String, dynamic> brandData);
  Future<Brand> updateBrand(String id, Map<String, dynamic> brandData);
  Future<void> deleteBrand(String id);
  Future<Brand> switchActiveBrand(String brandId);
  Future<void> transferOwnership(String brandId, String newOwnerId, String confirmationCode);
  Future<BrandInvitation> inviteUser(String brandId, Map<String, dynamic> invitationData);
  Future<void> acceptInvitation(String invitationId, String token);
  Future<void> declineInvitation(String invitationId);
  Future<List<BrandInvitation>> getBrandInvitations(String brandId);
  Future<List<BrandInvitation>> getUserInvitations();
  Future<void> cancelInvitation(String invitationId);
  Future<void> resendInvitation(String invitationId);
  Future<Map<String, dynamic>> getBrandStats(String brandId);
}
```

### Implementation with Dio

```dart
class BrandRemoteDataSourceImpl implements BrandRemoteDataSource {
  final DioClient _dioClient;
  final AppLogger _logger;

  BrandRemoteDataSourceImpl(DioClient dioClient, AppLogger logger)
      : _dioClient = dioClient,
        _logger = logger;

  @override
  Future<List<Brand>> getUserBrands() async {
    try {
      final response = await _dioClient.get(BrandEndpoints.getUserBrands);

      final List<dynamic> dataList = response['data'] ?? [];
      final List<Brand> brands = dataList
          .map((json) => BrandModel.fromJson(json).toEntity())
          .toList();

      _logger.info('Successfully fetched ${brands.length} user brands');
      return brands;
    } on DioException catch (e) {
      _logger.error('Dio error in getUserBrands: $e');
      throw ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      );
    } catch (e) {
      _logger.error('Unexpected error in getUserBrands: $e');
      throw ServerFailure(
        message: e.toString(),
        originalError: e,
      );
    }
  }

  @override
  Future<Brand> createBrand(Map<String, dynamic> brandData) async {
    try {
      final response = await _dioClient.post(
        BrandEndpoints.createBrand,
        data: brandData,
      );

      final brand = BrandModel.fromJson(response['data']).toEntity();

      _logger.info('Successfully created brand: ${brand.name}');
      return brand;
    } on DioException catch (e) {
      _logger.error('Dio error in createBrand: $e');
      throw ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      );
    } catch (e) {
      _logger.error('Unexpected error in createBrand: $e');
      throw ServerFailure(
        message: e.toString(),
        originalError: e,
      );
    }
  }

  // Other method implementations...
}
```

## BLoC State Management

### Events

```dart
abstract class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object> get props => [];
}

class LoadUserBrandsEvent extends BrandEvent {}

class CreateBrandEvent extends BrandEvent {
  final Map<String, dynamic> brandData;

  const CreateBrandEvent(this.brandData);

  @override
  List<Object> get props => [brandData];
}

class UpdateBrandEvent extends BrandEvent {
  final String brandId;
  final Map<String, dynamic> brandData;

  const UpdateBrandEvent(this.brandId, this.brandData);

  @override
  List<Object> get props => [brandId, brandData];
}

class SwitchBrandEvent extends BrandEvent {
  final String brandId;

  const SwitchBrandEvent(this.brandId);

  @override
  List<Object> get props => [brandId];
}

class InviteUserEvent extends BrandEvent {
  final String brandId;
  final Map<String, dynamic> invitationData;

  const InviteUserEvent(this.brandId, this.invitationData);

  @override
  List<Object> get props => [brandId, invitationData];
}

// Other events...
```

### States

```dart
abstract class BrandState extends Equatable {
  const BrandState();

  @override
  List<Object> get props => [];
}

class BrandInitial extends BrandState {}

class BrandLoading extends BrandState {}

class BrandLoaded extends BrandState {
  final List<Brand> userBrands;
  final List<Brand> accessibleBrands;
  final Brand? activeBrand;

  const BrandLoaded({
    required this.userBrands,
    required this.accessibleBrands,
    this.activeBrand,
  });

  @override
  List<Object> get props => [userBrands, accessibleBrands, activeBrand];
}

class BrandOperationSuccess extends BrandState {
  final String message;

  const BrandOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class BrandError extends BrandState {
  final String message;

  const BrandError(this.message);

  @override
  List<Object> get props => [message];
}
```

### BLoC Implementation

```dart
class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository _brandRepository;

  BrandBloc({required BrandRepository brandRepository})
      : _brandRepository = brandRepository,
        super(const BrandInitial()) {
    on<LoadUserBrandsEvent>(_onLoadUserBrandsEvent);
    on<CreateBrandEvent>(_onCreateBrandEvent);
    on<UpdateBrandEvent>(_onUpdateBrandEvent);
    on<SwitchBrandEvent>(_onSwitchBrandEvent);
    on<InviteUserEvent>(_onInviteUserEvent);
    on<AcceptInvitationEvent>(_onAcceptInvitationEvent);
    on<DeclineInvitationEvent>(_onDeclineInvitationEvent);
    on<SearchBrandsEvent>(_onSearchBrandsEvent);
    // Other event handlers...
  }

  Future<void> _onLoadUserBrandsEvent(LoadUserBrandsEvent event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());

    final userBrandsResult = await _brandRepository.getUserBrands();
    final accessibleBrandsResult = await _brandRepository.getAccessibleBrands();
    final activeBrandResult = await _brandRepository.getActiveBrand();

    final userBrands = userBrandsResult.fold((failure) => <Brand>[], (brands) => brands);
    final accessibleBrands = accessibleBrandsResult.fold((failure) => <Brand>[], (brands) => brands);
    final activeBrand = activeBrandResult.fold((failure) => null as Brand?, (brand) => brand);

    if (userBrandsResult.isLeft() && accessibleBrandsResult.isLeft()) {
      final failure = userBrandsResult.fold((failure) => failure, (_) => null as dynamic);
      emit(BrandError(failure?.message ?? 'Failed to load brands'));
    } else {
      emit(BrandLoaded(
        userBrands: userBrands,
        accessibleBrands: accessibleBrands,
        activeBrand: activeBrand,
      ));
    }
  }

  Future<void> _onCreateBrandEvent(CreateBrandEvent event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());

    final result = await _brandRepository.createBrand(event.brandData);

    emit(result.fold(
      (failure) => BrandError(failure.message),
      (brand) {
        // Reload brands after successful creation
        add(LoadUserBrandsEvent());
        return BrandOperationSuccess('Brand created successfully');
      },
    ));
  }

  // Other event handlers...
}
```

## UI Components

### Brand Card Widget

```dart
class BrandCard extends StatelessWidget {
  final Brand brand;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const BrandCard({
    Key? key,
    required this.brand,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: brand.hasLogo
            ? Image.network(brand.logoUrl!)
            : CircleAvatar(child: Text(brand.name[0])),
        title: Text(brand.name),
        subtitle: Text(brand.formattedBusinessType),
        trailing: showActions
            ? PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                    onTap: onEdit,
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                    onTap: onDelete,
                  ),
                ],
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
```

### Brand Selector Widget

```dart
class BrandSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandBloc, BrandState>(
      builder: (context, state) {
        if (state is BrandLoaded) {
          final userContext = context.watch<ContextBloc>().state;
          final brands = state.userBrands;
          final activeBrand = state.activeBrand;

          return PopupMenuButton(
            child: Row(
              children: [
                Text(activeBrand?.name ?? 'Select Brand'),
                Icon(Icons.arrow_drop_down),
              ],
            ),
            itemBuilder: (context) {
              return brands.map((brand) {
                return PopupMenuItem(
                  value: brand,
                  child: Text(brand.name),
                  onTap: () => _selectBrand(context, brand),
                );
              }).toList();
            },
          );
        }

        return Container();
      },
    );
  }

  void _selectBrand(BuildContext context, Brand brand) {
    context.read<BrandBloc>().add(SwitchBrandEvent(brand.id));
  }
}
```

### Create Brand Form

```dart
class CreateBrandForm extends StatefulWidget {
  @override
  _CreateBrandFormState createState() => _CreateBrandFormState();
}

class _CreateBrandFormState extends State<CreateBrandForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _industryController = TextEditingController();
  final _addressController = TextEditingController();
  String _businessType = 'SERVICE';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Brand Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Brand name is required';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _slugController,
            decoration: InputDecoration(labelText: 'Brand Slug'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Brand slug is required';
              }
              return null;
            },
          ),
          DropdownButtonFormField(
            value: _businessType,
            decoration: InputDecoration(labelText: 'Business Type'),
            items: ['SERVICE', 'RETAIL', 'MANUFACTURING', 'OTHER']
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _businessType = value!;
              });
            },
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
          TextFormField(
            controller: _industryController,
            decoration: InputDecoration(labelText: 'Industry'),
          ),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'Business Address'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Create Brand'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final brandData = {
        'name': _nameController.text,
        'slug': _slugController.text,
        'businessType': _businessType,
        'industry': _industryController.text,
        'description': _descriptionController.text,
        'businessAddress': _addressController.text,
        'timezone': 'Asia/Jakarta',
        'currency': 'IDR',
      };

      context.read<BrandBloc>().add(CreateBrandEvent(brandData));
    }
  }
}
```

## Context Headers Implementation

### Dio Client with Context Headers

```dart
class AuthInterceptor extends Interceptor {
  final AppLogger _logger;

  AuthInterceptor({required AppLogger logger}) : _logger = logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add auth token if available
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.bearerTokenKey);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add context headers
    final contextManager = ContextManager();
    final context = contextManager.currentContext;

    if (context != null) {
      options.headers['X-Active-Brand-ID'] = context.activeBrand?.id ?? '';
      options.headers['X-Active-Branch-ID'] = context.activeBranch?.id ?? '';
      options.headers['X-User-Role'] = context.role.name;
    } else {
      // Handle case where context is null with default values
      options.headers['X-Active-Brand-ID'] = '';
      options.headers['X-Active-Branch-ID'] = '';
      options.headers['X-User-Role'] = '';
    }

    handler.next(options);
  }
}
```

## Search Implementation

### Search in BLoC

```dart
Future<void> _onSearchBrandsEvent(SearchBrandsEvent event, Emitter<BrandState> emit) async {
  emit(const BrandSearchLoading());

  // For now, we'll simulate search by filtering existing brands
  final currentState = state;
  if (currentState is BrandLoaded) {
    final allBrands = <Brand>[...currentState.userBrands, ...currentState.accessibleBrands];

    // Filter brands based on query
    final filteredBrands = allBrands.where((brand) {
      final nameMatch = brand.name.toLowerCase().contains(event.query.toLowerCase());
      final slugMatch = brand.slug.toLowerCase().contains(event.query.toLowerCase());
      final descriptionMatch = brand.description?.toLowerCase().contains(event.query.toLowerCase()) ?? false;

      return nameMatch || slugMatch || descriptionMatch;
    }).toList();

    await Future.delayed(const Duration(milliseconds: 300)); // Simulate search delay

    emit(BrandSearchLoaded(
      searchResults: filteredBrands,
      query: event.query,
      filters: event.filters,
    ));
  } else {
    // If no brands are loaded, return empty results
    await Future.delayed(const Duration(milliseconds: 300));
    emit(BrandSearchLoaded(
      searchResults: [],
      query: event.query,
      filters: event.filters,
    ));
  }
}
```

## Error Handling

### Error Types

```dart
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  final dynamic originalError;

  const ServerFailure({
    required String message,
    int? statusCode,
    this.originalError,
  }) : super(message: message, statusCode: statusCode);
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
}

class ValidationFailure extends Failure {
  final Map<String, String> fieldErrors;

  const ValidationFailure({
    required String message,
    required this.fieldErrors,
  }) : super(message: message);
}
```

### Error Handling in UI

```dart
BlocBuilder<BrandBloc, BrandState>(
  builder: (context, state) {
    if (state is BrandError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Error: ${state.message}',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<BrandBloc>().add(LoadUserBrandsEvent()),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is BrandLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Other states...
  },
)
```

## Usage Examples

### Dependency Injection

```dart
// In injection_container.dart
final sl = GetIt.instance;

Future<void> init() async {
  // External
  final dio = Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl));
  final sharedPreferences = await SharedPreferences.getInstance();

  // Core
  sl.registerLazySingleton(() => dio);
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DioClient(dio: dio));
  sl.registerLazySingleton(() => AppLogger());
  sl.registerLazySingleton(() => ContextManager());

  // Features - Brand
  sl.registerLazySingleton<BrandRemoteDataSource>(
    () => BrandRemoteDataSourceImpl(sl<DioClient>(), sl<AppLogger>()),
  );

  sl.registerLazySingleton<BrandRepository>(
    () => BrandRepositoryImpl(sl<BrandRemoteDataSource>(), sl<AppLogger>()),
  );

  sl.registerFactory<BrandBloc>(
    () => BrandBloc(brandRepository: sl<BrandRepository>()),
  );
}
```

### Using Brand BLoC in UI

```dart
class BrandListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brands'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateBrandPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<BrandBloc, BrandState>(
        builder: (context, state) {
          if (state is BrandInitial) {
            context.read<BrandBloc>().add(LoadUserBrandsEvent());
            return Center(child: CircularProgressIndicator());
          }

          if (state is BrandLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is BrandLoaded) {
            final brands = state.userBrands;

            if (brands.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.business, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No brands found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateBrandPage()),
                        );
                      },
                      child: Text('Create Your First Brand'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return BrandCard(
                  brand: brand,
                  onTap: () {
                    // Navigate to brand details
                  },
                  showActions: true,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBrandPage(brand: brand),
                      ),
                    );
                  },
                  onDelete: () {
                    _showDeleteConfirmation(context, brand);
                  },
                );
              },
            );
          }

          if (state is BrandError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<BrandBloc>().add(LoadUserBrandsEvent()),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Brand brand) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Brand'),
        content: Text('Are you sure you want to delete ${brand.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<BrandBloc>().add(DeleteBrandEvent(brand.id));
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
```

## Testing

### Unit Tests

```dart
// brand_repository_test.dart
void main() {
  group('BrandRepository', () {
    late BrandRepositoryImpl repository;
    late MockBrandRemoteDataSource mockDataSource;
    late MockAppLogger mockLogger;

    setUp(() {
      mockDataSource = MockBrandRemoteDataSource();
      mockLogger = MockAppLogger();
      repository = BrandRepositoryImpl(mockDataSource, mockLogger);
    });

    test('should return list of brands when getUserBrands is called', () async {
      // Arrange
      final testBrands = [testBrand, testBrand2];
      when(mockDataSource.getUserBrands())
          .thenAnswer((_) async => testBrands);

      // Act
      final result = await repository.getUserBrands();

      // Assert
      expect(result, isA<Right<Failure, List<Brand>>>());
      result.fold(
        (failure) => fail('Expected success'),
        (brands) => expect(brands, testBrands),
      );
    });

    test('should return ServerFailure when getUserBrands throws exception', () async {
      // Arrange
      when(mockDataSource.getUserBrands())
          .thenThrow(ServerException('Server error'));

      // Act
      final result = await repository.getUserBrands();

      // Assert
      expect(result, isA<Left<Failure, List<Brand>>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (brands) => fail('Expected failure'),
      );
    });
  });
}
```

### Widget Tests

```dart
// brand_card_test.dart
void main() {
  group('BrandCard', () {
    testWidgets('should display brand information correctly', (WidgetTester tester) async {
      // Arrange
      final brand = Brand(
        id: '1',
        name: 'Test Brand',
        slug: 'test-brand',
        ownerId: 'user-1',
        businessType: 'SERVICE',
        settings: {},
        timezone: 'Asia/Jakarta',
        currency: 'IDR',
        subscriptionTier: 'FREE',
        subscriptionStatus: 'ACTIVE',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BrandCard(brand: brand),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Brand'), findsOneWidget);
      expect(find.text('Layanan'), findsOneWidget); // formatted business type
    });
  });
}
```

## Performance Considerations

### Pagination

```dart
// Implement pagination for large brand lists
class BrandPaginationController {
  final ScrollController scrollController = ScrollController();
  final List<Brand> brands = [];
  bool isLoading = false;
  int currentPage = 1;
  final int pageSize = 20;
  bool hasMore = true;

  void loadMoreBrands() {
    if (isLoading || !hasMore) return;

    isLoading = true;
    // Fetch next page
    // Add to brands list
    isLoading = false;
    currentPage++;
  }

  void reset() {
    brands.clear();
    currentPage = 1;
    hasMore = true;
    isLoading = false;
  }
}
```

### Caching

```dart
// Implement caching for brand data
class BrandCache {
  static const String _cacheKey = 'cached_brands';
  static const Duration _cacheExpiry = Duration(hours: 1);

  static Future<void> cacheBrands(List<Brand> brands) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'brands': brands.map((b) => BrandModel.fromEntity(b).toJson()).toList(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await prefs.setString(_cacheKey, jsonEncode(cacheData));
  }

  static Future<List<Brand>?> getCachedBrands() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheString = prefs.getString(_cacheKey);

    if (cacheString == null) return null;

    final cacheData = jsonDecode(cacheString);
    final timestamp = cacheData['timestamp'];
    final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;

    if (cacheAge > _cacheExpiry.inMilliseconds) {
      await prefs.remove(_cacheKey);
      return null;
    }

    final brandsJson = cacheData['brands'] as List;
    return brandsJson.map((json) => BrandModel.fromJson(json).toEntity()).toList();
  }
}
```

## Related Documentation

- [Brand API Documentation](../../../../docs/06-Data-API/06-Brand-API-Documentation.md) - Complete API documentation
- [Mobile Flow Context Management](../../../../docs/12-Final-Implementation-Roadmap/mobile-docs/02-Mobile-Flow-Context-Management.md) - Context management
- [API Endpoints Structure](../../../../docs/12-Final-Implementation-Roadmap/mobile-docs/01-API-Endpoints-Structure.md) - API endpoints
- [Core Network Client](../core/network/dio_client.dart) - HTTP client implementation
- [Context Manager](../core/context/context_manager.dart) - Context management

---

**Last Updated**: November 19, 2025
**Maintainer**: Mobile Development Team
**Version**: 1.0.0