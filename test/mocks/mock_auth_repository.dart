import 'package:mocktail/mocktail.dart';

import '../../lib/features/auth/domain/repositories/auth_repository.dart';
import '../../lib/core/errors/failure.dart';
import '../../lib/features/auth/domain/entities/user.dart';

/// Mock AuthRepository using mocktail
class MockAuthRepository extends Mock implements AuthRepository {
  MockAuthRepository() {
    // Register fallback values for mocktail
    registerFallbackValue(User(
      id: 'test-id',
      email: 'test@example.com',
      name: 'Test User',
      isEmailVerified: true,
      createdAt: DateTime.now(),
    ));
  }
}
