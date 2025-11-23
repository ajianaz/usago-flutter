import '../../domain/entities/brand.dart';
import '../../domain/entities/brand_invitation.dart';
import '../../domain/repositories/brand_repository.dart';
import '../datasources/brand_remote_datasource.dart';
import '../datasources/brand_local_datasource.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/logger.dart';
import 'package:fpdart/fpdart.dart';

/// Implementation of BrandRepository
/// Handles all brand operations combining remote and local data sources
class BrandRepositoryImpl implements BrandRepository {
  final BrandRemoteDataSource _remoteDataSource;
  final BrandLocalDataSource _localDataSource;
  final AppLogger _logger;

  BrandRepositoryImpl({
    required BrandRemoteDataSource remoteDataSource,
    required BrandLocalDataSource localDataSource,
    required AppLogger logger,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _logger = logger;

  @override
  Future<Either<Failure, List<Brand>>> getUserBrands() async {
    try {
      // Try to get cached brands first for offline support
      final cachedResult = await _localDataSource.getCachedBrands();
      final cachedBrands = cachedResult.fold(
        (failure) {
          _logger.warning(
              'Failed to get cached brands, fetching from remote: ${failure.message}');
          return <Brand>[];
        },
        (brands) => brands,
      );

      // Fetch from remote
      final remoteResult = await _remoteDataSource.getUserBrands();

      return remoteResult.fold(
        (failure) {
          _logger.error(
              'Failed to fetch user brands from remote: ${failure.message}',
              failure);
          // Return cached brands if remote fails
          if (cachedBrands.isNotEmpty) {
            _logger.info('Returning cached brands as fallback');
            return Right(cachedBrands);
          }
          return Left(failure);
        },
        (brands) async {
          // Cache the fresh brands
          await _localDataSource.cacheBrands(brands);
          return Right(brands);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in getUserBrands', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<Brand>>> getAccessibleBrands() async {
    try {
      final result = await _remoteDataSource.getAccessibleBrands();

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to get accessible brands: ${failure.message}', failure);
          return Left(failure);
        },
        (brands) async {
          // Cache accessible brands
          await _localDataSource.cacheBrands(brands);
          return Right(brands);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in getAccessibleBrands', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Brand>> getBrandById(String id) async {
    try {
      final result = await _remoteDataSource.getBrandById(id);

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to get brand by ID: ${failure.message}', failure);
          return Left(failure);
        },
        (brand) async {
          // Cache the brand
          await _localDataSource.cacheBrand(brand);
          return Right(brand);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in getBrandById', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Brand>> getBrandBySlug(String slug) async {
    try {
      final result = await _remoteDataSource.getBrandBySlug(slug);

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to get brand by slug: ${failure.message}', failure);
          return Left(failure);
        },
        (brand) async {
          // Cache the brand
          await _localDataSource.cacheBrand(brand);
          return Right(brand);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in getBrandBySlug', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Brand>> createBrand(
      Map<String, dynamic> brandData) async {
    try {
      final result = await _remoteDataSource.createBrand(brandData);

      return result.fold(
        (failure) {
          _logger.error('Failed to create brand: ${failure.message}', failure);
          return Left(failure);
        },
        (brand) async {
          // Cache the new brand
          await _localDataSource.cacheBrand(brand);

          // Set as active brand
          await _localDataSource.saveActiveBrandId(brand.id);

          _logger
              .info('Successfully created and activated brand: ${brand.name}');
          return Right(brand);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in createBrand', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Brand>> updateBrand(
      String id, Map<String, dynamic> brandData) async {
    try {
      final result = await _remoteDataSource.updateBrand(id, brandData);

      return result.fold(
        (failure) {
          _logger.error('Failed to update brand: ${failure.message}', failure);
          return Left(failure);
        },
        (brand) async {
          // Cache the updated brand
          await _localDataSource.cacheBrand(brand);
          _logger.info('Successfully updated brand: $id');
          return Right(brand);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in updateBrand', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBrand(String id) async {
    try {
      final result = await _remoteDataSource.deleteBrand(id);

      return result.fold(
        (failure) {
          _logger.error('Failed to delete brand: ${failure.message}', failure);
          return Left(failure);
        },
        (_) async {
          // Clear from cache
          final cachedBrandResult = await _localDataSource.getCachedBrand(id);
          cachedBrandResult.fold(
            (failure) => _logger.warning(
                'Failed to get cached brand for deletion: ${failure.message}'),
            (cachedBrand) async {
              // Get all cached brands and remove the deleted one
              final allBrandsResult = await _localDataSource.getCachedBrands();
              allBrandsResult.fold(
                (failure) => _logger.warning(
                    'Failed to get all cached brands: ${failure.message}'),
                (allBrands) async {
                  final updatedBrands =
                      allBrands.where((brand) => brand.id != id).toList();
                  await _localDataSource.cacheBrands(updatedBrands);

                  // Clear active brand if it was the deleted one
                  final activeBrandResult =
                      await _localDataSource.getActiveBrandId();
                  activeBrandResult.fold(
                    (failure) => _logger.warning(
                        'Failed to get active brand ID: ${failure.message}'),
                    (activeBrandId) async {
                      if (activeBrandId == id) {
                        await _localDataSource.clearActiveBrandId();
                      }
                    },
                  );
                },
              );
            },
          );

          _logger.info('Successfully deleted brand: $id');
          return const Right(null);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in deleteBrand', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Brand>> switchActiveBrand(String brandId,
      {String? branchId}) async {
    try {
      final result = await _remoteDataSource.switchActiveBrand(brandId,
          branchId: branchId);

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to switch active brand: ${failure.message}', failure);
          return Left(failure);
        },
        (brand) async {
          // Save active brand ID locally
          await _localDataSource.saveActiveBrandId(brandId);

          // Cache the brand
          await _localDataSource.cacheBrand(brand);

          _logger.info('Successfully switched to active brand: $brandId');
          return Right(brand);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in switchActiveBrand', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> transferOwnership(
    String brandId,
    String newOwnerId,
    String confirmationCode,
  ) async {
    try {
      final result = await _remoteDataSource.transferOwnership(
          brandId, newOwnerId, confirmationCode);

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to transfer ownership: ${failure.message}', failure);
          return Left(failure);
        },
        (_) async {
          _logger
              .info('Successfully transferred ownership for brand: $brandId');
          return const Right(null);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in transferOwnership', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, BrandInvitation>> inviteUser(
    String brandId,
    Map<String, dynamic> invitationData,
  ) async {
    try {
      final result =
          await _remoteDataSource.inviteUser(brandId, invitationData);

      return result.fold(
        (failure) {
          _logger.error('Failed to invite user: ${failure.message}', failure);
          return Left(failure);
        },
        (invitation) async {
          // Cache the invitation
          final cachedInvitationsResult =
              await _localDataSource.getCachedBrandInvitations();
          final updatedInvitations = cachedInvitationsResult.fold(
            (failure) {
              _logger.warning(
                  'Failed to get cached invitations: ${failure.message}');
              return <BrandInvitation>[];
            },
            (invitations) => [...invitations, invitation],
          );

          await _localDataSource.cacheBrandInvitations(updatedInvitations);

          _logger.info('Successfully invited user to brand: $brandId');
          return Right(invitation);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in inviteUser', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> acceptInvitation(
    String invitationId,
    String token,
  ) async {
    try {
      final result =
          await _remoteDataSource.acceptInvitation(invitationId, token);

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to accept invitation: ${failure.message}', failure);
          return Left(failure);
        },
        (_) async {
          _logger.info('Successfully accepted invitation: $invitationId');
          return const Right(null);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in acceptInvitation', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> declineInvitation(String invitationId) async {
    try {
      final result = await _remoteDataSource.declineInvitation(invitationId);

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to decline invitation: ${failure.message}', failure);
          return Left(failure);
        },
        (_) async {
          _logger.info('Successfully declined invitation: $invitationId');
          return const Right(null);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in declineInvitation', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<BrandInvitation>>> getBrandInvitations(
      String brandId) async {
    try {
      final result = await _remoteDataSource.getBrandInvitations(brandId);

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to get brand invitations: ${failure.message}', failure);
          return Left(failure);
        },
        (invitations) async {
          // Cache the invitations
          await _localDataSource.cacheBrandInvitations(invitations);
          _logger.info(
              'Successfully retrieved ${invitations.length} invitations for brand: $brandId');
          return Right(invitations);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in getBrandInvitations', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getBrandStats(
      String brandId) async {
    try {
      final result = await _remoteDataSource.getBrandStats(brandId);

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to get brand stats: ${failure.message}', failure);
          return Left(failure);
        },
        (stats) {
          _logger.info('Successfully retrieved stats for brand: $brandId');
          return Right(stats);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in getBrandStats', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Brand?>> getActiveBrand() async {
    try {
      // Get active brand ID from local storage
      final activeBrandIdResult = await _localDataSource.getActiveBrandId();

      return activeBrandIdResult.fold(
        (failure) {
          _logger.error(
              'Failed to get active brand ID: ${failure.message}', failure);
          return const Right(null);
        },
        (activeBrandId) async {
          if (activeBrandId == null || activeBrandId.isEmpty) {
            _logger.warning('No active brand ID found');
            return const Right(null);
          }

          // Get brand from cache
          final cachedBrandResult =
              await _localDataSource.getCachedBrand(activeBrandId);

          return cachedBrandResult.fold(
            (failure) {
              _logger.error(
                  'Failed to get cached brand: ${failure.message}', failure);
              return const Right(null);
            },
            (brand) {
              _logger.info(
                  'Successfully retrieved active brand: ${brand?.name ?? 'Unknown'}');
              return Right(brand);
            },
          );
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in getActiveBrand', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> cacheBrands(List<Brand> brands) async {
    try {
      final result = await _localDataSource.cacheBrands(brands);

      return result.fold(
        (failure) {
          _logger.error('Failed to cache brands: ${failure.message}', failure);
          return Left(failure);
        },
        (_) {
          _logger.info('Successfully cached ${brands.length} brands');
          return const Right(null);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in cacheBrands', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<Brand>>> getCachedBrands() async {
    try {
      final result = await _localDataSource.getCachedBrands();

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to get cached brands: ${failure.message}', failure);
          return Left(failure);
        },
        (brands) {
          _logger.info('Successfully retrieved ${brands.length} cached brands');
          return Right(brands);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in getCachedBrands', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> clearBrandCache() async {
    try {
      final result = await _localDataSource.clearBrandCache();

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to clear brand cache: ${failure.message}', failure);
          return Left(failure);
        },
        (_) {
          _logger.info('Successfully cleared brand cache');
          return const Right(null);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in clearBrandCache', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> saveActiveBrandId(String brandId) async {
    try {
      final result = await _localDataSource.saveActiveBrandId(brandId);

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to save active brand ID: ${failure.message}', failure);
          return Left(failure);
        },
        (_) {
          _logger.info('Successfully saved active brand ID: $brandId');
          return const Right(null);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in saveActiveBrandId', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, String?>> getActiveBrandId() async {
    try {
      final result = await _localDataSource.getActiveBrandId();

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to get active brand ID: ${failure.message}', failure);
          return Left(failure);
        },
        (activeBrandId) {
          _logger
              .info('Successfully retrieved active brand ID: $activeBrandId');
          return Right(activeBrandId);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in getActiveBrandId', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> clearActiveBrandId() async {
    try {
      final result = await _localDataSource.clearActiveBrandId();

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to clear active brand ID: ${failure.message}', failure);
          return Left(failure);
        },
        (_) {
          _logger.info('Successfully cleared active brand ID');
          return const Right(null);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in clearActiveBrandId', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<BrandInvitation>>> getUserInvitations() async {
    try {
      final result = await _remoteDataSource.getUserInvitations();

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to get user invitations: ${failure.message}', failure);
          return Left(failure);
        },
        (invitations) async {
          // Cache the invitations
          await _localDataSource.cacheBrandInvitations(invitations);
          _logger.info(
              'Successfully retrieved ${invitations.length} user invitations');
          return Right(invitations);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in getUserInvitations', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> cancelInvitation(String invitationId) async {
    try {
      final result = await _remoteDataSource.cancelInvitation(invitationId);

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to cancel invitation: ${failure.message}', failure);
          return Left(failure);
        },
        (_) async {
          _logger.info('Successfully cancelled invitation: $invitationId');
          return const Right(null);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in cancelInvitation', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> resendInvitation(String invitationId) async {
    try {
      final result = await _remoteDataSource.resendInvitation(invitationId);

      return result.fold(
        (failure) {
          _logger.error(
              'Failed to resend invitation: ${failure.message}', failure);
          return Left(failure);
        },
        (_) async {
          _logger.info('Successfully resent invitation: $invitationId');
          return const Right(null);
        },
      );
    } catch (e) {
      _logger.error('Unexpected error in resendInvitation', e);
      return Left(ServerFailure(
        message: 'An unexpected error occurred',
        originalError: e,
      ));
    }
  }
}
