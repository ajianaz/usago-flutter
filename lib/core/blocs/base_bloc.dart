import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../performance/performance_tracker.dart';
import '../config/app_config.dart';
import '../utils/logger.dart';
import '../errors/failure.dart' as core_failure;

/// Base event class for all BLoC events
abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];

  /// Optional correlation ID for tracking related operations
  String? get correlationId => null;

  /// Optional metadata for the event
  Map<String, dynamic>? get metadata => null;
}

/// Base state class for all BLoC states
abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];

  /// Whether the state represents a loading state
  bool get isLoading => this is BaseLoadingState;

  /// Whether the state represents an error state
  bool get isError => this is BaseErrorState;

  /// Whether the state represents a success state
  bool get isSuccess => this is BaseSuccessState;

  /// Get the failure if this is an error state
  core_failure.Failure? get failure =>
      this is BaseErrorState ? (this as BaseErrorState).failure : null;
}

/// Initial state for BLoCs
class BaseInitialState extends BaseState {
  const BaseInitialState();
}

/// Loading state for BLoCs
class BaseLoadingState extends BaseState {
  final String? message;
  final Map<String, dynamic>? metadata;

  const BaseLoadingState({this.message, this.metadata});

  @override
  List<Object?> get props => [message, metadata];
}

/// Success state for BLoCs
class BaseSuccessState<T> extends BaseState {
  final T? data;
  final String? message;
  final Map<String, dynamic>? metadata;

  const BaseSuccessState({this.data, this.message, this.metadata});

  @override
  List<Object?> get props => [data, message, metadata];
}

/// Error state for BLoCs
class BaseErrorState extends BaseState {
  final core_failure.Failure failure;
  final String? userMessage;
  final Map<String, dynamic>? metadata;

  const BaseErrorState({
    required this.failure,
    this.userMessage,
    this.metadata,
  });

  @override
  List<Object?> get props => [failure, userMessage, metadata];

  /// Get the display message for the error
  String get displayMessage => userMessage ?? failure.displayMessage;
}

/// Base BLoC class with common functionality
///
/// [Event] - Type of events this BLoC handles
/// [State] - Type of states this BLoC emits
abstract class BaseBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<Event, State> {
  final PerformanceTracker _performanceTracker;
  final AppLogger _logger;
  String? _blocTrackingId;

  /// Get the name of this BLoC for logging purposes
  String get blocName => runtimeType.toString();

  BaseBloc({
    required State initialState,
    PerformanceTracker? performanceTracker,
    AppLogger? logger,
  })  : _performanceTracker = performanceTracker ?? PerformanceTracker(),
        _logger = logger ?? AppLogger(),
        super(initialState) {
    // Initialize performance tracking
    _initializePerformanceTracking();

    // Register common event handlers
    _registerCommonHandlers();
  }

  /// Initialize performance tracking for this BLoC
  void _initializePerformanceTracking() {
    if (!AppConfig.enablePerformanceMonitoring) return;

    _blocTrackingId = _performanceTracker.startTracking(
      blocName,
      category: 'bloc_lifecycle',
    );

    _logger.debug('Performance tracking initialized for BLoC: $blocName');
  }

  /// Register common event handlers
  void _registerCommonHandlers() {
    // Register any common event handlers here
    // This can be extended by subclasses
  }

  @override
  void onTransition(Transition<Event, State> transition) {
    // Track performance if enabled
    if (AppConfig.enablePerformanceMonitoring) {
      _performanceTracker.trackTransition(
        blocName,
        transition.event.runtimeType.toString(),
        transition.currentState.runtimeType.toString(),
        transition.nextState.runtimeType.toString(),
      );
    }

    // Log transition
    _logTransition(transition);

    super.onTransition(transition);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Track error if performance monitoring is enabled
    if (AppConfig.enablePerformanceMonitoring) {
      _performanceTracker.trackError(
        blocName,
        error.toString(),
        stackTrace.toString(),
      );
    }

    // Log error
    _logger.error('Error in BLoC: $blocName', error, stackTrace);

    super.onError(error, stackTrace);
  }

  @override
  Future<void> close() {
    // Stop performance tracking and clean up resources
    if (_blocTrackingId != null && AppConfig.enablePerformanceMonitoring) {
      _performanceTracker.stopTracking(_blocTrackingId!);
      _logger.debug('Performance tracking stopped for BLoC: $blocName');
    }

    // Clean up resources
    _cleanup();

    _logger.debug('BLoC closed: $blocName');
    return super.close();
  }

