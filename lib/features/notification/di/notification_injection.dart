import 'package:get_it/get_it.dart';
import '../../../../core/di/di_patterns.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';

/// Example: Notification feature dependencies using standardized patterns
/// This demonstrates how to implement a new feature following the established DI patterns
///
/// NOTE: This is a template/example. Actual implementations would need:
/// - NotificationRemoteDataSource interface and implementation
/// - NotificationRepository interface and implementation
/// - Use case implementations
/// - NotificationBloc implementation
void setupNotificationDependencies(GetIt getIt) {
  // Get existing instances from core
  final dioClient = getIt<DioClient>();
  final logger = getIt<AppLogger>();

  // Register data source with lazy singleton lifecycle
  // getIt.registerWithMetadata<NotificationRemoteDataSource>(
  //   () => NotificationRemoteDataSourceImpl(
  //     dioClient: dioClient,
  //     logger: logger,
  //   ),
  //   lifecycle: DILifecycle.lazySingleton,
  //   category: DICategory.datasource,
  //   name: DINaming.dataSource('Notification'),
  //   description: 'Notification remote data source for API communication',
  // );

  // Register repository with lazy singleton lifecycle
  // getIt.registerWithMetadata<NotificationRepository>(
  //   () => NotificationRepositoryImpl(
  //     remoteDataSource: getIt(),
  //     logger: logger,
  //   ),
  //   lifecycle: DILifecycle.lazySingleton,
  //   category: DICategory.repository,
  //   name: DINaming.repository('Notification'),
  //   description: 'Notification repository for business logic coordination',
  // );

  // Register use cases with lazy singleton lifecycle
  // DICommonPatterns.registerUseCases(
  //   getIt,
  //   {
  //     DINaming.useCase('GetNotifications', 'Notification'): () => GetNotificationsUseCase(repository: getIt()),
  //     DINaming.useCase('MarkNotificationRead', 'Notification'): () => MarkNotificationReadUseCase(repository: getIt()),
  //     DINaming.useCase('GetNotificationCount', 'Notification'): () => GetNotificationCountUseCase(repository: getIt()),
  //   },
  //   lifecycle: DILifecycle.lazySingleton,
  // );

  // Register BLoC with factory lifecycle (new instance each time)
  // getIt.registerWithMetadata<NotificationBloc>(
  //   () => NotificationBloc(
  //     getNotificationsUseCase: getIt(),
  //     markNotificationReadUseCase: getIt(),
  //     getNotificationCountUseCase: getIt(),
  //   ),
  //   lifecycle: DILifecycle.factory,
  //   category: DICategory.bloc,
  //   name: DINaming.bloc('Notification'),
  //   description: 'Notification BLoC for notification state management',
  // );

  // For demonstration, we'll log the setup
  logger.info('Notification feature dependencies setup completed');
  logger.info('To implement this feature, uncomment the above code and create the necessary files:');
  logger.info('1. NotificationRemoteDataSource interface and implementation');
  logger.info('2. NotificationRepository interface and implementation');
  logger.info('3. Use case implementations');
  logger.info('4. NotificationBloc implementation');
}