import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usago/core/errors/failure.dart';
import 'package:usago/features/brand/domain/entities/brand.dart';
import 'package:usago/features/brand/domain/entities/brand_invitation.dart';
import 'package:usago/features/brand/domain/repositories/brand_repository.dart';

/// Mock implementation of BrandRepository for testing
class MockBrandRepository extends Mock implements BrandRepository {
  @override
  Future<Either<Failure, List<Brand>>> getAllBrands() =>
      super.noSuchMethod(Invocation.method(#getAllBrands, []));

  @override
  Future<Either<Failure, List<Brand>>> getUserBrands() =>
      super.noSuchMethod(Invocation.method(#getUserBrands, []));

  @override
  Future<Either<Failure, List<Brand>>> getAccessibleBrands() =>
      super.noSuchMethod(Invocation.method(#getAccessibleBrands, []));

  @override
  Future<Either<Failure, Brand>> getBrandById(String id) =>
      super.noSuchMethod(Invocation.method(#getBrandById, [id]));

  @override
  Future<Either<Failure, Brand>> getBrandBySlug(String slug) =>
      super.noSuchMethod(Invocation.method(#getBrandBySlug, [slug]));

  @override
  Future<Either<Failure, Brand>> createBrand(Map<String, dynamic> brandData) =>
      super.noSuchMethod(Invocation.method(#createBrand, [brandData]));

  @override
  Future<Either<Failure, Brand>> updateBrand(
    String id,
    Map<String, dynamic> brandData,
  ) =>
      super.noSuchMethod(Invocation.method(#updateBrand, [id, brandData]));

  @override
  Future<Either<Failure, void>> deleteBrand(String id) =>
      super.noSuchMethod(Invocation.method(#deleteBrand, [id]));

  @override
  Future<Either<Failure, Brand>> switchActiveBrand(
    String brandId, {
    String? branchId,
  }) =>
      super.noSuchMethod(
          Invocation.method(#switchActiveBrand, [brandId, branchId]));

  @override
  Future<Either<Failure, void>> transferOwnership(
    String brandId,
    String newOwnerId,
    String confirmationCode,
  ) =>
      super.noSuchMethod(
        Invocation.method(
            #transferOwnership, [brandId, newOwnerId, confirmationCode]),
      );

  @override
  Future<Either<Failure, BrandInvitation>> inviteUser(
    String brandId,
    Map<String, dynamic> invitationData,
  ) =>
      super.noSuchMethod(
        Invocation.method(#inviteUser, [brandId, invitationData]),
      );

  @override
  Future<Either<Failure, void>> acceptInvitation(
    String invitationId,
    String token,
  ) =>
      super.noSuchMethod(
        Invocation.method(#acceptInvitation, [invitationId, token]),
      );

  @override
  Future<Either<Failure, void>> declineInvitation(String invitationId) =>
      super.noSuchMethod(Invocation.method(#declineInvitation, [invitationId]));

  @override
  Future<Either<Failure, List<BrandInvitation>>> getBrandInvitations(
    String brandId,
  ) =>
      super.noSuchMethod(Invocation.method(#getBrandInvitations, [brandId]));

  @override
  Future<Either<Failure, List<BrandInvitation>>> getUserInvitations() =>
      super.noSuchMethod(Invocation.method(#getUserInvitations, []));

  @override
  Future<Either<Failure, void>> cancelInvitation(String invitationId) =>
      super.noSuchMethod(Invocation.method(#cancelInvitation, [invitationId]));

  @override
  Future<Either<Failure, void>> resendInvitation(String invitationId) =>
      super.noSuchMethod(Invocation.method(#resendInvitation, [invitationId]));

  @override
  Future<Either<Failure, Map<String, dynamic>>> getBrandStats(String brandId) =>
      super.noSuchMethod(Invocation.method(#getBrandStats, [brandId]));

  @override
  Future<Either<Failure, Brand?>> getActiveBrand() =>
      super.noSuchMethod(Invocation.method(#getActiveBrand, []));

  @override
  Future<Either<Failure, void>> cacheBrands(List<Brand> brands) =>
      super.noSuchMethod(Invocation.method(#cacheBrands, [brands]));

  @override
  Future<Either<Failure, List<Brand>>> getCachedBrands() =>
      super.noSuchMethod(Invocation.method(#getCachedBrands, []));

  @override
  Future<Either<Failure, void>> clearBrandCache() =>
      super.noSuchMethod(Invocation.method(#clearBrandCache, []));

  @override
  Future<Either<Failure, void>> saveActiveBrandId(String brandId) =>
      super.noSuchMethod(Invocation.method(#saveActiveBrandId, [brandId]));

  @override
  Future<Either<Failure, String?>> getActiveBrandId() =>
      super.noSuchMethod(Invocation.method(#getActiveBrandId, []));

  @override
  Future<Either<Failure, void>> clearActiveBrandId() =>
      super.noSuchMethod(Invocation.method(#clearActiveBrandId, []));
}
