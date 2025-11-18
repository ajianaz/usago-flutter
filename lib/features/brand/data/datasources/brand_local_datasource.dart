import 'package:fpdart/fpdart.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/brand_invitation.dart';
import '../../../../core/errors/failure.dart';

/// Abstract interface for brand local data source
/// Defines contract for all local brand operations
abstract interface class BrandLocalDataSource {
  /// Cache brands locally for offline access
  Future<Either<Failure, void>> cacheBrands(List<Brand> brands);

  /// Get cached brands for offline access
  Future<Either<Failure, List<Brand>>> getCachedBrands();

  /// Clear brand cache
  Future<Either<Failure, void>> clearBrandCache();

  /// Save active brand ID locally
  Future<Either<Failure, void>> saveActiveBrandId(String brandId);

  /// Get active brand ID from local storage
  Future<Either<Failure, String?>> getActiveBrandId();

  /// Clear active brand ID from local storage
  Future<Either<Failure, void>> clearActiveBrandId();

  /// Cache a single brand locally
  Future<Either<Failure, void>> cacheBrand(Brand brand);

  /// Get cached brand by ID
  Future<Either<Failure, Brand?>> getCachedBrand(String id);

  /// Cache brand invitations locally
  Future<Either<Failure, void>> cacheBrandInvitations(List<BrandInvitation> invitations);

  /// Get cached brand invitations
  Future<Either<Failure, List<BrandInvitation>>> getCachedBrandInvitations();
}