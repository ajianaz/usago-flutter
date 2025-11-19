# Clean Architecture Template Guide

---

## 📋 **Document Metadata**

| Field | Value |
|-------|-------|
| **Document ID** | DOC-ARCHITECTURE-CLEAN-TEMPLATE |
| **Version** | 1.0.0 |
| **Status** | Ready for Use |
| **Category** | Architecture Template |
| **Priority** | High |
| **Created Date** | November 19, 2025 |
| **Last Updated** | November 19, 2025 |
| **Next Review** | December 19, 2025 |
| **Author** | Mobile Development Team |
| **Reviewers** | Tech Lead, Architecture Team |
| **Stakeholders** | Development Team, Product Management |

---

## 🎯 **Purpose**

Dokumen ini menyediakan template lengkap untuk implementasi Clean Architecture pada aplikasi mobile Usago. Template ini berdasarkan implementasi yang berhasil pada brand feature dan dirancang untuk reusable dan scalable.

---

## Overview

Template ini berdasarkan implementasi Clean Architecture yang berhasil pada brand feature. Template ini dirancang untuk reusable dan scalable untuk semua features dalam project Usago mobile app.

## Template Structure

```
apps/mobile/lib/features/[feature_name]/
├── domain/
│   ├── entities/
│   │   └── [feature_name]_entity.dart
│   ├── repositories/
│   │   └── [feature_name]_repository.dart
│   └── usecases/
│       ├── common/
│       │   ├── usecase.dart
│       │   └── params/
│       │       └── [feature_name]_params.dart
│       ├── [feature_name]_management/
│       │   ├── get_[feature_name]_usecase.dart
│       │   ├── create_[feature_name]_usecase.dart
│       │   ├── update_[feature_name]_usecase.dart
│       │   └── delete_[feature_name]_usecase.dart
│       ├── [feature_name]_list/
│       │   ├── get_[feature_name]_list_usecase.dart
│       │   ├── get_[feature_name]_by_id_usecase.dart
│       │   └── search_[feature_name]_usecase.dart
│       └── index.dart
├── data/
│   ├── datasources/
│   │   ├── [feature_name]_remote_datasource.dart
│   │   ├── [feature_name]_remote_datasource_impl.dart
│   │   ├── [feature_name]_local_datasource.dart
│   │   └── [feature_name]_local_datasource_impl.dart
│   ├── models/
│   │   └── [feature_name]_model.dart
│   └── repositories/
│       └── [feature_name]_repository_impl.dart
├── presentation/
│   ├── bloc/
│   │   ├── [feature_name]_management/
│   │   │   ├── [feature_name]_management_bloc.dart
│   │   │   ├── [feature_name]_management_event.dart
│   │   │   └── [feature_name]_management_state.dart
│   │   ├── [feature_name]_list/
│   │   │   ├── [feature_name]_list_bloc.dart
│   │   │   ├── [feature_name]_list_event.dart
│   │   │   └── [feature_name]_list_state.dart
│   │   └── [feature_name]_search/
│   │       ├── [feature_name]_search_bloc.dart
│   │       ├── [feature_name]_search_event.dart
│   │       └── [feature_name]_search_state.dart
│   ├── pages/
│   │   ├── [feature_name]_list_page.dart
│   │   ├── [feature_name]_detail_page.dart
│   │   └── [feature_name]_create_page.dart
│   ├── widgets/
│   │   ├── [feature_name]_card.dart
│   │   ├── [feature_name]_form.dart
│   │   └── [feature_name]_widget.dart
│   ├── helpers/
│   │   ├── [feature_name]_formatter.dart
│   │   └── [feature_name]_extension.dart
│   └── providers/
│       └── [feature_name]_bloc_provider.dart
├── di/
│   └── [feature_name]_injection.dart
└── README.md
```

## Template Files

### 1. Domain Layer Templates

