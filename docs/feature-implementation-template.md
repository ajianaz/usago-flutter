# Feature Implementation Template

## 📋 Overview

Dokumentasi ini menyediakan template dan panduan lengkap untuk implementasi feature baru dalam aplikasi Usago Mobile menggunakan standardized dependency injection patterns.

## 🏗️ Feature Structure Template

### Directory Structure
```
lib/features/feature_name/
├── data/
│   ├── datasources/
│   │   ├── feature_remote_datasource.dart          # Interface
│   │   └── feature_remote_datasource_impl.dart     # Implementation
│   ├── models/
│   │   └── feature_model.dart                   # Data models
│   └── repositories/
│       └── feature_repository_impl.dart           # Repository implementation
├── domain/
│   ├── entities/
│   │   └── feature.dart                        # Domain entity
│   ├── repositories/
│   │   └── feature_repository.dart              # Repository interface
│   └── usecases/
│       ├── get_feature_usecase.dart             # Get operation
│       ├── create_feature_usecase.dart          # Create operation
│       ├── update_feature_usecase.dart          # Update operation
│       └── delete_feature_usecase.dart          # Delete operation
├── presentation/
│   ├── bloc/
│   │   ├── feature_bloc.dart                   # BLoC implementation
│   │   ├── feature_event.dart                 # Events
│   │   └── feature_state.dart                # States
│   ├── pages/
│   │   └── feature_page.dart                 # Main page
│   └── widgets/
│       ├── feature_card.dart                   # Reusable widgets
│       └── feature_form.dart                  # Form widgets
└── di/
    └── feature_injection.dart                 # DI configuration
```

## 🔧 Implementation Steps

### Step 1: Domain Layer

#### Entity (`domain/entities/feature.dart`)
```dart
import 'package:equatable/equatable.dart';

class Feature extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Feature({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, description, createdAt, updatedAt];

  Feature copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Feature(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

#### Repository Interface (`domain/repositories/feature_repository.dart`)
```dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/feature.dart';

abstract interface class FeatureRepository {
  /// Get all features
  Future<Either<Failure, List<Feature>>> getFeatures();

  /// Get feature by ID
  Future<Either<Failure, Feature?>> getFeatureById(String id);

  /// Create new feature
  Future<Either<Failure, Feature>> createFeature({
    required String name,
    required String description,
  });

  /// Update existing feature
  Future<Either<Failure, Feature>> updateFeature({
    required String id,
    String? name,
    String? description,
  });

  /// Delete feature
  Future<Either<Failure, void>> deleteFeature(String id);
}
```

#### Use Cases (`domain/usecases/`)
```dart
// get_feature_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/feature.dart';
import '../repositories/feature_repository.dart';

class GetFeaturesUseCase {
  final FeatureRepository _repository;

  GetFeaturesUseCase(this._repository);

  Future<Either<Failure, List<Feature>>> call() async {
    return await _repository.getFeatures();
  }
}

// create_feature_usecase.dart
class CreateFeatureParams {
  final String name;
  final String description;

  const CreateFeatureParams({
    required this.name,
    required this.description,
  });
}

class CreateFeatureUseCase {
  final FeatureRepository _repository;

  CreateFeatureUseCase(this._repository);

  Future<Either<Failure, Feature>> call(CreateFeatureParams params) async {
    return await _repository.createFeature(
      name: params.name,
      description: params.description,
    );
  }
}
```

### Step 2: Data Layer

#### Model (`data/models/feature_model.dart`)
```dart
import '../../domain/entities/feature.dart';

class FeatureModel {
  final String id;
  final String name;
  final String description;
  final String createdAt;
  final String? updatedAt;

  FeatureModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    this.updatedAt,
  });

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Feature toEntity() {
    return Feature(
      id: id,
      name: name,
      description: description,
      createdAt: DateTime.parse(createdAt),
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
    );
  }

  factory FeatureModel.fromEntity(Feature entity) {
    return FeatureModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt?.toIso8601String(),
    );
  }
}
```

#### Data Source Interface (`data/datasources/feature_remote_datasource.dart`)
```dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../models/feature_model.dart';

abstract interface class FeatureRemoteDataSource {
  /// Get all features from API
  Future<Either<Failure, List<FeatureModel>>> getFeatures();

  /// Get feature by ID from API
  Future<Either<Failure, FeatureModel?>> getFeatureById(String id);

