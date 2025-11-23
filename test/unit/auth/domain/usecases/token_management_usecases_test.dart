import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:usago/core/errors/failure.dart';
import 'package:usago/features/auth/domain/repositories/auth_repository.dart';
import 'package:usago/features/auth/domain/usecases/get_refresh_tokens_usecase.dart';
import 'package:usago/features/auth/domain/usecases/revoke_token_usecase.dart';
import 'package:usago/features/auth/domain/usecases/revoke_all_tokens_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('Token Management Use Cases', () {
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
    });

    group('GetRefreshTokensUsecase', () {
      late GetRefreshTokensUsecase usecase;

      setUp(() {
        usecase = GetRefreshTokensUsecase(repository: mockAuthRepository);
      });

      test('should return tokens when repository call is successful', () async {
        // Arrange
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

        when(() => mockAuthRepository.getRefreshTokens())
            .thenAnswer((_) async => Right(testTokens));

        // Act
        final result = await usecase(const GetRefreshTokensParams());

        // Assert
        expect(result, Right(testTokens));
        verify(() => mockAuthRepository.getRefreshTokens()).called(1);
      });

      test('should return failure when repository call fails', () async {
        // Arrange
        const failure = ServerFailure(message: 'Failed to get tokens');
        when(() => mockAuthRepository.getRefreshTokens())
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await usecase(const GetRefreshTokensParams());

        // Assert
        expect(result, const Left(failure));
        verify(() => mockAuthRepository.getRefreshTokens()).called(1);
      });
    });

    group('RevokeTokenUsecase', () {
      late RevokeTokenUsecase usecase;
      const testToken = 'test-refresh-token';

      setUp(() {
        usecase = RevokeTokenUsecase(repository: mockAuthRepository);
      });

      test(
          'should revoke token successfully when repository call is successful',
          () async {
        // Arrange
        when(() => mockAuthRepository.revokeToken(testToken))
            .thenAnswer((_) async => const Right(null));

        // Act
        final result = await usecase(
          const RevokeTokenParams(refreshToken: testToken),
        );

        // Assert
        expect(result, const Right(null));
        verify(() => mockAuthRepository.revokeToken(testToken)).called(1);
      });

      test('should return validation failure when refresh token is empty',
          () async {
        // Act
        final result = await usecase(
          const RevokeTokenParams(refreshToken: ''),
        );

        // Assert
        expect(
          result,
          const Left(
            ValidationFailure(message: 'Refresh token cannot be empty'),
          ),
        );
        verifyNever(() => mockAuthRepository.revokeToken(any()));
      });

      test('should return failure when repository call fails', () async {
        // Arrange
        const failure = ServerFailure(message: 'Failed to revoke token');
        when(() => mockAuthRepository.revokeToken(testToken))
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await usecase(
          const RevokeTokenParams(refreshToken: testToken),
        );

        // Assert
        expect(result, const Left(failure));
        verify(() => mockAuthRepository.revokeToken(testToken)).called(1);
      });
    });

    group('RevokeAllTokensUsecase', () {
      late RevokeAllTokensUsecase usecase;

      setUp(() {
        usecase = RevokeAllTokensUsecase(repository: mockAuthRepository);
      });

      test(
          'should revoke all tokens successfully when repository call is successful',
          () async {
        // Arrange
        when(() => mockAuthRepository.revokeAllTokens())
            .thenAnswer((_) async => const Right(null));

        // Act
        final result = await usecase(const RevokeAllTokensParams());

        // Assert
        expect(result, const Right(null));
        verify(() => mockAuthRepository.revokeAllTokens()).called(1);
      });

      test('should return failure when repository call fails', () async {
        // Arrange
        const failure = ServerFailure(message: 'Failed to revoke all tokens');
        when(() => mockAuthRepository.revokeAllTokens())
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await usecase(const RevokeAllTokensParams());

        // Assert
        expect(result, const Left(failure));
        verify(() => mockAuthRepository.revokeAllTokens()).called(1);
      });
    });

    group('Error Scenarios', () {
      late GetRefreshTokensUsecase getTokensUsecase;
      late RevokeTokenUsecase revokeTokenUsecase;
      late RevokeAllTokensUsecase revokeAllTokensUsecase;

      setUp(() {
        getTokensUsecase =
            GetRefreshTokensUsecase(repository: mockAuthRepository);
        revokeTokenUsecase = RevokeTokenUsecase(repository: mockAuthRepository);
        revokeAllTokensUsecase =
            RevokeAllTokensUsecase(repository: mockAuthRepository);
      });

      test('should handle network failure in get tokens', () async {
        // Arrange
        const failure = NetworkFailure(message: 'No internet connection');
        when(() => mockAuthRepository.getRefreshTokens())
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await getTokensUsecase(const GetRefreshTokensParams());

        // Assert
        expect(result, const Left(failure));
      });

      test('should handle unauthorized failure in revoke token', () async {
        // Arrange
        const failure = ServerFailure(message: 'Unauthorized', statusCode: 401);
        when(() => mockAuthRepository.revokeToken('test-token'))
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await revokeTokenUsecase(
          const RevokeTokenParams(refreshToken: 'test-token'),
        );

        // Assert
        expect(result, const Left(failure));
      });

      test('should handle server error in revoke all tokens', () async {
        // Arrange
        const failure = ServerFailure(message: 'Server error', statusCode: 500);
        when(() => mockAuthRepository.revokeAllTokens())
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result =
            await revokeAllTokensUsecase(const RevokeAllTokensParams());

        // Assert
        expect(result, const Left(failure));
      });

      test('should handle validation failure in revoke token', () async {
        // Arrange
        const failure = ValidationFailure(message: 'Invalid token format');
        when(() => mockAuthRepository.revokeToken('invalid-token'))
            .thenAnswer((_) async => const Left(failure));

        // Act
        final result = await revokeTokenUsecase(
          const RevokeTokenParams(refreshToken: 'invalid-token'),
        );

        // Assert
        expect(result, const Left(failure));
      });
    });

    group('Integration Tests', () {
      late GetRefreshTokensUsecase getTokensUsecase;
      late RevokeTokenUsecase revokeTokenUsecase;
      late RevokeAllTokensUsecase revokeAllTokensUsecase;

      setUp(() {
        getTokensUsecase =
            GetRefreshTokensUsecase(repository: mockAuthRepository);
        revokeTokenUsecase = RevokeTokenUsecase(repository: mockAuthRepository);
        revokeAllTokensUsecase =
            RevokeAllTokensUsecase(repository: mockAuthRepository);
      });

      test('should handle complete token management flow', () async {
        // Arrange - Get tokens
        final testTokens = [
          {
            'id': 'token1',
            'deviceName': 'iPhone 14',
            'lastSeen': '2024-01-15T10:30:00Z',
          },
          {
            'id': 'token2',
            'deviceName': 'MacBook Pro',
            'lastSeen': '2024-01-14T15:45:00Z',
          },
        ];

        when(() => mockAuthRepository.getRefreshTokens())
            .thenAnswer((_) async => Right(testTokens));

        // Act 1 - Get tokens
        final getResult =
            await getTokensUsecase(const GetRefreshTokensParams());
        expect(getResult, Right(testTokens));

        // Arrange - Revoke single token
        when(() => mockAuthRepository.revokeToken('token1'))
            .thenAnswer((_) async => const Right(null));

        // Act 2 - Revoke single token
        final revokeResult = await revokeTokenUsecase(
          const RevokeTokenParams(refreshToken: 'token1'),
        );
        expect(revokeResult, const Right(null));

        // Arrange - Revoke all tokens
        when(() => mockAuthRepository.revokeAllTokens())
            .thenAnswer((_) async => const Right(null));

        // Act 3 - Revoke all tokens
        final revokeAllResult = await revokeAllTokensUsecase(
          const RevokeAllTokensParams(),
        );
        expect(revokeAllResult, const Right(null));

        // Verify all calls were made
        verify(() => mockAuthRepository.getRefreshTokens()).called(1);
        verify(() => mockAuthRepository.revokeToken('token1')).called(1);
        verify(() => mockAuthRepository.revokeAllTokens()).called(1);
      });
    });
  });
}
