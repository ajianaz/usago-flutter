import 'package:fpdart/fpdart.dart';
import '../entities/brand.dart';
import '../entities/brand_invitation.dart';
import '../../../../core/errors/failure.dart';

/// Abstract interface for brand repository operations
/// Following the repository pattern for clean architecture
abstract class BrandRepository {
  /// Get all brands belonging to the current user
  Future<Either<Failure, List<Brand>>> getUserBrands();

  /// Get all brands accessible to the current user
  Future<Either<Failure, List<Brand>>> getAccessibleBrands();

  /// Get a specific brand by ID
  Future<Either<Failure, Brand>> getBrandById(String id);

  /// Get a specific brand by slug
  Future<Either<Failure, Brand>> getBrandBySlug(String slug);

  /// Create a new brand
  Future<Either<Failure, Brand>> createBrand(Map<String, dynamic> brandData);

  /// Update an existing brand
  Future<Either<Failure, Brand>> updateBrand(String id, Map<String, dynamic> brandData);

  /// Delete a brand
  Future<Either<Failure, void>> deleteBrand(String id);

  /// Switch the active brand for the current user
  Future<Either<Failure, Brand>> switchActiveBrand(String brandId);

  /// Transfer brand ownership to another user
  Future<Either<Failure, void>> transferOwnership(
    String brandId,
    String newOwnerId,
    String confirmationCode,
  );

  /// Invite a user to join a brand
  Future<Either<Failure, BrandInvitation>> inviteUser(
    String brandId,
    Map<String, dynamic> invitationData,
  );

  /// Accept a brand invitation
  Future<Either<Failure, void>> acceptInvitation(
    String invitationId,
    String token,
  );

  /// Decline a brand invitation
  Future<Either<Failure, void>> declineInvitation(String invitationId);

  /// Get all invitations for a specific brand
  Future<Either<Failure, List<BrandInvitation>>> getBrandInvitations(String brandId);

  /// Get brand statistics
  Future<Either<Failure, Map<String, dynamic>>> getBrandStats(String brandId);

  /// Get the currently active brand for the user
  Future<Either<Failure, Brand?>> getActiveBrand();

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
}