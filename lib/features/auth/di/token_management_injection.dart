import 'package:get_it/get_it.dart';
import '../domain/usecases/get_refresh_tokens_usecase.dart';
import '../domain/usecases/revoke_token_usecase.dart';
import '../domain/usecases/revoke_all_tokens_usecase.dart';
import '../presentation/bloc/token_management/token_management_bloc.dart';
import '../../../../core/utils/logger.dart';

/// Register token management dependencies
void setupTokenManagementDependencies(GetIt getIt) {
  // Get existing instances from core and auth
  final logger = getIt<AppLogger>();

  // Use cases should already be registered in auth_injection.dart
  // We just need to get them and register the BLoC

  // Register Token Management BLoC
  getIt.registerSingleton(
    TokenManagementBloc(
      getRefreshTokensUsecase: getIt<GetRefreshTokensUsecase>(),
      revokeTokenUsecase: getIt<RevokeTokenUsecase>(),
      revokeAllTokensUsecase: getIt<RevokeAllTokensUsecase>(),
      logger: logger,
    ),
  );
}
