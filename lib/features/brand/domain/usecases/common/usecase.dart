import 'package:fpdart/fpdart.dart';
import '../../../../../core/errors/failure.dart';

/// Base Use Case class untuk semua use cases di brand feature
/// Menggunakan pattern Either untuk error handling
///
/// [Type] adalah return type dari use case
/// [Params] adalah parameter type untuk use case
abstract class UseCase<Type, Params> {
  /// Execute the use case dengan parameter yang diberikan
  ///
  /// Returns [Future<Either<Failure, Type>>] dengan:
  /// - [Left] berisi [Failure] jika terjadi error
  /// - [Right] berisi [Type] jika berhasil
  Future<Either<Failure, Type>> call(Params params);
}

/// Parameter class untuk use cases yang tidak memerlukan parameter
class NoParams {
  const NoParams();
}