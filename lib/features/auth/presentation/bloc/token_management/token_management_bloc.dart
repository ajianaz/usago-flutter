import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/utils/logger.dart';
import '../../../domain/usecases/get_refresh_tokens_usecase.dart';
import '../../../domain/usecases/revoke_token_usecase.dart';
import '../../../domain/usecases/revoke_all_tokens_usecase.dart';
import 'token_management_event.dart';
import 'token_management_state.dart';

/// Token Management BLoC
/// Bertanggung jawab untuk mengelola refresh tokens
/// Menggunakan use cases untuk business logic
class TokenManagementBloc
    extends Bloc<TokenManagementEvent, TokenManagementState> {
  final GetRefreshTokensUsecase _getRefreshTokensUsecase;
  final RevokeTokenUsecase _revokeTokenUsecase;
  final RevokeAllTokensUsecase _revokeAllTokensUsecase;
  final AppLogger _logger;

  TokenManagementBloc({
    required GetRefreshTokensUsecase getRefreshTokensUsecase,
    required RevokeTokenUsecase revokeTokenUsecase,
    required RevokeAllTokensUsecase revokeAllTokensUsecase,
    required AppLogger logger,
  })  : _getRefreshTokensUsecase = getRefreshTokensUsecase,
        _revokeTokenUsecase = revokeTokenUsecase,
        _revokeAllTokensUsecase = revokeAllTokensUsecase,
        _logger = logger,
        super(const TokenManagementInitial()) {
    // Register event handlers
    on<LoadTokensEvent>(_onLoadTokens);
    on<RevokeTokenEvent>(_onRevokeToken);
    on<RevokeAllTokensEvent>(_onRevokeAllTokens);
    on<RefreshTokensEvent>(_onRefreshTokens);
    on<ClearTokenManagementEvent>(_onClearTokenManagement);
    on<FilterTokensEvent>(_onFilterTokens);
    on<SortTokensEvent>(_onSortTokens);
  }

  /// Handler untuk load tokens
  Future<void> _onLoadTokens(
    LoadTokensEvent event,
    Emitter<TokenManagementState> emit,
  ) async {
    emit(const TokenManagementLoading());

    try {
      final result =
          await _getRefreshTokensUsecase(const GetRefreshTokensParams());

      result.fold(
        (failure) => emit(TokenManagementError(
          message: _mapFailureToMessage(failure),
          errorCode: _mapFailureToErrorCode(failure),
        )),
        (tokens) {
          _logger.info('Loaded ${tokens.length} tokens');

          if (tokens.isEmpty) {
            emit(const TokenManagementEmpty());
          } else {
            final sortedTokens =
                _sortTokens(tokens, TokenSortType.lastSeen, false);
            emit(TokenManagementLoaded(
              tokens: tokens,
              filteredTokens: sortedTokens,
              sortType: TokenSortType.lastSeen,
              ascending: false,
            ));
          }
        },
      );
    } catch (e) {
      _logger.error('Error loading tokens: $e');
      emit(TokenManagementError(
        message: 'Terjadi kesalahan saat memuat tokens',
        errorCode: 'UNKNOWN_ERROR',
      ));
    }
  }

  /// Handler untuk revoke single token
  Future<void> _onRevokeToken(
    RevokeTokenEvent event,
    Emitter<TokenManagementState> emit,
  ) async {
    // Validasi refresh token
    if (event.refreshToken.isEmpty) {
      emit(const TokenManagementError(
        message: 'Refresh token tidak boleh kosong',
        errorCode: 'VALIDATION_ERROR',
      ));
      return;
    }

    emit(const TokenManagementLoading());

    try {
      final result = await _revokeTokenUsecase(
        RevokeTokenParams(refreshToken: event.refreshToken),
      );

      result.fold(
        (failure) => emit(TokenManagementError(
          message: _mapFailureToMessage(failure),
          errorCode: _mapFailureToErrorCode(failure),
        )),
        (_) {
          _logger.info('Successfully revoked token: ${event.refreshToken}');
          emit(TokenManagementRevoked(
            tokenId: event.refreshToken,
            deviceName: event.deviceName,
            message:
                'Token berhasil direvoke${event.deviceName != null ? ' dari ${event.deviceName}' : ''}',
          ));

          // Auto reload tokens setelah revoke
          add(const LoadTokensEvent());
        },
      );
    } catch (e) {
      _logger.error('Error revoking token: $e');
      emit(TokenManagementError(
        message: 'Terjadi kesalahan saat merevoke token',
        errorCode: 'UNKNOWN_ERROR',
      ));
    }
  }

  /// Handler untuk revoke all tokens
  Future<void> _onRevokeAllTokens(
    RevokeAllTokensEvent event,
    Emitter<TokenManagementState> emit,
  ) async {
    emit(const TokenManagementLoading());

    try {
      final result =
          await _revokeAllTokensUsecase(const RevokeAllTokensParams());

      result.fold(
        (failure) => emit(TokenManagementError(
          message: _mapFailureToMessage(failure),
          errorCode: _mapFailureToErrorCode(failure),
        )),
        (_) {
          _logger.info('Successfully revoked all tokens');
          emit(const TokenManagementAllRevoked(
            message: 'Semua tokens berhasil direvoke',
          ));

          // Auto reload tokens setelah revoke all
          add(const LoadTokensEvent());
        },
      );
    } catch (e) {
      _logger.error('Error revoking all tokens: $e');
      emit(TokenManagementError(
        message: 'Terjadi kesalahan saat merevoke semua tokens',
        errorCode: 'UNKNOWN_ERROR',
      ));
    }
  }

  /// Handler untuk refresh tokens
  Future<void> _onRefreshTokens(
    RefreshTokensEvent event,
    Emitter<TokenManagementState> emit,
  ) async {
    if (state is TokenManagementLoaded) {
      final currentTokens = (state as TokenManagementLoaded).tokens;
      emit(TokenManagementRefreshing(currentTokens: currentTokens));
    } else {
      emit(const TokenManagementLoading());
    }

    try {
      final result =
          await _getRefreshTokensUsecase(const GetRefreshTokensParams());

      result.fold(
        (failure) => emit(TokenManagementError(
          message: _mapFailureToMessage(failure),
          errorCode: _mapFailureToErrorCode(failure),
        )),
        (tokens) {
          _logger.info('Refreshed ${tokens.length} tokens');

          if (tokens.isEmpty) {
            emit(const TokenManagementEmpty());
          } else {
            // Maintain current filter and sort settings
            TokenSortType sortType = TokenSortType.lastSeen;
            bool ascending = false;
            String? deviceTypeFilter;
            String? searchTerm;

            if (state is TokenManagementLoaded) {
              final currentState = state as TokenManagementLoaded;
              sortType = currentState.sortType;
              ascending = currentState.ascending;
              deviceTypeFilter = currentState.deviceTypeFilter;
              searchTerm = currentState.searchTerm;
            }

            var filteredTokens =
                _filterTokens(tokens, deviceTypeFilter, searchTerm);
            filteredTokens = _sortTokens(filteredTokens, sortType, ascending);

            emit(TokenManagementLoaded(
              tokens: tokens,
              filteredTokens: filteredTokens,
              sortType: sortType,
              ascending: ascending,
              deviceTypeFilter: deviceTypeFilter,
              searchTerm: searchTerm,
            ));
          }
        },
      );
    } catch (e) {
      _logger.error('Error refreshing tokens: $e');
      emit(TokenManagementError(
        message: 'Terjadi kesalahan saat refresh tokens',
        errorCode: 'UNKNOWN_ERROR',
      ));
    }
  }

  /// Handler untuk clear state
  Future<void> _onClearTokenManagement(
    ClearTokenManagementEvent event,
    Emitter<TokenManagementState> emit,
  ) async {
    emit(const TokenManagementInitial());
  }

  /// Handler untuk filter tokens
  Future<void> _onFilterTokens(
    FilterTokensEvent event,
    Emitter<TokenManagementState> emit,
  ) async {
    if (state is! TokenManagementLoaded) return;

    final currentState = state as TokenManagementLoaded;
    final filteredTokens = _filterTokens(
      currentState.tokens,
      event.deviceType,
      event.searchTerm,
    );

    final sortedTokens = _sortTokens(
        filteredTokens, currentState.sortType, currentState.ascending);

    emit(currentState.copyWith(
      filteredTokens: sortedTokens,
      deviceTypeFilter: event.deviceType,
      searchTerm: event.searchTerm,
    ));
  }

  /// Handler untuk sort tokens
  Future<void> _onSortTokens(
    SortTokensEvent event,
    Emitter<TokenManagementState> emit,
  ) async {
    if (state is! TokenManagementLoaded) return;

    final currentState = state as TokenManagementLoaded;
    final sortedTokens = _sortTokens(
      currentState.filteredTokens,
      event.sortType,
      event.ascending,
    );

    emit(currentState.copyWith(
      filteredTokens: sortedTokens,
      sortType: event.sortType,
      ascending: event.ascending,
    ));
  }

  /// Filter tokens berdasarkan device type dan search term
  List<Map<String, dynamic>> _filterTokens(
    List<Map<String, dynamic>> tokens,
    String? deviceType,
    String? searchTerm,
  ) {
    var filtered = List<Map<String, dynamic>>.from(tokens);

    // Filter by device type
    if (deviceType != null && deviceType.isNotEmpty) {
      filtered = filtered.where((token) {
        final deviceName = token['deviceName']?.toString().toLowerCase() ?? '';
        return deviceName.contains(deviceType.toLowerCase());
      }).toList();
    }

    // Filter by search term
    if (searchTerm != null && searchTerm.isNotEmpty) {
      filtered = filtered.where((token) {
        final deviceName = token['deviceName']?.toString().toLowerCase() ?? '';
        final userAgent = token['userAgent']?.toString().toLowerCase() ?? '';
        final ip = token['ip']?.toString().toLowerCase() ?? '';
        final searchLower = searchTerm.toLowerCase();

        return deviceName.contains(searchLower) ||
            userAgent.contains(searchLower) ||
            ip.contains(searchLower);
      }).toList();
    }

    return filtered;
  }

  /// Sort tokens berdasarkan sort type
  List<Map<String, dynamic>> _sortTokens(
    List<Map<String, dynamic>> tokens,
    TokenSortType sortType,
    bool ascending,
  ) {
    final sortedTokens = List<Map<String, dynamic>>.from(tokens);

    sortedTokens.sort((a, b) {
      int comparison = 0;

      switch (sortType) {
        case TokenSortType.lastSeen:
          final aLastSeen = a['lastSeen'] as String? ?? '';
          final bLastSeen = b['lastSeen'] as String? ?? '';
          comparison = aLastSeen.compareTo(bLastSeen);
          break;
        case TokenSortType.deviceName:
          final aDeviceName = a['deviceName']?.toString().toLowerCase() ?? '';
          final bDeviceName = b['deviceName']?.toString().toLowerCase() ?? '';
          comparison = aDeviceName.compareTo(bDeviceName);
          break;
        case TokenSortType.createdAt:
          final aCreatedAt = a['createdAt'] as String? ?? '';
          final bCreatedAt = b['createdAt'] as String? ?? '';
          comparison = aCreatedAt.compareTo(bCreatedAt);
          break;
        case TokenSortType.expiresAt:
          final aExpiresAt = a['expiresAt'] as String? ?? '';
          final bExpiresAt = b['expiresAt'] as String? ?? '';
          comparison = aExpiresAt.compareTo(bExpiresAt);
          break;
      }

      return ascending ? comparison : -comparison;
    });

    return sortedTokens;
  }

  /// Mapping failure ke user-friendly message
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        final serverFailure = failure as ServerFailure;
        if (serverFailure.statusCode == 404) {
          return 'Token tidak ditemukan';
        } else if (serverFailure.statusCode == 403) {
          return 'Anda tidak memiliki izin untuk melakukan operasi ini';
        } else if (serverFailure.statusCode == 401) {
          return 'Sesi Anda telah berakhir. Silakan login kembali.';
        }
        return failure.message;
      case NetworkFailure:
        return 'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.';
      case ValidationFailure:
        return failure.message;
      case BetterAuthFailure:
        return 'Anda tidak memiliki izin untuk melakukan operasi ini';
      case ConflictFailure:
        final conflictFailure = failure as ConflictFailure;
        return conflictFailure.message;
      default:
        return 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.';
    }
  }

  /// Mapping failure ke error code
  String? _mapFailureToErrorCode(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        final serverFailure = failure as ServerFailure;
        if (serverFailure.statusCode == 404) {
          return 'NOT_FOUND';
        } else if (serverFailure.statusCode == 403) {
          return 'UNAUTHORIZED';
        } else if (serverFailure.statusCode == 401) {
          return 'UNAUTHORIZED';
        }
        return serverFailure.statusCode?.toString();
      case NetworkFailure:
        return 'NETWORK_ERROR';
      case ValidationFailure:
        return 'VALIDATION_ERROR';
      case BetterAuthFailure:
        return 'UNAUTHORIZED';
      case ConflictFailure:
        final conflictFailure = failure as ConflictFailure;
        return conflictFailure.code ?? 'CONFLICT';
      default:
        return 'UNKNOWN_ERROR';
    }
  }
}