#### Entity Template
```dart
// domain/entities/[feature_name]_entity.dart
import 'package:equatable/equatable.dart';

class [FeatureName]Entity extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const [FeatureName]Entity({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  [FeatureName]Entity copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return [FeatureName]Entity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, description, createdAt, updatedAt];

  @override
  String toString() {
    return '[FeatureName]Entity(id: $id, name: $name, description: $description)';
  }
}
```

#### Repository Interface Template
```dart
// domain/repositories/[feature_name]_repository.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/[feature_name]_entity.dart';

abstract class [FeatureName]Repository {
  Future<Either<Failure, [FeatureName]Entity>> get[FeatureName]ById(String id);
  Future<Either<Failure, List<[FeatureName]Entity>>> get[FeatureName]List();
  Future<Either<Failure, [FeatureName]Entity>> create[FeatureName]([FeatureName]Entity [featureName]);
  Future<Either<Failure, [FeatureName]Entity>> update[FeatureName]([FeatureName]Entity [featureName]);
  Future<Either<Failure, void>> delete[FeatureName](String id);
  Future<Either<Failure, List<[FeatureName]Entity>>> search[FeatureName](String query);
}
```

#### Use Case Template
```dart
// domain/usecases/[feature_name]_management/get_[feature_name]_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../entities/[feature_name]_entity.dart';
import '../../repositories/[feature_name]_repository.dart';
import '../common/usecase.dart';
import '../common/params/[feature_name]_params.dart';

class Get[FeatureName]UseCase implements UseCase<[FeatureName]Entity, [FeatureName]Params> {
  final [FeatureName]Repository _repository;

  Get[FeatureName]UseCase(this._repository);

  @override
  Future<Either<Failure, [FeatureName]Entity>> call([FeatureName]Params params) async {
    return await _repository.get[FeatureName]ById(params.id);
  }
}
```

#### Common Use Case Template
```dart
// domain/usecases/common/usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}
```

#### Parameters Template
```dart
// domain/usecases/common/params/[feature_name]_params.dart
import 'package:equatable/equatable.dart';

class [FeatureName]Params extends Equatable {
  final String id;
  final Map<String, dynamic>? additionalData;

  const [FeatureName]Params({
    required this.id,
    this.additionalData,
  });

  @override
  List<Object?> get props => [id, additionalData];
}

class Create[FeatureName]Params extends Equatable {
  final String name;
  final String description;
  final Map<String, dynamic>? additionalData;

  const Create[FeatureName]Params({
    required this.name,
    required this.description,
    this.additionalData,
  });

  @override
  List<Object?> get props => [name, description, additionalData];
}

class Update[FeatureName]Params extends Equatable {
  final String id;
  final String name;
  final String description;
  final Map<String, dynamic>? additionalData;

  const Update[FeatureName]Params({
    required this.id,
    required this.name,
    required this.description,
    this.additionalData,
  });

  @override
  List<Object?> get props => [id, name, description, additionalData];
}

class Search[FeatureName]Params extends Equatable {
  final String query;
  final int? limit;
  final int? offset;

  const Search[FeatureName]Params({
    required this.query,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [query, limit, offset];
}
```

### 2. Data Layer Templates

#### Remote Data Source Interface Template
```dart
// data/datasources/[feature_name]_remote_datasource.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../models/[feature_name]_model.dart';

abstract class [FeatureName]RemoteDataSource {
  Future<Either<Failure, [FeatureName]Model>> get[FeatureName]ById(String id);
  Future<Either<Failure, List<[FeatureName]Model>>> get[FeatureName]List();
  Future<Either<Failure, [FeatureName]Model>> create[FeatureName]([FeatureName]Model [featureName]);
  Future<Either<Failure, [FeatureName]Model>> update[FeatureName]([FeatureName]Model [featureName]);
  Future<Either<Failure, void>> delete[FeatureName](String id);
  Future<Either<Failure, List<[FeatureName]Model>>> search[FeatureName](String query);
}
```

