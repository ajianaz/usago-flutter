import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:usago/core/errors/failure.dart';
import 'package:usago/core/utils/logger.dart';
import 'package:usago/features/auth/domain/usecases/get_refresh_tokens_usecase.dart';
import 'package:usago/features/auth/domain/usecases/revoke_token_usecase.dart';
import 'package:usago/features/auth/domain/usecases/revoke_all_tokens_usecase.dart';
import 'package:usago/features/auth/presentation/bloc/token_management/token_management_bloc.dart';
import 'package:usago/features/auth/presentation/bloc/token_management/token_management_event.dart';
import 'package:usago/features/auth/presentation/bloc/token_management/token_management_state.dart';

class MockGetRefreshTokensUsecase extends Mock
    implements GetRefreshTokensUsecase {}

class MockRevokeTokenUsecase extends Mock implements RevokeTokenUsecase {}

class MockRevokeAllTokensUsecase extends Mock
    implements RevokeAllTokensUsecase {}

class MockAppLogger extends Mock implements AppLogger {}

void main() {
  group('TokenManagementBloc', () {
    late TokenManagementBloc tokenManagementBloc;
    late MockGetRefreshTokensUsecase mockGetRefreshTokensUsecase;
    late MockRevokeTokenUsecase mockRevokeTokenUsecase;
    late MockRevokeAllTokensUsecase mockRevokeAllTokensUsecase;
    late MockAppLogger mockAppLogger;

    setUpAll(() {
      // Register fallback values for parameter types
      registerFallbackValue(const GetRefreshTokensParams());
      registerFallbackValue(
          const RevokeTokenParams(refreshToken: 'test-token-id'));
      registerFallbackValue(const RevokeAllTokensParams());
    });

    setUp(() {
      mockGetRefreshTokensUsecase = MockGetRefreshTokensUsecase();
      mockRevokeTokenUsecase = MockRevokeTokenUsecase();
      mockRevokeAllTokensUsecase = MockRevokeAllTokensUsecase();
      mockAppLogger = MockAppLogger();

      tokenManagementBloc = TokenManagementBloc(
        getRefreshTokensUsecase: mockGetRefreshTokensUsecase,
        revokeTokenUsecase: mockRevokeTokenUsecase,
        revokeAllTokensUsecase: mockRevokeAllTokensUsecase,
        logger: mockAppLogger,
      );
    });

    tearDown(() {
      tokenManagementBloc.close();
    });

    test('initial state should be TokenManagementInitial', () {
      expect(tokenManagementBloc.state, const TokenManagementInitial());
    });

    group('LoadTokensEvent', () {
      final testTokens = [
        {
          'id': 'token1',
          'deviceName': 'iPhone 14',
          'lastSeen': '2024-01-15T10:30:00Z',
          'createdAt': '2024-01-01T08:00:00Z',
          'expiresAt': '2024-02-01T08:00:00Z',
          'userAgent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0)',
          'ip': '192.168.1.100',
        },
        {
          'id': 'token2',
          'deviceName': 'MacBook Pro',
          'lastSeen': '2024-01-14T15:45:00Z',
          'createdAt': '2024-01-02T09:00:00Z',
          'expiresAt': '2024-02-02T09:00:00Z',
          'userAgent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)',
          'ip': '192.168.1.101',
        },
      ];

      test(
          'should emit [TokenManagementLoading, TokenManagementLoaded] when load tokens is successful',
          () async {
        // Arrange
        when(() => mockGetRefreshTokensUsecase(const GetRefreshTokensParams()))
            .thenAnswer((_) async => Right(testTokens));

        // Act
        final expected = [
          const TokenManagementLoading(),
          TokenManagementLoaded(
            tokens: testTokens,
            filteredTokens: testTokens,
            sortType: TokenSortType.lastSeen,
            ascending: false,
          ),
        ];

        // Assert
        expectLater(tokenManagementBloc.stream, emitsInOrder(expected));

        tokenManagementBloc.add(const LoadTokensEvent());
      });

      test(
          'should emit [TokenManagementLoading, TokenManagementEmpty] when no tokens found',
          () async {
        // Arrange
        when(() => mockGetRefreshTokensUsecase(const GetRefreshTokensParams()))
            .thenAnswer((_) async => const Right([]));

        // Act
        final expected = [
          const TokenManagementLoading(),
          const TokenManagementEmpty(),
        ];

        // Assert
        expectLater(tokenManagementBloc.stream, emitsInOrder(expected));

        tokenManagementBloc.add(const LoadTokensEvent());
      });

      test(
          'should emit [TokenManagementLoading, TokenManagementError] when load tokens fails',
          () async {
        // Arrange
        const failure = ServerFailure(message: 'Failed to load tokens');
        when(() => mockGetRefreshTokensUsecase(const GetRefreshTokensParams()))
            .thenAnswer((_) async => const Left(failure));

        // Act
        final expected = [
          const TokenManagementLoading(),
          TokenManagementError(message: failure.message, errorCode: '500'),
        ];

        // Assert
        expectLater(tokenManagementBloc.stream, emitsInOrder(expected));

        tokenManagementBloc.add(const LoadTokensEvent());
      });
    });

    group('RevokeTokenEvent', () {
      const refreshToken = 'test-refresh-token';
      const deviceName = 'iPhone 14';

      test(
          'should emit [TokenManagementLoading, TokenManagementRevoked] when revocation is successful',
          () async {
        // Arrange
        when(() => mockRevokeTokenUsecase(
                const RevokeTokenParams(refreshToken: refreshToken)))
            .thenAnswer((_) async => const Right(null));

        // Act
        final expected = [
          const TokenManagementLoading(),
          TokenManagementRevoked(
            tokenId: refreshToken,
            deviceName: deviceName,
            message: 'Token berhasil direvoke dari $deviceName',
          ),
        ];

        // Assert
        expectLater(tokenManagementBloc.stream, emitsInOrder(expected));

        tokenManagementBloc.add(const RevokeTokenEvent(
          refreshToken: refreshToken,
          deviceName: deviceName,
        ));
      });

      test(
          'should emit [TokenManagementLoading, TokenManagementError] when revocation fails',
          () async {
        // Arrange
        const failure = ServerFailure(message: 'Token revocation failed');
        when(() => mockRevokeTokenUsecase(
                const RevokeTokenParams(refreshToken: refreshToken)))
            .thenAnswer((_) async => const Left(failure));

        // Act
        final expected = [
          const TokenManagementLoading(),
          TokenManagementError(message: failure.message, errorCode: '500'),
        ];

        // Assert
        expectLater(tokenManagementBloc.stream, emitsInOrder(expected));

        tokenManagementBloc
            .add(const RevokeTokenEvent(refreshToken: refreshToken));
      });

      test(
          'should emit [TokenManagementLoading, TokenManagementError] when refresh token is empty',
          () async {
        // Act
        final expected = [
          const TokenManagementLoading(),
          const TokenManagementError(
            message: 'Refresh token tidak boleh kosong',
            errorCode: 'VALIDATION_ERROR',
          ),
        ];

        // Assert
        expectLater(tokenManagementBloc.stream, emitsInOrder(expected));

        tokenManagementBloc.add(const RevokeTokenEvent(refreshToken: ''));
      });
    });

    group('RevokeAllTokensEvent', () {
      test(
          'should emit [TokenManagementLoading, TokenManagementAllRevoked] when revocation is successful',
          () async {
        // Arrange
        when(() => mockRevokeAllTokensUsecase(const RevokeAllTokensParams()))
            .thenAnswer((_) async => const Right(null));

        // Act
        final expected = [
          const TokenManagementLoading(),
          const TokenManagementAllRevoked(
            message: 'Semua tokens berhasil direvoke',
          ),
        ];

        // Assert
        expectLater(tokenManagementBloc.stream, emitsInOrder(expected));

        tokenManagementBloc.add(const RevokeAllTokensEvent());
      });

      test(
          'should emit [TokenManagementLoading, TokenManagementError] when revocation fails',
          () async {
        // Arrange
        const failure = ServerFailure(message: 'Bulk revocation failed');
        when(() => mockRevokeAllTokensUsecase(const RevokeAllTokensParams()))
            .thenAnswer((_) async => const Left(failure));

        // Act
        final expected = [
          const TokenManagementLoading(),
          TokenManagementError(message: failure.message, errorCode: '500'),
        ];

        // Assert
        expectLater(tokenManagementBloc.stream, emitsInOrder(expected));

        tokenManagementBloc.add(const RevokeAllTokensEvent());
      });
    });

    group('RefreshTokensEvent', () {
      final testTokens = [
        {
          'id': 'token1',
          'deviceName': 'iPhone 14',
          'lastSeen': '2024-01-15T10:30:00Z',
        },
      ];

      test(
          'should emit [TokenManagementLoading, TokenManagementLoaded] when refresh is successful',
          () async {
        // Arrange
        when(() => mockGetRefreshTokensUsecase(const GetRefreshTokensParams()))
            .thenAnswer((_) async => Right(testTokens));

        // Act
        final expected = [
          const TokenManagementLoading(),
          TokenManagementLoaded(
            tokens: testTokens,
            filteredTokens: testTokens,
            sortType: TokenSortType.lastSeen,
            ascending: false,
          ),
        ];

        // Assert
        expectLater(tokenManagementBloc.stream, emitsInOrder(expected));

        tokenManagementBloc.add(const RefreshTokensEvent());
      });

      test(
          'should emit [TokenManagementRefreshing, TokenManagementLoaded] when refresh is successful with existing state',
          () async {
        // Arrange - Set initial state first
        final currentState = TokenManagementLoaded(
          tokens: testTokens,
          filteredTokens: testTokens,
          sortType: TokenSortType.deviceName,
          ascending: true,
          deviceTypeFilter: 'iPhone',
          searchTerm: 'test',
        );

        when(() => mockGetRefreshTokensUsecase(const GetRefreshTokensParams()))
            .thenAnswer((_) async => Right(testTokens));

        // Act
        final expected = [
          TokenManagementRefreshing(currentTokens: testTokens),
          TokenManagementLoaded(
            tokens: testTokens,
            filteredTokens: testTokens,
            sortType: TokenSortType.deviceName,
            ascending: true,
            deviceTypeFilter: 'iPhone',
            searchTerm: 'test',
          ),
        ];

        // Assert
        expectLater(tokenManagementBloc.stream, emitsInOrder(expected));

        // Set state and then add event
        tokenManagementBloc.emit(currentState);
        tokenManagementBloc.add(const RefreshTokensEvent());
      });
    });

    group('FilterTokensEvent', () {
      final testTokens = [
        {
          'id': 'token1',
          'deviceName': 'iPhone 14',
          'lastSeen': '2024-01-15T10:30:00Z',
          'userAgent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0)',
          'ip': '192.168.1.100',
        },
        {
          'id': 'token2',
          'deviceName': 'MacBook Pro',
          'lastSeen': '2024-01-14T15:45:00Z',
          'userAgent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)',
          'ip': '192.168.1.101',
        },
      ];

      test('should filter tokens by device type', () async {
        // Arrange - Set initial state
        final currentState = TokenManagementLoaded(
          tokens: testTokens,
          filteredTokens: testTokens,
        );

        // Act
        final expectedState = currentState.copyWith(
          filteredTokens: [testTokens[0]], // Only iPhone
          deviceTypeFilter: 'iPhone',
        );

        // Assert
        expectLater(tokenManagementBloc.stream, emits(expectedState));

        tokenManagementBloc.emit(currentState);
        tokenManagementBloc.add(const FilterTokensEvent(deviceType: 'iPhone'));
      });

      test('should filter tokens by search term', () async {
        // Arrange - Set initial state
        final currentState = TokenManagementLoaded(
          tokens: testTokens,
          filteredTokens: testTokens,
        );

        // Act
        final expectedState = currentState.copyWith(
          filteredTokens: [testTokens[1]], // Only MacBook
          searchTerm: 'MacBook',
        );

        // Assert
        expectLater(tokenManagementBloc.stream, emits(expectedState));

        tokenManagementBloc.emit(currentState);
        tokenManagementBloc.add(const FilterTokensEvent(searchTerm: 'MacBook'));
      });

      test('should filter tokens by both device type and search term',
          () async {
        // Arrange - Set initial state
        final currentState = TokenManagementLoaded(
          tokens: testTokens,
          filteredTokens: testTokens,
        );

        // Act
        final expectedState = currentState.copyWith(
          filteredTokens: [testTokens[0]], // iPhone with iPhone in name
          deviceTypeFilter: 'iPhone',
          searchTerm: 'iPhone',
        );

        // Assert
        expectLater(tokenManagementBloc.stream, emits(expectedState));

        tokenManagementBloc.emit(currentState);
        tokenManagementBloc.add(const FilterTokensEvent(
          deviceType: 'iPhone',
          searchTerm: 'iPhone',
        ));
      });
    });

    group('SortTokensEvent', () {
      final testTokens = [
        {
          'id': 'token1',
          'deviceName': 'iPhone 14',
          'lastSeen': '2024-01-15T10:30:00Z',
          'createdAt': '2024-01-01T08:00:00Z',
          'expiresAt': '2024-02-01T08:00:00Z',
        },
        {
          'id': 'token2',
          'deviceName': 'Android Phone',
          'lastSeen': '2024-01-14T15:45:00Z',
          'createdAt': '2024-01-02T09:00:00Z',
          'expiresAt': '2024-02-02T09:00:00Z',
        },
      ];

      test('should sort tokens by device name ascending', () async {
        // Arrange - Set initial state
        final currentState = TokenManagementLoaded(
          tokens: testTokens,
          filteredTokens: testTokens,
        );

        // Act - Sort by device name ascending
        final expectedState = currentState.copyWith(
          filteredTokens: [testTokens[1], testTokens[0]], // Android, iPhone
          sortType: TokenSortType.deviceName,
          ascending: true,
        );

        // Assert
        expectLater(tokenManagementBloc.stream, emits(expectedState));

        tokenManagementBloc.emit(currentState);
        tokenManagementBloc.add(const SortTokensEvent(
          sortType: TokenSortType.deviceName,
          ascending: true,
        ));
      });

      test('should sort tokens by last seen descending', () async {
        // Arrange - Set initial state
        final currentState = TokenManagementLoaded(
          tokens: testTokens,
          filteredTokens: testTokens,
        );

        // Act - Sort by last seen descending (newest first)
        final expectedState = currentState.copyWith(
          filteredTokens: [
            testTokens[0],
            testTokens[1]
          ], // iPhone (newer), Android
          sortType: TokenSortType.lastSeen,
          ascending: false,
        );

        // Assert
        expectLater(tokenManagementBloc.stream, emits(expectedState));

        tokenManagementBloc.emit(currentState);
        tokenManagementBloc.add(const SortTokensEvent(
          sortType: TokenSortType.lastSeen,
          ascending: false,
        ));
      });
    });

    group('ClearTokenManagementEvent', () {
      test('should emit TokenManagementInitial', () async {
        // Act
        final expected = [const TokenManagementInitial()];

        // Assert
        expectLater(tokenManagementBloc.stream, emitsInOrder(expected));

        tokenManagementBloc.add(const ClearTokenManagementEvent());
      });
    });

    group('Error Handling', () {
      test('should handle network failure properly', () async {
        // Arrange
        const failure = NetworkFailure(message: 'No internet connection');
        when(() => mockGetRefreshTokensUsecase(const GetRefreshTokensParams()))
            .thenAnswer((_) async => const Left(failure));

        // Act
        final expected = [
          const TokenManagementLoading(),
          const TokenManagementError(
            message:
                'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.',
            errorCode: 'NETWORK_ERROR',
          ),
        ];

        // Assert
        expectLater(tokenManagementBloc.stream, emitsInOrder(expected));

        tokenManagementBloc.add(const LoadTokensEvent());
      });

      test('should handle validation failure properly', () async {
        // Arrange
        const failure = ValidationFailure(message: 'Invalid token format');
        when(() => mockRevokeTokenUsecase(
                const RevokeTokenParams(refreshToken: 'invalid-token')))
            .thenAnswer((_) async => const Left(failure));

        // Act
        final expected = [
          const TokenManagementLoading(),
          const TokenManagementError(
            message: 'Invalid token format',
            errorCode: 'VALIDATION_ERROR',
          ),
        ];

        // Assert
        expectLater(tokenManagementBloc.stream, emitsInOrder(expected));

        tokenManagementBloc
            .add(const RevokeTokenEvent(refreshToken: 'invalid-token'));
      });

      test('should handle unauthorized failure properly', () async {
        // Arrange
        const failure = ServerFailure(message: 'Unauthorized', statusCode: 401);
        when(() => mockGetRefreshTokensUsecase(const GetRefreshTokensParams()))
            .thenAnswer((_) async => const Left(failure));

        // Act
        final expected = [
          const TokenManagementLoading(),
          const TokenManagementError(
            message: 'Sesi Anda telah berakhir. Silakan login kembali.',
            errorCode: '401',
          ),
        ];

        // Assert
        expectLater(tokenManagementBloc.stream, emitsInOrder(expected));

        tokenManagementBloc.add(const LoadTokensEvent());
      });
    });
  });
}
