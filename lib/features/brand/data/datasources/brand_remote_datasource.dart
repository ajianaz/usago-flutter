import 'package:fpdart/fpdart.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/brand_invitation.dart';
import '../../../../core/errors/failure.dart';

/// Abstract interface for brand remote data source
/// Defines contract for all remote brand operations
abstract interface class BrandRemoteDataSource {
  /// Get all brands belonging to the current user from remote API
  Future<Either<Failure, List<Brand>>> getUserBrands();

  /// Get all brands accessible to the current user from remote API
  Future<Either<Failure, List<Brand>>> getAccessibleBrands();

  /// Get a specific brand by ID from remote API
  Future<Either<Failure, Brand>> getBrandById(String id);

  /// Get a specific brand by slug from remote API
  Future<Either<Failure, Brand>> getBrandBySlug(String slug);

  /// Create a new brand via remote API
  Future<Either<Failure, Brand>> createBrand(Map<String, dynamic> brandData);

  /// Update an existing brand via remote API
  Future<Either<Failure, Brand>> updateBrand(String id, Map<String, dynamic> brandData);

  /// Delete a brand via remote API
  Future<Either<Failure, void>> deleteBrand(String id);

  /// Switch the active brand for the current user via remote API
  Future<Either<Failure, Brand>> switchActiveBrand(String brandId);

  /// Transfer brand ownership to another user via remote API
  Future<Either<Failure, void>> transferOwnership(
    String brandId,
    String newOwnerId,
    String confirmationCode,
  );

  /// Invite a user to join a brand via remote API
  Future<Either<Failure, BrandInvitation>> inviteUser(
    String brandId,
    Map<String, dynamic> invitationData,
  );

  /// Accept a brand invitation via remote API
  Future<Either<Failure, void>> acceptInvitation(
    String invitationId,
    String token,
  );

  /// Decline a brand invitation via remote API
  Future<Either<Failure, void>> declineInvitation(String invitationId);

  /// Get all invitations for a specific brand from remote API
  Future<Either<Failure, List<BrandInvitation>>> getBrandInvitations(String brandId);

  /// Get brand statistics from remote API
  Future<Either<Failure, Map<String, dynamic>>> getBrandStats(String brandId);
}