#### Remote Data Source Implementation Template
```dart
// data/datasources/[feature_name]_remote_datasource_impl.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';
import '../models/[feature_name]_model.dart';
import '[feature_name]_remote_datasource.dart';

class [FeatureName]RemoteDataSourceImpl implements [FeatureName]RemoteDataSource {
  final DioClient _dioClient;
  final AppLogger _logger;

  [FeatureName]RemoteDataSourceImpl({
    required DioClient dioClient,
    required AppLogger logger,
  }) : _dioClient = dioClient,
       _logger = logger;

  @override
  Future<Either<Failure, [FeatureName]Model>> get[FeatureName]ById(String id) async {
    try {
      _logger.info('Getting [feature_name] by id: $id');

      final response = await _dioClient.get('/[feature_name]/$id');

      if (response.statusCode == 200) {
        final [featureName]Model = [FeatureName]Model.fromJson(response.data);
        return Right([featureName]Model);
      } else {
        return Left(ServerFailure(message: 'Failed to get [feature_name]'));
      }
    } catch (e) {
      _logger.error('Error getting [feature_name] by id: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<[FeatureName]Model>>> get[FeatureName]List() async {
    try {
      _logger.info('Getting [feature_name] list');

      final response = await _dioClient.get('/[feature_name]');

      if (response.statusCode == 200) {
        final List<[FeatureName]Model> [featureName]List = (response.data as List)
            .map((json) => [FeatureName]Model.fromJson(json))
            .toList();
        return Right([featureName]List);
      } else {
        return Left(ServerFailure(message: 'Failed to get [feature_name] list'));
      }
    } catch (e) {
      _logger.error('Error getting [feature_name] list: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, [FeatureName]Model>> create[FeatureName]([FeatureName]Model [featureName]) async {
    try {
      _logger.info('Creating [feature_name]: ${[featureName].name}');

      final response = await _dioClient.post(
        '/[feature_name]',
        data: [featureName].toJson(),
      );

      if (response.statusCode == 201) {
        final created[FeatureName] = [FeatureName]Model.fromJson(response.data);
        return Right(created[FeatureName]);
      } else {
        return Left(ServerFailure(message: 'Failed to create [feature_name]'));
      }
    } catch (e) {
      _logger.error('Error creating [feature_name]: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, [FeatureName]Model>> update[FeatureName]([FeatureName]Model [featureName]) async {
    try {
      _logger.info('Updating [feature_name]: ${[featureName].id}');

      final response = await _dioClient.put(
        '/[feature_name]/${[featureName].id}',
        data: [featureName].toJson(),
      );

      if (response.statusCode == 200) {
        final updated[FeatureName] = [FeatureName]Model.fromJson(response.data);
        return Right(updated[FeatureName]);
      } else {
        return Left(ServerFailure(message: 'Failed to update [feature_name]'));
      }
    } catch (e) {
      _logger.error('Error updating [feature_name]: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> delete[FeatureName](String id) async {
    try {
      _logger.info('Deleting [feature_name]: $id');

      final response = await _dioClient.delete('/[feature_name]/$id');

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(ServerFailure(message: 'Failed to delete [feature_name]'));
      }
    } catch (e) {
      _logger.error('Error deleting [feature_name]: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<[FeatureName]Model>>> search[FeatureName](String query) async {
    try {
      _logger.info('Searching [feature_name] with query: $query');

      final response = await _dioClient.get('/[feature_name]/search', queryParameters: {
        'q': query,
      });

      if (response.statusCode == 200) {
        final List<[FeatureName]Model> searchResults = (response.data as List)
            .map((json) => [FeatureName]Model.fromJson(json))
            .toList();
        return Right(searchResults);
      } else {
        return Left(ServerFailure(message: 'Failed to search [feature_name]'));
      }
    } catch (e) {
      _logger.error('Error searching [feature_name]: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

#### Model Template
```dart
// data/models/[feature_name]_model.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/[feature_name]_entity.dart';