  /// Create feature via API
  Future<Either<Failure, FeatureModel>> createFeature({
    required String name,
    required String description,
  });

  /// Update feature via API
  Future<Either<Failure, FeatureModel>> updateFeature({
    required String id,
    String? name,
    String? description,
  });

  /// Delete feature via API
  Future<Either<Failure, void>> deleteFeature(String id);
}
```

#### Data Source Implementation (`data/datasources/feature_remote_datasource_impl.dart`)
```dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/errors/failure.dart';
import '../datasources/feature_remote_datasource.dart';
import '../models/feature_model.dart';

class FeatureRemoteDataSourceImpl implements FeatureRemoteDataSource {
  final DioClient _dioClient;
  final AppLogger _logger;

  FeatureRemoteDataSourceImpl({
    required DioClient dioClient,
    required AppLogger logger,
  })  : _dioClient = dioClient,
        _logger = logger;

  @override
  Future<Either<Failure, List<FeatureModel>>> getFeatures() async {
    try {
      _logger.info('Fetching features from API');
      final response = await _dioClient.get('/features');

      final features = (response['data'] as List)
          .map((json) => FeatureModel.fromJson(json as Map<String, dynamic>))
          .toList();

      _logger.info('Successfully fetched ${features.length} features');
      return Right(features);
    } catch (e) {
      _logger.error('Failed to fetch features', e);
      return Left(ServerFailure('Failed to fetch features: $e'));
    }
  }

  @override
  Future<Either<Failure, FeatureModel?>> getFeatureById(String id) async {
    try {
      _logger.info('Fetching feature with ID: $id');
      final response = await _dioClient.get('/features/$id');

      if (response['data'] != null) {
        final feature = FeatureModel.fromJson(response['data'] as Map<String, dynamic>);
        _logger.info('Successfully fetched feature: $id');
        return Right(feature);
      }

      return const Right(null);
    } catch (e) {
      _logger.error('Failed to fetch feature $id', e);
      return Left(ServerFailure('Failed to fetch feature: $e'));
    }
  }

  @override
  Future<Either<Failure, FeatureModel>> createFeature({
    required String name,
    required String description,
  }) async {
    try {
      _logger.info('Creating feature: $name');
      final response = await _dioClient.post(
        '/features',
        data: {
          'name': name,
          'description': description,
        },
      );

      final feature = FeatureModel.fromJson(response['data'] as Map<String, dynamic>);
      _logger.info('Successfully created feature: ${feature.id}');
      return Right(feature);
    } catch (e) {
      _logger.error('Failed to create feature', e);
      return Left(ServerFailure('Failed to create feature: $e'));
    }
  }