  /// Handle use case execution with proper error handling and state management
  ///
  /// [useCase] - The use case to execute
  /// [params] - Parameters for the use case
  /// [loadingMessage] - Optional loading message
  /// [successMessage] - Optional success message
  /// [eventName] - Name for tracking purposes
  /// Returns [Future<void>] - Completes when the operation is done
  Future<void> executeUseCase<T, P>(
    Future<Either<core_failure.Failure, T>> Function(P) useCase,
    P params, {
    String? loadingMessage,
    String? successMessage,
    String? eventName,
    Map<String, dynamic>? metadata,
  }) async {
    final opName = eventName ?? 'UseCaseExecution';
    final trackingId = AppConfig.enablePerformanceMonitoring
        ? _performanceTracker.startTracking(opName, category: 'usecase')
        : null;

    try {
      // Emit loading state
      final loadingState = _createLoadingState(loadingMessage, metadata);
      if (isClosed) return;
      _emitState(loadingState);

      // Execute use case
      final result = await useCase(params);

      // Handle result
      final newState = result.fold(
        (failure) {
          if (trackingId != null) {
            _performanceTracker.stopTracking(trackingId, metadata: {
              'success': false,
              'error': failure?.message,
              ...?metadata,
            });
          }

          // DEBUG: Log before calling _createErrorState
          print('DEBUG: BaseBloc.executeUseCase - Creating error state for use case failure');
          print('DEBUG: Failure type: ${failure.runtimeType}');
          print('DEBUG: Failure is core_failure.Failure: ${failure is core_failure.Failure}');

          final errorState = _createErrorState(failure!, metadata);
          print('DEBUG: Error state created: ${errorState.runtimeType}');
          return errorState;
        },
        (data) {
          if (trackingId != null) {
            _performanceTracker.stopTracking(trackingId, metadata: {
              'success': true,
              'dataType': T.toString(),
              ...?metadata,
            });
          }

          return _createSuccessState(data, successMessage, metadata);
        },
      );

      if (isClosed) return;
      _emitState(newState);
    } catch (e, stackTrace) {
      _logger.error(
          'Unexpected error in use case execution: $opName', e, stackTrace);

      if (trackingId != null) {
        _performanceTracker.stopTracking(trackingId, metadata: {
          'success': false,
          'error': e.toString(),
          ...?metadata,
        });
      }

      final errorState = _createErrorState(
        core_failure.UnknownFailure(
          message: 'An unexpected error occurred during $opName',
          originalError: e,
        ),
        metadata,
      );

      if (isClosed) return;
      _emitState(errorState);
    }
  }

