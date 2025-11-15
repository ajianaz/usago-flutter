import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../../lib/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import '../../../../../lib/features/auth/data/datasources/auth_local_datasource.dart';
import '../../../../../lib/features/auth/data/models/user_model.dart';
import '../../../../../lib/core/network/dio_client.dart';
import '../../../../../lib/core/utils/logger.dart';
import '../../../../../lib/core/errors/failure.dart';
import '../../../../../lib/core/errors/exceptions.dart';

import 'auth_remote_datasource_impl_test.mocks.dart';

@GenerateMocks([DioClient, AppLogger, AuthLocalDatasource])
void main() {
  group('AuthRemoteDatasourceImpl Tests', () {
    late AuthRemoteDatasourceImpl datasource;
    late MockDioClient mockDioClient;
    late MockAppLogger mockLogger;
    late MockAuthLocalDatasource mockLocalDatasource;

    setUp(() {
      mockDioClient = MockDioClient();
      mockLogger = MockAppLogger();
      mockLocalDatasource = MockAuthLocalDatasource();
      datasource = AuthRemoteDatasourceImpl(
        dioClient: mockDioClient,
        logger: mockLogger,
        localDatasource: mockLocalDatasource,
      );
    });

    group('login', () {
      test('should return UserModel on successful login', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        final userModel = UserModel(
          id: 'test-id',
          email: email,
          name: 'Test User',
          isEmailVerified: true,
          createdAt: DateTime.now(),
        );

        final response = Response(
          data: {'user': userModel.toJson()},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/signin'),
          headers: {
            'set-auth-token': ['Bearer token123'],
          },
        );

        when(mockDioClient.postWithHeaders(any, data: anyNamed('data')))
            .thenAnswer((_) async => response);
        when(mockLocalDatasource.saveToken(any))
            .thenAnswer((_) async {});

        // Act
        final result = await datasource.login(email: email, password: password);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (user) {
            expect(user.id, equals(userModel.id));
            expect(user.email, equals(userModel.email));
            expect(user.name, equals(userModel.name));
          },
        );
        verify(mockLocalDatasource.saveToken('Bearer token123')).called(1);
      });

      test('should return AuthFailure on invalid credentials', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'wrongpassword';

        final dioException = DioException(
          response: Response(
            data: {
              'code': 'INVALID_CREDENTIALS',
              'message': 'Invalid email or password',
            },
            statusCode: 401,
            requestOptions: RequestOptions(path: '/auth/signin'),
          ),
          requestOptions: RequestOptions(path: '/auth/signin'),
        );

        when(mockDioClient.postWithHeaders(any, data: anyNamed('data')))
            .thenThrow(dioException);

        // Act
        final result = await datasource.login(email: email, password: password);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.code, equals('INVALID_CREDENTIALS'));
          },
          (user) => fail('Expected failure but got success'),
        );
      });

      test('should return NetworkFailure on connection timeout', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        final dioException = DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: '/auth/signin'),
        );

        when(mockDioClient.postWithHeaders(any, data: anyNamed('data')))
            .thenThrow(dioException);

        // Act
        final result = await datasource.login(email: email, password: password);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<NetworkFailure>());
            expect(failure.code, equals('TIMEOUT'));
          },
          (user) => fail('Expected failure but got success'),
        );
      });
    });

    group('register', () {
      test('should return UserModel on successful registration', () async {
        // Arrange
        const email = 'newuser@example.com';
        const password = 'password123';
        const name = 'New User';
        final userModel = UserModel(
          id: 'new-user-id',
          email: email,
          name: name,
          isEmailVerified: false,
          createdAt: DateTime.now(),
        );

        final response = Response(
          data: {'user': userModel.toJson()},
          statusCode: 201,
          requestOptions: RequestOptions(path: '/auth/signup'),
          headers: {
            'set-auth-token': ['Bearer token456'],
          },
        );

        when(mockDioClient.postWithHeaders(any, data: anyNamed('data')))
            .thenAnswer((_) async => response);
        when(mockLocalDatasource.saveToken(any))
            .thenAnswer((_) async {});

        // Act
        final result = await datasource.register(
          email: email,
          password: password,
          name: name,
        );

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (user) {
            expect(user.id, equals(userModel.id));
            expect(user.email, equals(userModel.email));
            expect(user.name, equals(userModel.name));
            expect(user.isEmailVerified, isFalse);
          },
        );
        verify(mockLocalDatasource.saveToken('Bearer token456')).called(1);
      });

      test('should return AuthFailure when email already exists', () async {
        // Arrange
        const email = 'existing@example.com';
        const password = 'password123';
        const name = 'Existing User';

        final dioException = DioException(
          response: Response(
            data: {
              'code': 'EMAIL_ALREADY_EXISTS',
              'message': 'Email already registered',
            },
            statusCode: 409,
            requestOptions: RequestOptions(path: '/auth/signup'),
          ),
          requestOptions: RequestOptions(path: '/auth/signup'),
        );

        when(mockDioClient.postWithHeaders(any, data: anyNamed('data')))
            .thenThrow(dioException);

        // Act
        final result = await datasource.register(
          email: email,
          password: password,
          name: name,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.code, equals('EMAIL_ALREADY_EXISTS'));
          },
          (user) => fail('Expected failure but got success'),
        );
      });
    });

    group('logout', () {
      test('should return void on successful logout', () async {
        // Arrange
        final response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/signout'),
        );

        when(mockDioClient.post(any)).thenAnswer((_) async => response);

        // Act
        final result = await datasource.logout();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (value) => expect(value, isNull),
        );
      });

      test('should return ServerFailure on logout error', () async {
        // Arrange
        final dioException = DioException(
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/auth/signout'),
          ),
          requestOptions: RequestOptions(path: '/auth/signout'),
        );

        when(mockDioClient.post(any)).thenThrow(dioException);

        // Act
        final result = await datasource.logout();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.code, equals('SERVER_ERROR'));
          },
          (value) => fail('Expected failure but got success'),
        );
      });
    });

    group('refreshToken', () {
      test('should return UserModel on successful token refresh', () async {
        // Arrange
        final userModel = UserModel(
          id: 'test-id',
          email: 'test@example.com',
          name: 'Test User',
          isEmailVerified: true,
          createdAt: DateTime.now(),
        );

        final response = Response(
          data: {'user': userModel.toJson()},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/refresh'),
          headers: {
            'set-auth-token': ['Bearer newtoken789'],
          },
        );

        when(mockDioClient.postWithHeaders(any))
            .thenAnswer((_) async => response);
        when(mockLocalDatasource.saveToken(any))
            .thenAnswer((_) async {});

        // Act
        final result = await datasource.refreshToken();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (user) {
            expect(user.id, equals(userModel.id));
            expect(user.email, equals(userModel.email));
          },
        );
        verify(mockLocalDatasource.saveToken('Bearer newtoken789')).called(1);
      });

      test('should return AuthFailure on invalid token', () async {
        // Arrange
        final dioException = DioException(
          response: Response(
            data: {
              'code': 'INVALID_TOKEN',
              'message': 'Token is invalid or expired',
            },
            statusCode: 401,
            requestOptions: RequestOptions(path: '/auth/refresh'),
          ),
          requestOptions: RequestOptions(path: '/auth/refresh'),
        );

        when(mockDioClient.postWithHeaders(any)).thenThrow(dioException);

        // Act
        final result = await datasource.refreshToken();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.code, equals('INVALID_TOKEN'));
          },
          (user) => fail('Expected failure but got success'),
        );
      });
    });

    group('forgotPassword', () {
      test('should return void on successful password reset request', () async {
        // Arrange
        const email = 'test@example.com';
        final response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/forgot-password'),
        );

        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => response);

        // Act
        final result = await datasource.forgotPassword(email);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (value) => expect(value, isNull),
        );
      });

      test('should return AuthFailure when user not found', () async {
        // Arrange
        const email = 'nonexistent@example.com';

        final dioException = DioException(
          response: Response(
            data: {
              'code': 'USER_NOT_FOUND',
              'message': 'User not found',
            },
            statusCode: 404,
            requestOptions: RequestOptions(path: '/auth/forgot-password'),
          ),
          requestOptions: RequestOptions(path: '/auth/forgot-password'),
        );

        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenThrow(dioException);

        // Act
        final result = await datasource.forgotPassword(email);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.code, equals('USER_NOT_FOUND'));
          },
          (value) => fail('Expected failure but got success'),
        );
      });
    });

    group('resetPassword', () {
      test('should return void on successful password reset', () async {
        // Arrange
        const token = 'reset-token-123';
        const newPassword = 'newpassword123';
        final response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/reset-password'),
        );

        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => response);

        // Act
        final result = await datasource.resetPassword(
          token: token,
          newPassword: newPassword,
        );

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (value) => expect(value, isNull),
        );
      });

      test('should return ValidationFailure on weak password', () async {
        // Arrange
        const token = 'reset-token-123';
        const newPassword = 'weak';

        final dioException = DioException(
          response: Response(
            data: {
              'code': 'WEAK_PASSWORD',
              'message': 'Password is too weak',
            },
            statusCode: 400,
            requestOptions: RequestOptions(path: '/auth/reset-password'),
          ),
          requestOptions: RequestOptions(path: '/auth/reset-password'),
        );

        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenThrow(dioException);

        // Act
        final result = await datasource.resetPassword(
          token: token,
          newPassword: newPassword,
        );

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<ValidationFailure>());
            expect(failure.code, equals('WEAK_PASSWORD'));
          },
          (value) => fail('Expected failure but got success'),
        );
      });
    });

    group('updateProfile', () {
      test('should return updated UserModel on successful profile update', () async {
        // Arrange
        const name = 'Updated Name';
        const profilePicture = 'https://example.com/new-avatar.jpg';
        final updatedUserModel = UserModel(
          id: 'test-id',
          email: 'test@example.com',
          name: name,
          profilePicture: profilePicture,
          isEmailVerified: true,
          createdAt: DateTime.now(),
        );

        final response = {
          'user': updatedUserModel.toJson(),
        };

        when(mockDioClient.put(any, data: anyNamed('data')))
            .thenAnswer((_) async => response);

        // Act
        final result = await datasource.updateProfile(
          name: name,
          profilePicture: profilePicture,
        );

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (user) {
            expect(user.name, equals(name));
            expect(user.profilePicture, equals(profilePicture));
          },
        );
      });

      test('should return ServerFailure on profile update error', () async {
        // Arrange
        final dioException = DioException(
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/auth/profile'),
          ),
          requestOptions: RequestOptions(path: '/auth/profile'),
        );

        when(mockDioClient.put(any, data: anyNamed('data')))
            .thenThrow(dioException);

        // Act
        final result = await datasource.updateProfile();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.code, equals('SERVER_ERROR'));
          },
          (user) => fail('Expected failure but got success'),
        );
      });
    });

    group('verifyEmail', () {
      test('should return void on successful email verification', () async {
        // Arrange
        const token = 'verification-token-123';
        final response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/verify-email'),
        );

        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => response);

        // Act
        final result = await datasource.verifyEmail(token);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (value) => expect(value, isNull),
        );
      });

      test('should return AuthFailure on invalid verification token', () async {
        // Arrange
        const token = 'invalid-token';

        final dioException = DioException(
          response: Response(
            data: {
              'code': 'INVALID_TOKEN',
              'message': 'Verification token is invalid',
            },
            statusCode: 401,
            requestOptions: RequestOptions(path: '/auth/verify-email'),
          ),
          requestOptions: RequestOptions(path: '/auth/verify-email'),
        );

        when(mockDioClient.post(any, data: anyNamed('data')))
            .thenThrow(dioException);

        // Act
        final result = await datasource.verifyEmail(token);

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.code, equals('INVALID_TOKEN'));
          },
          (value) => fail('Expected failure but got success'),
        );
      });
    });

    group('deleteAccount', () {
      test('should return void on successful account deletion', () async {
        // Arrange
        final response = Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: '/auth/delete-account'),
        );

        when(mockDioClient.delete(any)).thenAnswer((_) async => response);

        // Act
        final result = await datasource.deleteAccount();

        // Assert
        expect(result.isRight(), isTrue);
        result.fold(
          (failure) => fail('Expected success but got failure: $failure'),
          (value) => expect(value, isNull),
        );
      });

      test('should return ServerFailure on account deletion error', () async {
        // Arrange
        final dioException = DioException(
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/auth/delete-account'),
          ),
          requestOptions: RequestOptions(path: '/auth/delete-account'),
        );

        when(mockDioClient.delete(any)).thenThrow(dioException);

        // Act
        final result = await datasource.deleteAccount();

        // Assert
        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.code, equals('SERVER_ERROR'));
          },
          (value) => fail('Expected failure but got success'),
        );
      });
    });
  });
}