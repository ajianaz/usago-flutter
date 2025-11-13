# 🛠️ Brand & Branch Implementation Guide
## Step-by-Step Mobile Development

## 📋 Overview

Guide ini menyediakan implementasi detail untuk **Brand & Branch features** di aplikasi mobile Usago, dengan fokus pada kode yang siap digunakan dan best practices untuk Flutter development.

## 🎯 Implementation Priorities

### Phase 1: Brand Management (Week 1-2)
- Brand creation dengan automatic main branch
- Brand selection dan switching
- Brand ownership transfer
- Brand invitation system

### Phase 2: Branch Management (Week 3-4)
- Branch creation dengan hierarchy
- Branch selection dan switching
- Branch user role management
- Branch operations dashboard

### Phase 3: Integration & Testing (Week 5-6)
- End-to-end testing
- Performance optimization
- Error handling
- Documentation update

---

## 🏢 Phase 1: Brand Management Implementation

### 1.1 Brand Data Models

#### Brand Entity
```dart
// lib/features/brand/domain/entities/brand.dart
import 'package:equatable/equatable.dart';

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
  final DateTime createdAt;
  final DateTime updatedAt;

  const Brand({
    required this.id,
    required this.name,
    required this.slug,
    required this.ownerId,
    this.logoUrl,
    required this.businessType,
    this.industry,
    this.description,
    required this.settings,
    required this.timezone,
    required this.currency,
    required this.subscriptionTier,
    required this.subscriptionStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        ownerId,
        logoUrl,
        businessType,
        industry,
        description,
        settings,
        timezone,
        currency,
        subscriptionTier,
        subscriptionStatus,
        createdAt,
        updatedAt,
      ];

  Brand copyWith({
    String? id,
    String? name,
    String? slug,
    String? ownerId,
    String? logoUrl,
    String? businessType,
    String? industry,
    String? description,
    Map<String, dynamic>? settings,
    String? timezone,
    String? currency,
    String? subscriptionTier,
    String? subscriptionStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      ownerId: ownerId ?? this.ownerId,
      logoUrl: logoUrl ?? this.logoUrl,
      businessType: businessType ?? this.businessType,
      industry: industry ?? this.industry,
      description: description ?? this.description,
      settings: settings ?? this.settings,
      timezone: timezone ?? this.timezone,
      currency: currency ?? this.currency,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

#### Brand Model (API Response)
```dart
// lib/features/brand/data/models/brand_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../entities/brand.dart';

part 'brand_model.g.dart';

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
    required super.createdAt,
    required super.updatedAt,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandModelToJson(this);

  Brand toEntity() => Brand(
        id: id,
        name: name,
        slug: slug,
        ownerId: ownerId,
        logoUrl: logoUrl,
        businessType: businessType,
        industry: industry,
        description: description,
        settings: settings,
        timezone: timezone,
        currency: currency,
        subscriptionTier: subscriptionTier,
        subscriptionStatus: subscriptionStatus,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
```

### 1.2 Brand Repository

#### Brand Repository Interface
```dart
// lib/features/brand/domain/repositories/brand_repository.dart
import '../entities/brand.dart';
import '../entities/brand_invitation.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';

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
  Future<Either<Failure, Map<String, dynamic>>> getBrandStats(String brandId);
}
```

#### Brand Repository Implementation
```dart
// lib/features/brand/data/repositories/brand_repository_impl.dart
import '../../domain/entities/brand.dart';
import '../../domain/entities/brand_invitation.dart';
import '../../domain/repositories/brand_repository.dart';
import '../datasources/brand_remote_datasource.dart';
import '../datasources/brand_local_datasource.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/logger.dart';

class BrandRepositoryImpl implements BrandRepository {
  final BrandRemoteDataSource remoteDataSource;
  final BrandLocalDataSource localDataSource;

  BrandRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Brand>>> getUserBrands() async {
    try {
      final brands = await remoteDataSource.getUserBrands();
      await localDataSource.cacheBrands(brands);
      return Right(brands);
    } catch (e) {
      Logger.error('Error getting user brands', error: e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Brand>>> getAccessibleBrands() async {
    try {
      final brands = await remoteDataSource.getAccessibleBrands();
      await localDataSource.cacheBrands(brands);
      return Right(brands);
    } catch (e) {
      Logger.error('Error getting accessible brands', error: e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Brand>> createBrand(Map<String, dynamic> brandData) async {
    try {
      final brand = await remoteDataSource.createBrand(brandData);
      await localDataSource.cacheBrand(brand);
      return Right(brand);
    } catch (e) {
      Logger.error('Error creating brand', error: e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Brand>> switchActiveBrand(String brandId) async {
    try {
      final brand = await remoteDataSource.switchActiveBrand(brandId);
      await localDataSource.saveActiveBrand(brandId);
      return Right(brand);
    } catch (e) {
      Logger.error('Error switching active brand', error: e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BrandInvitation>> inviteUser(String brandId, Map<String, dynamic> invitationData) async {
    try {
      final invitation = await remoteDataSource.inviteUser(brandId, invitationData);
      return Right(invitation);
    } catch (e) {
      Logger.error('Error inviting user', error: e);
      return Left(ServerFailure(e.toString()));
    }
  }

  // ... other implementations
}
```

### 1.3 Brand BLoC

#### Brand Events
```dart
// lib/features/brand/presentation/bloc/brand_event.dart
part of 'brand_bloc.dart';

abstract class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object> get props => [];
}

class LoadUserBrandsEvent extends BrandEvent {}

class LoadAccessibleBrandsEvent extends BrandEvent {}

class CreateBrandEvent extends BrandEvent {
  final Map<String, dynamic> brandData;

  const CreateBrandEvent(this.brandData);

  @override
  List<Object> get props => [brandData];
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

class AcceptInvitationEvent extends BrandEvent {
  final String invitationId;
  final String token;

  const AcceptInvitationEvent(this.invitationId, this.token);

  @override
  List<Object> get props => [invitationId, token];
}
```

#### Brand States
```dart
// lib/features/brand/presentation/bloc/brand_state.dart
part of 'brand_bloc.dart';

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

#### Brand BLoC Implementation
```dart
// lib/features/brand/presentation/bloc/brand_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/brand.dart';
import '../../domain/repositories/brand_repository.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';

part 'brand_event.dart';
part 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository _brandRepository;

  BrandBloc(this._brandRepository) : super(BrandInitial()) {
    on<LoadUserBrandsEvent>(_onLoadUserBrands);
    on<LoadAccessibleBrandsEvent>(_onLoadAccessibleBrands);
    on<CreateBrandEvent>(_onCreateBrand);
    on<SwitchBrandEvent>(_onSwitchBrand);
    on<InviteUserEvent>(_onInviteUser);
    on<AcceptInvitationEvent>(_onAcceptInvitation);
  }

  Future<void> _onLoadUserBrands(
    LoadUserBrandsEvent event,
    Emitter<BrandState> emit,
  ) async {
    emit(BrandLoading());
    final result = await _brandRepository.getUserBrands();

    result.fold(
      (failure) => emit(BrandError(failure.message)),
      (brands) => emit(BrandLoaded(
        userBrands: brands,
        accessibleBrands: brands,
      )),
    );
  }

  Future<void> _onCreateBrand(
    CreateBrandEvent event,
    Emitter<BrandState> emit,
  ) async {
    emit(BrandLoading());
    final result = await _brandRepository.createBrand(event.brandData);

    result.fold(
      (failure) => emit(BrandError(failure.message)),
      (brand) {
        emit(BrandOperationSuccess('Brand created successfully'));
        add(LoadUserBrandsEvent());
      },
    );
  }

  Future<void> _onSwitchBrand(
    SwitchBrandEvent event,
    Emitter<BrandState> emit,
  ) async {
    emit(BrandLoading());
    final result = await _brandRepository.switchActiveBrand(event.brandId);

    result.fold(
      (failure) => emit(BrandError(failure.message)),
      (brand) {
        emit(BrandOperationSuccess('Brand switched successfully'));
        add(LoadUserBrandsEvent());
      },
    );
  }

  Future<void> _onInviteUser(
    InviteUserEvent event,
    Emitter<BrandState> emit,
  ) async {
    final result = await _brandRepository.inviteUser(event.brandId, event.invitationData);

    result.fold(
      (failure) => emit(BrandError(failure.message)),
      (invitation) => emit(BrandOperationSuccess('User invited successfully')),
    );
  }

  Future<void> _onAcceptInvitation(
    AcceptInvitationEvent event,
    Emitter<BrandState> emit,
  ) async {
    final result = await _brandRepository.acceptInvitation(event.invitationId, event.token);

    result.fold(
      (failure) => emit(BrandError(failure.message)),
      (_) {
        emit(BrandOperationSuccess('Invitation accepted successfully'));
        add(LoadUserBrandsEvent());
      },
    );
  }
}
```

### 1.4 Brand UI Components

#### Brand Selection Page
```dart
// lib/features/brand/presentation/pages/brand_selection_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/brand_bloc.dart';
import '../widgets/brand_card.dart';
import '../widgets/create_brand_fab.dart';

class BrandSelectionPage extends StatelessWidget {
  const BrandSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Brand'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<BrandBloc, BrandState>(
        builder: (context, state) {
          if (state is BrandLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is BrandError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BrandBloc>().add(LoadUserBrandsEvent());
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (state is BrandLoaded) {
            if (state.userBrands.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.business_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada brand',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Buat brand pertama Anda untuk memulai',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<BrandBloc>().add(LoadUserBrandsEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.userBrands.length,
                itemBuilder: (context, index) {
                  final brand = state.userBrands[index];
                  return BrandCard(
                    brand: brand,
                    isActive: state.activeBrand?.id == brand.id,
                    onTap: () => _selectBrand(context, brand),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: const CreateBrandFab(),
    );
  }

  void _selectBrand(BuildContext context, Brand brand) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Brand'),
          content: Text('Apakah Anda yakin ingin memilih ${brand.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<BrandBloc>().add(SwitchBrandEvent(brand.id));
              },
              child: const Text('Pilih'),
            ),
          ],
        );
      },
    );
  }
}
```

#### Brand Card Widget
```dart
// lib/features/brand/presentation/widgets/brand_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/brand.dart';

class BrandCard extends StatelessWidget {
  final Brand brand;
  final bool isActive;
  final VoidCallback onTap;

  const BrandCard({
    Key? key,
    required this.brand,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isActive ? 4 : 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isActive
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Brand Logo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                child: brand.logoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          brand.logoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.business,
                              color: Theme.of(context).colorScheme.primary,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.business,
                        color: Theme.of(context).colorScheme.primary,
                      ),
              ),
              const SizedBox(width: 16),
              // Brand Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            brand.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Aktif',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      brand.description ?? 'Tidak ada deskripsi',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildInfoChip(
                          context,
                          brand.businessType,
                          Icons.business,
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          context,
                          brand.currency,
                          Icons.attach_money,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
```

#### Create Brand Form
```dart
// lib/features/brand/presentation/widgets/create_brand_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/brand_bloc.dart';

class CreateBrandForm extends StatefulWidget {
  const CreateBrandForm({Key? key}) : super(key: key);

  @override
  State<CreateBrandForm> createState() => _CreateBrandFormState();
}

class _CreateBrandFormState extends State<CreateBrandForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();

  String _businessType = 'SERVICE';
  String _timezone = 'Asia/Jakarta';
  String _currency = 'IDR';
  bool _isLoading = false;

  final List<String> _businessTypes = [
    'SERVICE',
    'RETAIL',
    'MANUFACTURING',
    'OTHER',
  ];

  final List<String> _timezones = [
    'Asia/Jakarta',
    'Asia/Surabaya',
    'Asia/Makassar',
    'Asia/Jayapura',
  ];

  final List<String> _currencies = [
    'IDR',
    'USD',
    'EUR',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Brand Baru'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<BrandBloc, BrandState>(
        listener: (context, state) {
          if (state is BrandLoading) {
            setState(() {
              _isLoading = true;
            });
          } else {
            setState(() {
              _isLoading = false;
            });
          }

          if (state is BrandOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          }

          if (state is BrandError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Brand Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Brand',
                    hintText: 'Masukkan nama brand Anda',
                    prefixIcon: Icon(Icons.business),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama brand wajib diisi';
                    }
                    if (value.length > 100) {
                      return 'Nama brand maksimal 100 karakter';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Auto-generate slug from name
                    if (_slugController.text.isEmpty) {
                      _slugController.text = value
                          .toLowerCase()
                          .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
                          .replaceAll(RegExp(r'\s+'), '-')
                          .replaceAll(RegExp(r'-+'), '-')
                          .replaceAll(RegExp(r'^-|-$'), '');
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Brand Slug
                TextFormField(
                  controller: _slugController,
                  decoration: const InputDecoration(
                    labelText: 'Slug',
                    hintText: 'nama-brand-anda',
                    prefixIcon: Icon(Icons.link),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Slug wajib diisi';
                    }
                    if (value.length > 100) {
                      return 'Slug maksimal 100 karakter';
                    }
                    if (!RegExp(r'^[a-z0-9-]+$').hasMatch(value)) {
                      return 'Slug hanya boleh mengandung huruf kecil, angka, dan dash';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Business Type
                DropdownButtonFormField<String>(
                  value: _businessType,
                  decoration: const InputDecoration(
                    labelText: 'Tipe Bisnis',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  items: _businessTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _businessType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    hintText: 'Deskripsikan brand Anda',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Address
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Alamat Bisnis',
                    hintText: 'Masukkan alamat bisnis Anda',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Timezone
                DropdownButtonFormField<String>(
                  value: _timezone,
                  decoration: const InputDecoration(
                    labelText: 'Zona Waktu',
                    prefixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                  ),
                  items: _timezones.map((timezone) {
                    return DropdownMenuItem(
                      value: timezone,
                      child: Text(timezone),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _timezone = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Currency
                DropdownButtonFormField<String>(
                  value: _currency,
                  decoration: const InputDecoration(
                    labelText: 'Mata Uang',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                  ),
                  items: _currencies.map((currency) {
                    return DropdownMenuItem(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _currency = value!;
                    });
                  },
                ),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Buat Brand',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final brandData = {
        'name': _nameController.text.trim(),
        'slug': _slugController.text.trim(),
        'businessType': _businessType,
        'description': _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        'businessAddress': _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        'timezone': _timezone,
        'currency': _currency,
      };

      context.read<BrandBloc>().add(CreateBrandEvent(brandData));
    }
  }
}
```

---

## 🏪 Phase 2: Branch Management Implementation

### 2.1 Branch Data Models

#### Branch Entity
```dart
// lib/features/branch/domain/entities/branch.dart
import 'package:equatable/equatable.dart';

class Branch extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String brandId;
  final String? address;
  final String? phone;
  final String? email;
  final bool isMainBranch;
  final String? parentBranchId;
  final Map<String, dynamic> settings;
  final String timezone;
  final String currency;
  final Map<String, dynamic>? businessHours;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Branch({
    required this.id,
    required this.name,
    required this.slug,
    required this.brandId,
    this.address,
    this.phone,
    this.email,
    required this.isMainBranch,
    this.parentBranchId,
    required this.settings,
    required this.timezone,
    required this.currency,
    this.businessHours,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        brandId,
        address,
        phone,
        email,
        isMainBranch,
        parentBranchId,
        settings,
        timezone,
        currency,
        businessHours,
        latitude,
        longitude,
        createdAt,
        updatedAt,
      ];

  Branch copyWith({
    String? id,
    String? name,
    String? slug,
    String? brandId,
    String? address,
    String? phone,
    String? email,
    bool? isMainBranch,
    String? parentBranchId,
    Map<String, dynamic>? settings,
    String? timezone,
    String? currency,
    Map<String, dynamic>? businessHours,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Branch(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      brandId: brandId ?? this.brandId,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isMainBranch: isMainBranch ?? this.isMainBranch,
      parentBranchId: parentBranchId ?? this.parentBranchId,
      settings: settings ?? this.settings,
      timezone: timezone ?? this.timezone,
      currency: currency ?? this.currency,
      businessHours: businessHours ?? this.businessHours,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

### 2.2 Branch Repository Implementation

#### Branch Repository Interface
```dart
// lib/features/branch/domain/repositories/branch_repository.dart
import '../entities/branch.dart';
import '../entities/branch_user_role.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';

abstract class BranchRepository {
  Future<Either<Failure, List<Branch>>> getUserAccessibleBranches();
  Future<Either<Failure, List<Branch>>> getBranchesByBrand(String brandId);
  Future<Either<Failure, Branch>> getBranchById(String id);
  Future<Either<Failure, Branch>> getBranchBySlug(String slug);
  Future<Either<Failure, Branch>> createBranch(Map<String, dynamic> branchData);
  Future<Either<Failure, Branch>> updateBranch(String id, Map<String, dynamic> branchData);
  Future<Either<Failure, void>> deleteBranch(String id);
  Future<Either<Failure, Branch>> switchActiveBranch(String branchId);
  Future<Either<Failure, List<Branch>>> getBranchHierarchy(String brandId);
  Future<Either<Failure, Branch>> updateBranchHierarchy(String branchId, String? parentBranchId);
  Future<Either<Failure, Map<String, dynamic>>> getBranchStats(String branchId);
  Future<Either<Failure, List<BranchUserRole>>> getBranchUserRoles(String branchId);
  Future<Either<Failure, BranchUserRole>> assignUserToBranch(String branchId, Map<String, dynamic> userData);
  Future<Either<Failure, BranchUserRole>> updateUserBranchRole(String roleId, Map<String, dynamic> userData);
  Future<Either<Failure, void>> removeUserBranchRole(String roleId);
}
```

### 2.3 Branch BLoC Implementation

#### Branch Events
```dart
// lib/features/branch/presentation/bloc/branch_event.dart
part of 'branch_bloc.dart';

abstract class BranchEvent extends Equatable {
  const BranchEvent();

  @override
  List<Object> get props => [];
}

class LoadBranchesEvent extends BranchEvent {
  final String brandId;

  const LoadBranchesEvent(this.brandId);

  @override
  List<Object> get props => [brandId];
}

class CreateBranchEvent extends BranchEvent {
  final Map<String, dynamic> branchData;

  const CreateBranchEvent(this.branchData);

  @override
  List<Object> get props => [branchData];
}

class SwitchBranchEvent extends BranchEvent {
  final String branchId;

  const SwitchBranchEvent(this.branchId);

  @override
  List<Object> get props => [branchId];
}

class LoadBranchHierarchyEvent extends BranchEvent {
  final String brandId;

  const LoadBranchHierarchyEvent(this.brandId);

  @override
  List<Object> get props => [brandId];
}

class AssignUserToBranchEvent extends BranchEvent {
  final String branchId;
  final Map<String, dynamic> userData;

  const AssignUserToBranchEvent(this.branchId, this.userData);

  @override
  List<Object> get props => [branchId, userData];
}
```

### 2.4 Branch UI Components

#### Branch Selection Page
```dart
// lib/features/branch/presentation/pages/branch_selection_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/branch_bloc.dart';
import '../widgets/branch_card.dart';
import '../widgets/create_branch_fab.dart';

class BranchSelectionPage extends StatelessWidget {
  final String brandId;
  final String brandName;

  const BranchSelectionPage({
    Key? key,
    required this.brandId,
    required this.brandName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cabang - $brandName'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<BranchBloc, BranchState>(
        builder: (context, state) {
          if (state is BranchLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is BranchError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BranchBloc>().add(LoadBranchesEvent(brandId));
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (state is BranchLoaded) {
            if (state.branches.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.store_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada cabang',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Buat cabang pertama Anda untuk memulai',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<BranchBloc>().add(LoadBranchesEvent(brandId));
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.branches.length,
                itemBuilder: (context, index) {
                  final branch = state.branches[index];
                  return BranchCard(
                    branch: branch,
                    isActive: state.activeBranch?.id == branch.id,
                    onTap: () => _selectBranch(context, branch),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: CreateBranchFab(brandId: brandId),
    );
  }

  void _selectBranch(BuildContext context, Branch branch) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Cabang'),
          content: Text('Apakah Anda yakin ingin memilih ${branch.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<BranchBloc>().add(SwitchBranchEvent(branch.id));
              },
              child: const Text('Pilih'),
            ),
          ],
        );
      },
    );
  }
}
```

---

## 💳 Phase 3: Wallet Preparation

### 3.1 Wallet Data Models (Preparation)

#### Wallet Entity
```dart
// lib/features/wallet/domain/entities/wallet.dart
import 'package:equatable/equatable.dart';

enum WalletType {
  operational,
  savings,
  project,
  community,
  personal,
  customer,
  supplier,
  escrow,
}

class Wallet extends Equatable {
  final String id;
  final String name;
  final WalletType type;
  final String? description;
  final double balance;
  final double availableBalance;
  final String currency;
  final String brandId;
  final String branchId;
  final Map<String, dynamic> settings;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Wallet({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    required this.balance,
    required this.availableBalance,
    required this.currency,
    required this.brandId,
    required this.branchId,
    required this.settings,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        description,
        balance,
        availableBalance,
        currency,
        brandId,
        branchId,
        settings,
        isActive,
        createdAt,
        updatedAt,
      ];
}
```

### 3.2 Wallet Repository (Preparation)

#### Wallet Repository Interface
```dart
// lib/features/wallet/domain/repositories/wallet_repository.dart
import '../entities/wallet.dart';
import '../entities/transaction.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/either.dart';

abstract class WalletRepository {
  Future<Either<Failure, List<Wallet>>> getWalletsByBranch(String branchId);
  Future<Either<Failure, Wallet>> getWalletById(String id);
  Future<Either<Failure, Wallet>> createWallet(Map<String, dynamic> walletData);
  Future<Either<Failure, Wallet>> updateWallet(String id, Map<String, dynamic> walletData);
  Future<Either<Failure, void>> deleteWallet(String id);
  Future<Either<Failure, double>> getWalletBalance(String walletId);
  Future<Either<Failure, List<Transaction>>> getWalletTransactions(String walletId);
  Future<Either<Failure, Transaction>> createTransaction(Map<String, dynamic> transactionData);
  Future<Either<Failure, Map<String, dynamic>>> getWalletStats(String walletId);
}
```

---

## 🔧 Integration & Testing

### 4.1 Dependency Injection Setup

#### Brand DI Configuration
```dart
// lib/features/brand/di/brand_injection.dart
import 'package:get_it/get_it.dart';
import '../../domain/repositories/brand_repository.dart';
import '../../data/repositories/brand_repository_impl.dart';
import '../../data/datasources/brand_remote_datasource.dart';
import '../../data/datasources/brand_local_datasource.dart';
import '../../presentation/bloc/brand_bloc.dart';

Future<void> configureBrandDependencies(GetIt sl) async {
  // Data sources
  sl.registerLazySingleton<BrandRemoteDataSource>(
    () => BrandRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<BrandLocalDataSource>(
    () => BrandLocalDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<BrandRepository>(
    () => BrandRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // BLoCs
  sl.registerFactory<BrandBloc>(
    () => BrandBloc(sl()),
  );
}
```

### 4.2 Testing Setup

#### Brand Repository Test
```dart
// test/unit/brand/data/repositories/brand_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import '../../../../../../lib/features/brand/data/repositories/brand_repository_impl.dart';
import '../../../../../../lib/features/brand/data/datasources/brand_remote_datasource.dart';
import '../../../../../../lib/features/brand/data/datasources/brand_local_datasource.dart';
import '../../../../../../lib/features/brand/domain/entities/brand.dart';

import 'brand_repository_impl_test.mocks.dart';

@GenerateMocks([BrandRemoteDataSource, BrandLocalDataSource])
void main() {
  group('BrandRepositoryImpl', () {
    late BrandRepositoryImpl repository;
    late MockBrandRemoteDataSource mockRemoteDataSource;
    late MockBrandLocalDataSource mockLocalDataSource;

    setUp(() {
      mockRemoteDataSource = MockBrandRemoteDataSource();
      mockLocalDataSource = MockBrandLocalDataSource();
      repository = BrandRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
      );
    });

    group('getUserBrands', () {
      test('should return list of brands when remote call succeeds', () async {
        // Arrange
        final brands = [
          const Brand(
            id: '1',
            name: 'Test Brand',
            slug: 'test-brand',
            ownerId: 'user1',
            businessType: 'SERVICE',
            settings: {},
            timezone: 'Asia/Jakarta',
            currency: 'IDR',
            subscriptionTier: 'BASIC',
            subscriptionStatus: 'ACTIVE',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];

        when(mockRemoteDataSource.getUserBrands())
            .thenAnswer((_) async => brands);
        when(mockLocalDataSource.cacheBrands(any))
            .thenAnswer((_) async {});

        // Act
        final result = await repository.getUserBrands();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Expected Right but got Left'),
          (brandsResult) => expect(brandsResult, brands),
        );
        verify(mockRemoteDataSource.getUserBrands()).called(1);
        verify(mockLocalDataSource.cacheBrands(brands)).called(1);
      });

      test('should return failure when remote call fails', () async {
        // Arrange
        when(mockRemoteDataSource.getUserBrands())
            .thenThrow(Exception('Network error'));

        // Act
        final result = await repository.getUserBrands();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Expected Left but got Right'),
        );
        verify(mockRemoteDataSource.getUserBrands()).called(1);
        verifyNever(mockLocalDataSource.cacheBrands(any));
      });
    });
  });
}
```

### 4.3 Integration Testing

#### Brand Flow Integration Test
```dart
// test/integration/brand_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../../lib/features/brand/presentation/pages/brand_selection_page.dart';
import '../../../lib/features/brand/presentation/bloc/brand_bloc.dart';
import '../../../lib/features/brand/domain/entities/brand.dart';

void main() {
  group('Brand Flow Integration Tests', () {
    late BrandBloc mockBrandBloc;

    setUp(() {
      mockBrandBloc = MockBrandBloc();
    });

    testWidgets('should display brand list when brands are loaded', (tester) async {
      // Arrange
      final brands = [
        const Brand(
          id: '1',
          name: 'Test Brand 1',
          slug: 'test-brand-1',
          ownerId: 'user1',
          businessType: 'SERVICE',
          settings: {},
          timezone: 'Asia/Jakarta',
          currency: 'IDR',
          subscriptionTier: 'BASIC',
          subscriptionStatus: 'ACTIVE',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      whenListen(mockBrandBloc, Stream.fromIterable([
        BrandLoaded(userBrands: brands, accessibleBrands: brands),
      ]));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BrandBloc>.value(
            value: mockBrandBloc,
            child: const BrandSelectionPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Pilih Brand'), findsOneWidget);
      expect(find.text('Test Brand 1'), findsOneWidget);
      expect(find.byType(BrandCard), findsOneWidget);
    });

    testWidgets('should display empty state when no brands', (tester) async {
      // Arrange
      whenListen(mockBrandBloc, Stream.fromIterable([
        const BrandLoaded(userBrands: [], accessibleBrands: []),
      ]));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BrandBloc>.value(
            value: mockBrandBloc,
            child: const BrandSelectionPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Belum ada brand'), findsOneWidget);
      expect(find.text('Buat brand pertama Anda untuk memulai'), findsOneWidget);
    });
  });
}
```

---

## 📋 Implementation Checklist

### Phase 1: Brand Management ✅
- [ ] **Brand Data Models**
  - [ ] Brand entity dengan semua properti
  - [ ] Brand model untuk API response
  - [ ] Brand invitation entity
  - [ ] JSON serialization setup

- [ ] **Brand Repository**
  - [ ] Remote data source implementation
  - [ ] Local data source implementation
  - [ ] Repository implementation
  - [ ] Error handling

- [ ] **Brand BLoC**
  - [ ] Events definition
  - [ ] States definition
  - [ ] BLoC implementation
  - [ ] State management

- [ ] **Brand UI Components**
  - [ ] Brand selection page
  - [ ] Brand card widget
  - [ ] Create brand form
  - [ ] Brand selector widget
  - [ ] Loading dan error states

### Phase 2: Branch Management ✅
- [ ] **Branch Data Models**
  - [ ] Branch entity dengan hierarchy support
  - [ ] Branch user role entity
  - [ ] JSON serialization setup

- [ ] **Branch Repository**
  - [ ] Remote data source implementation
  - [ ] Local data source implementation
  - [ ] Repository implementation
  - [ ] Hierarchy management

- [ ] **Branch BLoC**
  - [ ] Events definition
  - [ ] States definition
  - [ ] BLoC implementation
  - [ ] Context switching

- [ ] **Branch UI Components**
  - [ ] Branch selection page
  - [ ] Branch card widget
  - [ ] Create branch form
  - [ ] Branch hierarchy visualization

### Phase 3: Wallet Preparation 🔄
- [ ] **Wallet Data Models**
  - [ ] Wallet entity dengan type support
  - [ ] Transaction entity
  - [ ] JSON serialization setup

- [ ] **Wallet Repository**
  - [ ] Repository interface definition
  - [ ] Basic implementation structure
  - [ ] Error handling preparation

- [ ] **Integration Preparation**
  - [ ] Dependency injection setup
  - [ ] API client integration
  - [ ] Context management integration

### Phase 4: Testing & Integration 🔄
- [ ] **Unit Tests**
  - [ ] Brand repository tests
  - [ ] Branch repository tests
  - [ ] BLoC tests
  - [ ] Widget tests

- [ ] **Integration Tests**
  - [ ] End-to-end flow tests
  - [ ] API integration tests
  - [ ] Context switching tests

- [ ] **Performance Tests**
  - [ ] Memory usage tests
  - [ ] Loading time tests
  - [ ] Battery usage tests

---

## 🎯 Success Metrics

### Phase 1: Brand Management
- **Brand Creation**: < 2 minutes per brand
- **Brand Switching**: < 1 second
- **Data Loading**: < 3 seconds for 50 brands
- **Memory Usage**: < 50MB for brand data

### Phase 2: Branch Management
- **Branch Creation**: < 3 minutes per branch
- **Branch Switching**: < 1 second
- **Hierarchy Loading**: < 2 seconds for 100 branches
- **UI Performance**: 60 FPS on mid-range devices

### Phase 3: Integration
- **End-to-End Flow**: < 30 seconds from login to dashboard
- **Error Rate**: < 1% for all operations
- **Crash Rate**: < 0.1% for all users
- **User Satisfaction**: > 4.5/5 rating

---

## 📚 References

### Documentation
- [Brand & Branch Focused Implementation](./03-Brand-Branch-Focused-Implementation.md)
- [API Endpoints Structure](./01-API-Endpoints-Structure.md)
- [Mobile Flow & Context Management](./02-Mobile-Flow-Context-Management.md)

### Server Documentation
- [Brand Schema](../../../apps/server/src/features/brand/brand.schema.ts)
- [Branch Schema](../../../apps/server/src/features/branch/branch.schema.ts)
- [Wallet Schema](../../../apps/server/src/features/wallet/wallet.schema.ts)

### Flutter Documentation
- [BLoC Pattern](https://bloclibrary.dev/)
- [Dependency Injection](https://pub.dev/packages/get_it)
- [JSON Serialization](https://pub.dev/packages/json_annotation)

---

## 🔄 Next Steps

1. **Implement Phase 1**: Complete Brand Management features
2. **Implement Phase 2**: Complete Branch Management features
3. **Prepare Phase 3**: Setup Wallet infrastructure
4. **Integration Testing**: End-to-end flow validation
5. **Performance Optimization**: Based on testing results
6. **User Testing**: Real-world feedback collection
7. **Documentation Update**: Based on implementation learnings

---

*Guide ini akan terus diupdate seiring dengan perkembangan implementasi Brand & Branch features di aplikasi mobile Usago.*