  /// Helper method to safely emit states
  void _emitState(State state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  /// Handle void use case execution with proper error handling and state management
  ///
  /// [useCase] - The use case to execute
  /// [params] - Parameters for the use case
  /// [loadingMessage] - Optional loading message
  /// [successMessage] - Optional success message
  /// [eventName] - Name for tracking purposes
  /// Returns [Future<void>] - Completes when the operation is done
  Future<void> executeVoidUseCase<P>(
    Future<Either<core_failure.Failure, void>> Function(P) useCase,
    P params, {
    String? loadingMessage,
    String? successMessage,
    String? eventName,
    Map<String, dynamic>? metadata,
  }) async {
    final opName = eventName ?? 'VoidUseCaseExecution';
    final trackingId = AppConfig.enablePerformanceMonitoring
        ? _performanceTracker.startTracking(opName, category: 'usecase')
        : null;

    try {
      // Emit loading state
      final loadingState = _createLoadingState(loadingMessage, metadata);
      if (isClosed) return;
      _emitState(loadingState);

      // Execute use case
      final result = await useCase(params);

      // Handle result
      final newState = result.fold(
        (failure) {
          if (trackingId != null) {
            _performanceTracker.stopTracking(trackingId, metadata: {
              'success': false,
              'error': failure?.message,
              ...?metadata,
            });
          }

          return _createErrorState(failure!, metadata);
        },
        (_) {
          if (trackingId != null) {
            _performanceTracker.stopTracking(trackingId, metadata: {
              'success': true,
              'operation': 'void',
              ...?metadata,
            });
          }

          return _createSuccessState<void>(null, successMessage, metadata);
        },
      );

      if (isClosed) return;
      _emitState(newState);
    } catch (e, stackTrace) {
      _logger.error('Unexpected error in void use case execution: $opName', e,
          stackTrace);

      if (trackingId != null) {
        _performanceTracker.stopTracking(trackingId, metadata: {
          'success': false,
          'error': e.toString(),
          ...?metadata,
        });
      }

      final errorState = _createErrorState(
        core_failure.UnknownFailure(
          message: 'An unexpected error occurred during $opName',
          originalError: e,
        ),
        metadata,
      );

      if (isClosed) return;
      _emitState(errorState);
    }
  }

  /// Create loading state - override in subclasses for custom loading states
  State _createLoadingState(String? message, Map<String, dynamic>? metadata) {
    // Default implementation - subclasses should override
    return BaseLoadingState(message: message, metadata: metadata) as State;
  }

  /// Create success state - override in subclasses for custom success states
  State _createSuccessState<T>(
      T? data, String? message, Map<String, dynamic>? metadata) {
    // Default implementation - subclasses should override
    return BaseSuccessState<T>(data: data, message: message, metadata: metadata)
        as State;
  }

  /// Create error state - must be implemented by subclasses for proper type safety
  State _createErrorState(core_failure.Failure failure, Map<String, dynamic>? metadata);

  /// Get metadata for transition tracking
  Map<String, dynamic>? _getTransitionMetadata(
      Transition<Event, State> transition) {
    final metadata = <String, dynamic>{
      'eventType': transition.event.runtimeType.toString(),
      'fromState': transition.currentState.runtimeType.toString(),
      'toState': transition.nextState.runtimeType.toString(),
    };

    // Add event metadata if available
    if (transition.event.metadata != null) {
      metadata['eventMetadata'] = transition.event.metadata;
    }

    // Add correlation ID if available
    if (transition.event.correlationId != null) {
      metadata['correlationId'] = transition.event.correlationId;
    }

    return metadata;
  }

  /// Log transition with appropriate level
  void _logTransition(Transition<Event, State> transition) {
    final message =
        'BLoC Transition: $blocName - ${transition.event.runtimeType} -> ${transition.nextState.runtimeType}';

    // Check for error state using the base state's isError property
    if (transition.nextState.isError) {
      _logger.error(message);
    } else if (transition.nextState.isLoading) {
      _logger.debug(message);
    } else {
      _logger.info(message);
    }
  }

  /// Clean up resources - override in subclasses
  void _cleanup() {
    // Default implementation - subclasses can override
  }

  /// Emit error state with proper logging
  void emitError(core_failure.Failure failure, {Map<String, dynamic>? metadata}) {
    if (isClosed) return;
    _logger.error('Emitting error state in BLoC: $blocName', failure);
    _emitState(_createErrorState(failure, metadata));
  }

  /// Emit loading state with proper logging
  void emitLoading({String? message, Map<String, dynamic>? metadata}) {
    if (isClosed) return;
    _logger.debug('Emitting loading state in BLoC: $blocName', message);
    _emitState(_createLoadingState(message, metadata));
  }

  /// Emit success state with proper logging
  void emitSuccess<T>(T data,
      {String? message, Map<String, dynamic>? metadata}) {
    if (isClosed) return;
    _logger.info(
        'Emitting success state in BLoC: $blocName', {'data': data.toString()});
    _emitState(_createSuccessState(data, message, metadata));
  }
}

/// Example usage:
///
/// class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
///   final LoginUseCase _loginUseCase;
///
///   AuthBloc({required LoginUseCase loginUseCase})
///       : _loginUseCase = loginUseCase,
///         super(const AuthInitial()) {
///     on<LoginEvent>(_onLogin);
///   }
///
///   Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
///     await executeUseCase(
///       _loginUseCase.call,
///       LoginParams(email: event.email, password: event.password),
///       loadingMessage: 'Logging in...',
///       successMessage: 'Login successful',
///       eventName: 'Login',
///       metadata: {'email': event.email},
///     );
///   }
///
///   @override
///   AuthState _createLoadingState(String? message, Map<String, dynamic>? metadata) {
///     return AuthLoading(message: message);
///   }
///
///   @override
///   AuthState _createSuccessState<T>(T? data, String? message, Map<String, dynamic>? metadata) {
///     if (data is User) {
///       return AuthSuccess(user: data, message: message);
///     }
///     return AuthSuccess(user: User.empty(), message: message);
///   }
///
///   @override
///   AuthState _createErrorState(Failure failure, Map<String, dynamic>? metadata) {
///     return AuthFailure(failure: failure);
///   }
/// }