  @override
  Future<Either<Failure, FeatureModel>> updateFeature({
    required String id,
    String? name,
    String? description,
  }) async {
    try {
      _logger.info('Updating feature: $id');
      final response = await _dioClient.put(
        '/features/$id',
        data: {
          if (name != null) 'name': name,
          if (description != null) 'description': description,
        },
      );

      final feature = FeatureModel.fromJson(response['data'] as Map<String, dynamic>);
      _logger.info('Successfully updated feature: $id');
      return Right(feature);
    } catch (e) {
      _logger.error('Failed to update feature $id', e);
      return Left(ServerFailure('Failed to update feature: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFeature(String id) async {
    try {
      _logger.info('Deleting feature: $id');
      await _dioClient.delete('/features/$id');
      _logger.info('Successfully deleted feature: $id');
      return const Right(null);
    } catch (e) {
      _logger.error('Failed to delete feature $id', e);
      return Left(ServerFailure('Failed to delete feature: $e'));
    }
  }
}
```

#### Repository Implementation (`data/repositories/feature_repository_impl.dart`)
```dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/feature.dart';
import '../../domain/repositories/feature_repository.dart';
import '../datasources/feature_remote_datasource.dart';
import '../models/feature_model.dart';

class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureRemoteDataSource _remoteDataSource;
  final AppLogger _logger;

  FeatureRepositoryImpl({
    required FeatureRemoteDataSource remoteDataSource,
    required AppLogger logger,
  })  : _remoteDataSource = remoteDataSource,
        _logger = logger;

  @override
  Future<Either<Failure, List<Feature>>> getFeatures() async {
    _logger.info('Getting all features');
    final result = await _remoteDataSource.getFeatures();

    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((model) => model.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, Feature?>> getFeatureById(String id) async {
    _logger.info('Getting feature by ID: $id');
    final result = await _remoteDataSource.getFeatureById(id);

    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model?.toEntity()),
    );
  }

  @override
  Future<Either<Failure, Feature>> createFeature({
    required String name,
    required String description,
  }) async {
    _logger.info('Creating new feature');
    final result = await _remoteDataSource.createFeature(
      name: name,
      description: description,
    );

    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, Feature>> updateFeature({
    required String id,
    String? name,
    String? description,
  }) async {
    _logger.info('Updating feature: $id');
    final result = await _remoteDataSource.updateFeature(
      id: id,
      name: name,
      description: description,
    );

    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Failure, void>> deleteFeature(String id) async {
    _logger.info('Deleting feature: $id');
    return await _remoteDataSource.deleteFeature(id);
  }
}
```

### Step 3: Presentation Layer

#### Events (`presentation/bloc/feature_event.dart`)
```dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/feature.dart';

abstract class FeatureEvent extends Equatable {
  const FeatureEvent();
}

class GetFeaturesEvent extends FeatureEvent {
  const GetFeaturesEvent();

  @override
  List<Object?> get props => [];
}

class CreateFeatureEvent extends FeatureEvent {
  final String name;
  final String description;

  const CreateFeatureEvent({
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [name, description];
}

class UpdateFeatureEvent extends FeatureEvent {
  final String id;
  final String? name;
  final String? description;

  const UpdateFeatureEvent({
    required this.id,
    this.name,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, description];
}

class DeleteFeatureEvent extends FeatureEvent {
  final String id;

  const DeleteFeatureEvent(this.id);

  @override
  List<Object?> get props => [id];
}
```

#### States (`presentation/bloc/feature_state.dart`)
```dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/feature.dart';

abstract class FeatureState extends Equatable {
  const FeatureState();
}

class FeatureInitial extends FeatureState {
  const FeatureInitial();

  @override
  List<Object?> get props => [];
}

class FeatureLoading extends FeatureState {
  const FeatureLoading();

  @override
  List<Object?> get props => [];
}

class FeatureLoaded extends FeatureState {
  final List<Feature> features;

  const FeatureLoaded(this.features);

  @override
  List<Object?> get props => [features];
}

class FeatureError extends FeatureState {
  final String message;

  const FeatureError(this.message);

  @override
  List<Object?> get props => [message];
}
```

#### BLoC (`presentation/bloc/feature_bloc.dart`)
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/feature.dart';
import '../../domain/usecases/get_features_usecase.dart';
import '../../domain/usecases/create_feature_usecase.dart';
import '../../domain/usecases/update_feature_usecase.dart';
import '../../domain/usecases/delete_feature_usecase.dart';
import 'feature_event.dart';
import 'feature_state.dart';

class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final GetFeaturesUseCase _getFeaturesUseCase;
  final CreateFeatureUseCase _createFeatureUseCase;
  final UpdateFeatureUseCase _updateFeatureUseCase;
  final DeleteFeatureUseCase _deleteFeatureUseCase;

  FeatureBloc({
    required GetFeaturesUseCase getFeaturesUseCase,
    required CreateFeatureUseCase createFeatureUseCase,
    required UpdateFeatureUseCase updateFeatureUseCase,
    required DeleteFeatureUseCase deleteFeatureUseCase,
  })  : _getFeaturesUseCase = getFeaturesUseCase,
        _createFeatureUseCase = createFeatureUseCase,
        _updateFeatureUseCase = updateFeatureUseCase,
        _deleteFeatureUseCase = deleteFeatureUseCase,
        super(const FeatureInitial()) {
    on<FeatureEvent>((event, emit) async {
      await event.map<FeatureState>(
        getFeatures: (event) => await _onGetFeatures(event, emit),
        createFeature: (event) => await _onCreateFeature(event, emit),
        updateFeature: (event) => await _onUpdateFeature(event, emit),
        deleteFeature: (event) => await _onDeleteFeature(event, emit),
      );
    });
  }

  Future<void> _onGetFeatures(
    GetFeaturesEvent event,
    Emitter<FeatureState> emit,
  ) async {
    emit(const FeatureLoading());
    final result = await _getFeaturesUseCase();

    emit(result.fold(
      (failure) => FeatureError(failure.message),
      (features) => FeatureLoaded(features),
    ));
  }

  Future<void> _onCreateFeature(
    CreateFeatureEvent event,
    Emitter<FeatureState> emit,
  ) async {
    emit(const FeatureLoading());
    final result = await _createFeatureUseCase(
      CreateFeatureParams(
        name: event.name,
        description: event.description,
      ),
    );

    result.fold(
      (failure) => emit(FeatureError(failure.message)),
      (_) => add(const GetFeaturesEvent()), // Refresh list
    );
  }

  Future<void> _onUpdateFeature(
    UpdateFeatureEvent event,
    Emitter<FeatureState> emit,
  ) async {
    emit(const FeatureLoading());
    final result = await _updateFeatureUseCase(
      UpdateFeatureParams(
        id: event.id,
        name: event.name,
        description: event.description,
      ),
    );

    result.fold(
      (failure) => emit(FeatureError(failure.message)),
      (_) => add(const GetFeaturesEvent()), // Refresh list
    );
  }

  Future<void> _onDeleteFeature(
    DeleteFeatureEvent event,
    Emitter<FeatureState> emit,
  ) async {
    emit(const FeatureLoading());
    final result = await _deleteFeatureUseCase(event.id);

    result.fold(
      (failure) => emit(FeatureError(failure.message)),
      (_) => add(const GetFeaturesEvent()), // Refresh list
    );
  }
}
```

### Step 4: Dependency Injection

#### DI Configuration (`di/feature_injection.dart`)
```dart
import 'package:get_it/get_it.dart';
import '../../../../core/di/di_patterns.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';
import '../data/datasources/feature_remote_datasource.dart';
import '../data/datasources/feature_remote_datasource_impl.dart';
import '../domain/repositories/feature_repository.dart';
import '../data/repositories/feature_repository_impl.dart';
import '../domain/usecases/get_features_usecase.dart';
import '../domain/usecases/create_feature_usecase.dart';
import '../domain/usecases/update_feature_usecase.dart';
import '../domain/usecases/delete_feature_usecase.dart';
import '../presentation/bloc/feature_bloc.dart';

void setupFeatureDependencies(GetIt getIt) {
  // Get existing instances from core
  final dioClient = getIt<DioClient>();
  final logger = getIt<AppLogger>();

  // Register data source with lazy singleton lifecycle
  getIt.registerWithMetadata<FeatureRemoteDataSource>(
    () => FeatureRemoteDataSourceImpl(
      dioClient: dioClient,
      logger: logger,
    ),
    lifecycle: DILifecycle.lazySingleton,
    category: DICategory.datasource,
    name: DINaming.dataSource('Feature'),
    description: 'Feature remote data source for API communication',
  );

  // Register repository with lazy singleton lifecycle
  getIt.registerWithMetadata<FeatureRepository>(
    () => FeatureRepositoryImpl(
      remoteDataSource: getIt(),
      logger: logger,
    ),
    lifecycle: DILifecycle.lazySingleton,
    category: DICategory.repository,
    name: DINaming.repository('Feature'),
    description: 'Feature repository for business logic coordination',
  );

  // Register use cases with lazy singleton lifecycle
  DICommonPatterns.registerUseCases(
    getIt,
    {
      DINaming.useCase('GetFeatures', 'Feature'): () => GetFeaturesUseCase(repository: getIt()),
      DINaming.useCase('CreateFeature', 'Feature'): () => CreateFeatureUseCase(repository: getIt()),
      DINaming.useCase('UpdateFeature', 'Feature'): () => UpdateFeatureUseCase(repository: getIt()),
      DINaming.useCase('DeleteFeature', 'Feature'): () => DeleteFeatureUseCase(repository: getIt()),
    },
    lifecycle: DILifecycle.lazySingleton,
  );

  // Register BLoC with factory lifecycle (new instance each time)
  getIt.registerWithMetadata<FeatureBloc>(
    () => FeatureBloc(
      getFeaturesUseCase: getIt(),
      createFeatureUseCase: getIt(),
      updateFeatureUseCase: getIt(),
      deleteFeatureUseCase: getIt(),
    ),
    lifecycle: DILifecycle.factory,
    category: DICategory.bloc,
    name: DINaming.bloc('Feature'),
    description: 'Feature BLoC for feature state management',
  );
}
```

### Step 5: Integration

#### Update Main DI Container
```dart
// In lib/core/di/injection_container.dart
Future<void> setupDependencies() async {
  await _setupCoreServices();

  // Existing features
  setupAuthDependencies(getIt);
  setupHomeDependencies(getIt);

  // Add new feature
  setupFeatureDependencies(getIt);

  _logRegisteredDependencies();
}
```

## 📋 Checklist

### Before Implementation
- [ ] Feature requirements documented
- [ ] API endpoints defined
- [ ] Database schema designed
- [ ] UI/UX mockups created

### During Implementation
- [ ] Domain layer completed (entities, repositories, use cases)
- [ ] Data layer completed (models, data sources, repositories)
- [ ] Presentation layer completed (BLoC, events, states, pages)
- [ ] DI configuration completed
- [ ] Tests written

### After Implementation
- [ ] Integration testing completed
- [ ] Code review completed
- [ ] Documentation updated
- [ ] Feature deployed

## 🧪 Testing Guidelines

### Unit Tests
```dart
// test/features/domain/usecases/get_features_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../lib/features/feature/domain/usecases/get_features_usecase.dart';
import '../../../../lib/features/feature/domain/repositories/feature_repository.dart';
import '../../../../lib/features/feature/domain/entities/feature.dart';
import '../../../../lib/core/errors/failure.dart';

void main() {
  group('GetFeaturesUseCase', () {
    late FeatureRepository mockRepository;
    late GetFeaturesUseCase useCase;

    setUp(() {
      mockRepository = mock<FeatureRepository>();
      useCase = GetFeaturesUseCase(mockRepository);
    });

    test('should get features successfully', () async {
      // Arrange
      final features = [
        const Feature(id: '1', name: 'Feature 1', description: 'Description 1', createdAt: DateTime.now()),
        const Feature(id: '2', name: 'Feature 2', description: 'Description 2', createdAt: DateTime.now()),
      ];

      when(mockRepository.getFeatures())
          .thenAnswer((_) async => Right(features));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Right<Failure, List<Feature>>>());
      expect(result.fold((l) => l, (r) => r), equals(features));
      verify(mockRepository.getFeatures()).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      when(mockRepository.getFeatures())
          .thenAnswer((_) async => const Left(ServerFailure('Network error')));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Left<Failure, List<Feature>>>());
      expect(result.fold((l) => l, (r) => r), isA<ServerFailure>());
      verify(mockRepository.getFeatures()).called(1);
    });
  });
}
```

### Widget Tests
```dart
// test/features/presentation/pages/feature_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../lib/features/feature/presentation/bloc/feature_bloc.dart';
import '../../../../lib/features/feature/presentation/pages/feature_page.dart';

void main() {
  group('FeaturePage', () {
    late FeatureBloc mockBloc;

    setUp(() {
      mockBloc = mock<FeatureBloc>();
      whenListen(mockBloc);
    });

    Widget createWidget() {
      return MaterialApp(
        home: FeaturePage(),
      );
    }

    testWidgets('should display loading indicator', (WidgetTester tester) async {
      // Arrange
      whenListen(mockBloc).thenAnswer((_) => const Stream.empty());
      when(mockBloc.state).thenReturn(const FeatureLoading());

      // Act
      await tester.pumpWidget(createWidget());

      // Assert
      expect(find.byType<CircularProgressIndicator>(), findsOneWidget);
    });

    testWidgets('should display features when loaded', (WidgetTester tester) async {
      // Arrange
      final features = [
        const Feature(id: '1', name: 'Feature 1', description: 'Description 1', createdAt: DateTime.now()),
      ];

      whenListen(mockBloc).thenAnswer((_) => const Stream.empty());
      when(mockBloc.state).thenReturn(FeatureLoaded(features));

      // Act
      await tester.pumpWidget(createWidget());

      // Assert
      expect(find.text('Feature 1'), findsOneWidget);
      expect(find.text('Description 1'), findsOneWidget);
    });
  });
}
```

## 📚 References

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob-clean-architecture)
- [Flutter BLoC](https://bloclibrary.dev/)
- [Dependency Injection Patterns](./dependency-injection-patterns.md)
- [Testing Best Practices](https://docs.flutter.dev/cookbook/testing)

---

*Template ini akan terus diupdate sesuai dengan best practices dan feedback dari team development.*