class [FeatureName]Model extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const [FeatureName]Model({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory [FeatureName]Model.fromJson(Map<String, dynamic> json) {
    return [FeatureName]Model(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  [FeatureName]Entity toEntity() {
    return [FeatureName]Entity(
      id: id,
      name: name,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory [FeatureName]Model.fromEntity([FeatureName]Entity entity) {
    return [FeatureName]Model(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, description, createdAt, updatedAt];

  @override
  String toString() {
    return '[FeatureName]Model(id: $id, name: $name, description: $description)';
  }
}
```

#### Repository Implementation Template
```dart
// data/repositories/[feature_name]_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/[feature_name]_entity.dart';
import '../../domain/repositories/[feature_name]_repository.dart';
import '../datasources/[feature_name]_local_datasource.dart';
import '../datasources/[feature_name]_remote_datasource.dart';
import '../models/[feature_name]_model.dart';

class [FeatureName]RepositoryImpl implements [FeatureName]Repository {
  final [FeatureName]RemoteDataSource _remoteDataSource;
  final [FeatureName]LocalDataSource _localDataSource;
  final AppLogger _logger;

  [FeatureName]RepositoryImpl({
    required [FeatureName]RemoteDataSource remoteDataSource,
    required [FeatureName]LocalDataSource localDataSource,
    required AppLogger logger,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _logger = logger;

  @override
  Future<Either<Failure, [FeatureName]Entity>> get[FeatureName]ById(String id) async {
    try {
      _logger.info('Getting [feature_name] by id: $id');

      // Try local cache first
      final cachedResult = await _localDataSource.get[FeatureName]ById(id);
      final cached = cachedResult.fold((l) => null, (r) => r);

      if (cached != null) {
        _logger.info('Found [feature_name] in cache: $id');
        return Right(cached.toEntity());
      }

      // Fetch from remote
      final remoteResult = await _remoteDataSource.get[FeatureName]ById(id);

      return remoteResult.fold(
        (failure) {
          _logger.error('Failed to get [feature_name] from remote: $failure');
          return Left(failure);
        },
        (model) async {
          // Cache the result
          await _localDataSource.cache[FeatureName](model);
          return Right(model.toEntity());
        },
      );
    } catch (e) {
      _logger.error('Error getting [feature_name] by id: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<[FeatureName]Entity>>> get[FeatureName]List() async {
    try {
      _logger.info('Getting [feature_name] list');

      // Try local cache first
      final cachedResult = await _localDataSource.get[FeatureName]List();
      final cached = cachedResult.fold((l) => null, (r) => r);

      if (cached != null && cached.isNotEmpty) {
        _logger.info('Found [feature_name] list in cache: ${cached.length} items');
        return Right(cached.map((model) => model.toEntity()).toList());
      }

      // Fetch from remote
      final remoteResult = await _remoteDataSource.get[FeatureName]List();

      return remoteResult.fold(
        (failure) {
          _logger.error('Failed to get [feature_name] list from remote: $failure');
          return Left(failure);
        },
        (models) async {
          // Cache the results
          await _localDataSource.cache[FeatureName]List(models);
          return Right(models.map((model) => model.toEntity()).toList());
        },
      );
    } catch (e) {
      _logger.error('Error getting [feature_name] list: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, [FeatureName]Entity>> create[FeatureName]([FeatureName]Entity [featureName]) async {
    try {
      _logger.info('Creating [feature_name]: ${[featureName].name}');

      final model = [FeatureName]Model.fromEntity([featureName]);
      final result = await _remoteDataSource.create[FeatureName](model);

      return result.fold(
        (failure) {
          _logger.error('Failed to create [feature_name]: $failure');
          return Left(failure);
        },
        (createdModel) async {
          // Cache the created [feature_name]
          await _localDataSource.cache[FeatureName](createdModel);
          return Right(createdModel.toEntity());
        },
      );
    } catch (e) {
      _logger.error('Error creating [feature_name]: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, [FeatureName]Entity>> update[FeatureName]([FeatureName]Entity [featureName]) async {
    try {
      _logger.info('Updating [feature_name]: ${[featureName].id}');

      final model = [FeatureName]Model.fromEntity([featureName]);
      final result = await _remoteDataSource.update[FeatureName](model);

      return result.fold(
        (failure) {
          _logger.error('Failed to update [feature_name]: $failure');
          return Left(failure);
        },
        (updatedModel) async {
          // Update cache
          await _localDataSource.cache[FeatureName](updatedModel);
          return Right(updatedModel.toEntity());
        },
      );
    } catch (e) {
      _logger.error('Error updating [feature_name]: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> delete[FeatureName](String id) async {
    try {
      _logger.info('Deleting [feature_name]: $id');

      final result = await _remoteDataSource.delete[FeatureName](id);

      return result.fold(
        (failure) {
          _logger.error('Failed to delete [feature_name]: $failure');
          return Left(failure);
        },
        (_) async {
          // Remove from cache
          await _localDataSource.delete[FeatureName](id);
          return const Right(null);
        },
      );
    } catch (e) {
      _logger.error('Error deleting [feature_name]: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<[FeatureName]Entity>>> search[FeatureName](String query) async {
    try {
      _logger.info('Searching [feature_name] with query: $query');

      final result = await _remoteDataSource.search[FeatureName](query);

      return result.fold(
        (failure) {
          _logger.error('Failed to search [feature_name]: $failure');
          return Left(failure);
        },
        (models) {
          return Right(models.map((model) => model.toEntity()).toList());
        },
      );
    } catch (e) {
      _logger.error('Error searching [feature_name]: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
```

### 3. Presentation Layer Templates

#### BLoC Event Template
```dart
// presentation/bloc/[feature_name]_management/[feature_name]_management_event.dart
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/[feature_name]_entity.dart';

abstract class [FeatureName]ManagementEvent extends Equatable {
  const [FeatureName]ManagementEvent();
}

class Load[FeatureName]Event extends [FeatureName]ManagementEvent {
  final String id;

  const Load[FeatureName]Event({required this.id});

  @override
  List<Object?> get props => [id];
}

class Create[FeatureName]Event extends [FeatureName]ManagementEvent {
  final String name;
  final String description;

  const Create[FeatureName]Event({
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [name, description];
}

class Update[FeatureName]Event extends [FeatureName]ManagementEvent {
  final [FeatureName]Entity [featureName];

  const Update[FeatureName]Event({required this.[featureName]});

  @override
  List<Object?> get props => [[featureName]];
}

class Delete[FeatureName]Event extends [FeatureName]ManagementEvent {
  final String id;

  const Delete[FeatureName]Event({required this.id});

  @override
  List<Object?> get props => [id];
}

class Reset[FeatureName]ManagementEvent extends [FeatureName]ManagementEvent {
  const Reset[FeatureName]ManagementEvent();

  @override
  List<Object?> get props => [];
}
```

#### BLoC State Template
```dart
// presentation/bloc/[feature_name]_management/[feature_name]_management_state.dart
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/[feature_name]_entity.dart';

abstract class [FeatureName]ManagementState extends Equatable {
  const [FeatureName]ManagementState();
}

class [FeatureName]ManagementInitial extends [FeatureName]ManagementState {
  const [FeatureName]ManagementInitial();

  @override
  List<Object?> get props => [];
}

class [FeatureName]ManagementLoading extends [FeatureName]ManagementState {
  const [FeatureName]ManagementLoading();

  @override
  List<Object?> get props => [];
}

class [FeatureName]ManagementLoaded extends [FeatureName]ManagementState {
  final [FeatureName]Entity [featureName];

  const [FeatureName]ManagementLoaded({required this.[featureName]});

  @override
  List<Object?> get props => [[featureName]];
}

class [FeatureName]ManagementCreated extends [FeatureName]ManagementState {
  final [FeatureName]Entity [featureName];
  final String message;

  const [FeatureName]ManagementCreated({
    required this.[featureName],
    required this.message,
  });

  @override
  List<Object?> get props => [[featureName], message];
}

class [FeatureName]ManagementUpdated extends [FeatureName]ManagementState {
  final [FeatureName]Entity [featureName];
  final String message;

  const [FeatureName]ManagementUpdated({
    required this.[featureName],
    required this.message,
  });

  @override
  List<Object?> get props => [[featureName], message];
}

class [FeatureName]ManagementDeleted extends [FeatureName]ManagementState {
  final String message;

  const [FeatureName]ManagementDeleted({required this.message});

  @override
  List<Object?> get props => [message];
}

class [FeatureName]ManagementError extends [FeatureName]ManagementState {
  final String message;

  const [FeatureName]ManagementError({required this.message});

  @override
  List<Object?> get props => [message];
}
```

#### BLoC Template
```dart
// presentation/bloc/[feature_name]_management/[feature_name]_management_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/logger.dart';
import '../../../../domain/entities/[feature_name]_entity.dart';
import '../../../../domain/usecases/[feature_name]_management/create_[feature_name]_usecase.dart';
import '../../../../domain/usecases/[feature_name]_management/delete_[feature_name]_usecase.dart';
import '../../../../domain/usecases/[feature_name]_management/get_[feature_name]_usecase.dart';
import '../../../../domain/usecases/[feature_name]_management/update_[feature_name]_usecase.dart';
import '[feature_name]_management_event.dart';
import '[feature_name]_management_state.dart';

class [FeatureName]ManagementBloc extends Bloc<[FeatureName]ManagementEvent, [FeatureName]ManagementState> {
  final Get[FeatureName]UseCase _get[FeatureName]UseCase;
  final Create[FeatureName]UseCase _create[FeatureName]UseCase;
  final Update[FeatureName]UseCase _update[FeatureName]UseCase;
  final Delete[FeatureName]UseCase _delete[FeatureName]UseCase;
  final AppLogger _logger;

  [FeatureName]ManagementBloc({
    required Get[FeatureName]UseCase get[FeatureName]UseCase,
    required Create[FeatureName]UseCase create[FeatureName]UseCase,
    required Update[FeatureName]UseCase update[FeatureName]UseCase,
    required Delete[FeatureName]UseCase delete[FeatureName]UseCase,
    required AppLogger logger,
  }) : _get[FeatureName]UseCase = get[FeatureName]UseCase,
       _create[FeatureName]UseCase = create[FeatureName]UseCase,
       _update[FeatureName]UseCase = update[FeatureName]UseCase,
       _delete[FeatureName]UseCase = delete[FeatureName]UseCase,
       _logger = logger,
       super(const [FeatureName]ManagementInitial()) {
    on<Load[FeatureName]Event>(_onLoad[FeatureName]);
    on<Create[FeatureName]Event>(_onCreate[FeatureName]);
    on<Update[FeatureName]Event>(_onUpdate[FeatureName]);
    on<Delete[FeatureName]Event>(_onDelete[FeatureName]);
    on<Reset[FeatureName]ManagementEvent>(_onReset[FeatureName]Management);
  }

  Future<void> _onLoad[FeatureName](
    Load[FeatureName]Event event,
    Emitter<[FeatureName]ManagementState> emit,
  ) async {
    emit(const [FeatureName]ManagementLoading());

    final result = await _get[FeatureName]UseCase(
      [FeatureName]Params(id: event.id),
    );

    result.fold(
      (failure) {
        _logger.error('Failed to load [feature_name]: $failure');
        emit([FeatureName]ManagementError(message: failure.message));
      },
      ([featureName]) {
        _logger.info('Successfully loaded [feature_name]: ${[featureName].id}');
        emit([FeatureName]ManagementLoaded([featureName]: [featureName]));
      },
    );
  }

  Future<void> _onCreate[FeatureName](
    Create[FeatureName]Event event,
    Emitter<[FeatureName]ManagementState> emit,
  ) async {
    emit(const [FeatureName]ManagementLoading());

    final result = await _create[FeatureName]UseCase(
      Create[FeatureName]Params(
        name: event.name,
        description: event.description,
      ),
    );

    result.fold(
      (failure) {
        _logger.error('Failed to create [feature_name]: $failure');
        emit([FeatureName]ManagementError(message: failure.message));
      },
      ([featureName]) {
        _logger.info('Successfully created [feature_name]: ${[featureName].id}');
        emit([FeatureName]ManagementCreated(
          [featureName]: [featureName],
          message: '[FeatureName] created successfully',
        ));
      },
    );
  }

  Future<void> _onUpdate[FeatureName](
    Update[FeatureName]Event event,
    Emitter<[FeatureName]ManagementState> emit,
  ) async {
    emit(const [FeatureName]ManagementLoading());

    final result = await _update[FeatureName]UseCase(
      Update[FeatureName]Params(
        id: event.[featureName].id,
        name: event.[featureName].name,
        description: event.[featureName].description,
      ),
    );

    result.fold(
      (failure) {
        _logger.error('Failed to update [feature_name]: $failure');
        emit([FeatureName]ManagementError(message: failure.message));
      },
      ([featureName]) {
        _logger.info('Successfully updated [feature_name]: ${[featureName].id}');
        emit([FeatureName]ManagementUpdated(
          [featureName]: [featureName],
          message: '[FeatureName] updated successfully',
        ));
      },
    );
  }

  Future<void> _onDelete[FeatureName](
    Delete[FeatureName]Event event,
    Emitter<[FeatureName]ManagementState> emit,
  ) async {
    emit(const [FeatureName]ManagementLoading());

    final result = await _delete[FeatureName]UseCase(
      [FeatureName]Params(id: event.id),
    );

    result.fold(
      (failure) {
        _logger.error('Failed to delete [feature_name]: $failure');
        emit([FeatureName]ManagementError(message: failure.message));
      },
      (_) {
        _logger.info('Successfully deleted [feature_name]: ${event.id}');
        emit(const [FeatureName]ManagementDeleted(
          message: '[FeatureName] deleted successfully',
        ));
      },
    );
  }

  void _onReset[FeatureName]Management(
    Reset[FeatureName]ManagementEvent event,
    Emitter<[FeatureName]ManagementState> emit,
  ) {
    _logger.info('Resetting [feature_name] management state');
    emit(const [FeatureName]ManagementInitial());
  }
}
```

### 4. Dependency Injection Template

```dart
// di/[feature_name]_injection.dart
import 'package:get_it/get_it.dart';
import '../data/datasources/[feature_name]_local_datasource.dart';
import '../data/datasources/[feature_name]_local_datasource_impl.dart';
import '../data/datasources/[feature_name]_remote_datasource.dart';
import '../data/datasources/[feature_name]_remote_datasource_impl.dart';
import '../data/repositories/[feature_name]_repository_impl.dart';
import '../domain/repositories/[feature_name]_repository.dart';
import '../domain/usecases/[feature_name]_management/create_[feature_name]_usecase.dart';
import '../domain/usecases/[feature_name]_management/delete_[feature_name]_usecase.dart';
import '../domain/usecases/[feature_name]_management/get_[feature_name]_usecase.dart';
import '../domain/usecases/[feature_name]_management/update_[feature_name]_usecase.dart';
import '../domain/usecases/[feature_name]_list/get_[feature_name]_list_usecase.dart';
import '../domain/usecases/[feature_name]_list/search_[feature_name]_usecase.dart';
import '../presentation/bloc/[feature_name]_management/[feature_name]_management_bloc.dart';
import '../presentation/bloc/[feature_name]_list/[feature_name]_list_bloc.dart';
import '../presentation/bloc/[feature_name]_search/[feature_name]_search_bloc.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';

/// Setup [feature_name] feature dependencies
Future<void> setup[FeatureName]Dependencies(GetIt getIt) async {
  // Get existing instances from core
  final dioClient = getIt<DioClient>();
  final logger = getIt<AppLogger>();

  // Register local datasource
  getIt.registerSingleton<[FeatureName]LocalDataSource>(
    [FeatureName]LocalDataSourceImpl(logger: logger, prefs: getIt()),
  );

  // Register remote datasource
  getIt.registerSingleton<[FeatureName]RemoteDataSource>(
    [FeatureName]RemoteDataSourceImpl(
      dioClient: dioClient,
      logger: logger,
    ),
  );

  // Register repository
  getIt.registerSingleton<[FeatureName]Repository>(
    [FeatureName]RepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      logger: logger,
    ),
  );

  // Register use cases
  getIt.registerSingleton<Get[FeatureName]UseCase>(
    Get[FeatureName]UseCase(getIt()),
  );
  getIt.registerSingleton<Create[FeatureName]UseCase>(
    Create[FeatureName]UseCase(getIt()),
  );
  getIt.registerSingleton<Update[FeatureName]UseCase>(
    Update[FeatureName]UseCase(getIt()),
  );
  getIt.registerSingleton<Delete[FeatureName]UseCase>(
    Delete[FeatureName]UseCase(getIt()),
  );
  getIt.registerSingleton<Get[FeatureName]ListUseCase>(
    Get[FeatureName]ListUseCase(getIt()),
  );
  getIt.registerSingleton<Search[FeatureName]UseCase>(
    Search[FeatureName]UseCase(getIt()),
  );

  // Register BLoCs
  getIt.registerSingleton<[FeatureName]ManagementBloc>(
    [FeatureName]ManagementBloc(
      get[FeatureName]UseCase: getIt(),
      create[FeatureName]UseCase: getIt(),
      update[FeatureName]UseCase: getIt(),
      delete[FeatureName]UseCase: getIt(),
      logger: logger,
    ),
  );

  getIt.registerFactory<[FeatureName]ListBloc>(
    () => [FeatureName]ListBloc(
      get[FeatureName]ListUseCase: getIt(),
      logger: logger,
    ),
  );

  getIt.registerFactory<[FeatureName]SearchBloc>(
    () => [FeatureName]SearchBloc(
      search[FeatureName]UseCase: getIt(),
      logger: logger,
    ),
  );
}
```

## Template Usage Guide

### 1. Feature Creation Steps

1. **Replace Placeholders**: Ganti `[feature_name]` dengan nama feature (snake_case) dan `[FeatureName]` dengan nama feature (PascalCase)
2. **Customize Business Logic**: Sesuaikan entity fields, use cases, dan BLoC logic
3. **Update API Endpoints**: Sesuaikan endpoint di remote datasource
4. **Customize UI**: Buat pages dan widgets sesuai kebutuhan
5. **Update Navigation**: Tambahkan routing untuk pages baru

### 2. Best Practices

1. **Single Responsibility**: Setiap BLoC memiliki satu tanggung jawab
2. **Clean Dependencies**: Gunakan dependency injection dengan benar
3. **Error Handling**: Handle errors dengan konsisten
4. **Logging**: Log semua operasi penting
5. **Testing**: Tulis unit tests untuk semua use cases dan BLoCs

### 3. Customization Guidelines

1. **Business Logic**: Tambahkan business rules di use cases
2. **Validation**: Validasi input di use cases level
3. **Caching**: Implementasi caching strategy di repository
4. **Pagination**: Tambahkan pagination untuk large datasets
5. **Real-time**: Implementasi real-time updates jika dibutuhkan

---

**Template Version**: 1.0.0
**Based on**: Brand Feature Implementation
**Last Updated**: 19 November 2025