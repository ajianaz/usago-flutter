import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/brand_invitation.dart';
import '../models/brand_model.dart';
import '../models/brand_invitation_model.dart';
import 'brand_local_datasource.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/utils/logger.dart';

/// Implementation of BrandLocalDataSource
/// Handles all local storage operations for brand data
class BrandLocalDataSourceImpl implements BrandLocalDataSource {
  final AppLogger _logger;

  BrandLocalDataSourceImpl(AppLogger logger)
      : _logger = logger;

  @override
  Future<Either<Failure, void>> cacheBrands(List<Brand> brands) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert brands to JSON for storage
      final List<Map<String, dynamic>> brandsJson = brands
          .map((brand) => BrandModel.fromEntity(brand).toJson())
          .toList();

      await prefs.setStringList(
        StorageConstants.cachedBrandsKey,
        brandsJson.map((json) => jsonEncode(json)).toList(),
      );

      _logger.info('Successfully cached ${brands.length} brands locally');
      return const Right(null);
    } catch (e) {
      _logger.error('Error caching brands: $e', e);
      return Left(CacheFailure(
        message: 'Failed to cache brands',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<Brand>>> getCachedBrands() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final brandsJsonStrings = prefs.getStringList(StorageConstants.cachedBrandsKey) ?? [];

      final List<Brand> brands = brandsJsonStrings
          .map((jsonString) {
            try {
              final json = jsonDecode(jsonString) as Map<String, dynamic>;
              return BrandModel.fromJson(json).toEntity();
            } catch (e) {
              _logger.error('Error parsing cached brand: $e', e);
              return null;
            }
          })
          .where((brand) => brand != null)
          .cast<Brand>()
          .toList();

      _logger.info('Successfully retrieved ${brands.length} cached brands');
      return Right(brands);
    } catch (e) {
      _logger.error('Error getting cached brands: $e', e);
      return Left(CacheFailure(
        message: 'Failed to get cached brands',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> clearBrandCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(StorageConstants.cachedBrandsKey);

      _logger.info('Successfully cleared brand cache');
      return const Right(null);
    } catch (e) {
      _logger.error('Error clearing brand cache: $e', e);
      return Left(CacheFailure(
        message: 'Failed to clear brand cache',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> saveActiveBrandId(String brandId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(StorageConstants.activeBrandKey, brandId);

      _logger.info('Successfully saved active brand ID: $brandId');
      return const Right(null);
    } catch (e) {
      _logger.error('Error saving active brand ID: $e', e);
      return Left(CacheFailure(
        message: 'Failed to save active brand ID',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, String?>> getActiveBrandId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final brandId = prefs.getString(StorageConstants.activeBrandKey);

      _logger.info('Successfully retrieved active brand ID: $brandId');
      return Right(brandId);
    } catch (e) {
      _logger.error('Error getting active brand ID: $e', e);
      return Left(CacheFailure(
        message: 'Failed to get active brand ID',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> clearActiveBrandId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(StorageConstants.activeBrandKey);

      _logger.info('Successfully cleared active brand ID');
      return const Right(null);
    } catch (e) {
      _logger.error('Error clearing active brand ID: $e', e);
      return Left(CacheFailure(
        message: 'Failed to clear active brand ID',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> cacheBrand(Brand brand) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing cached brands
      final existingBrandsJson = prefs.getStringList(StorageConstants.cachedBrandsKey) ?? [];
      final existingBrands = existingBrandsJson
          .map((jsonString) {
            try {
              return jsonDecode(jsonString) as Map<String, dynamic>;
            } catch (e) {
              _logger.error('Error parsing existing brand: $e', e);
              return null;
            }
          })
          .where((json) => json != null)
          .cast<Map<String, dynamic>>()
          .map((json) => BrandModel.fromJson(json).toEntity())
          .toList();

      // Update or add the brand
      final updatedBrands = <Brand>[];
      bool brandUpdated = false;

      for (int i = 0; i < existingBrands.length; i++) {
        if (existingBrands[i].id == brand.id) {
          updatedBrands.add(brand);
          brandUpdated = true;
        } else {
          updatedBrands.add(existingBrands[i]);
        }
      }

      if (!brandUpdated) {
        updatedBrands.add(brand);
      }

      // Save updated list
      await cacheBrands(updatedBrands);

      _logger.info('Successfully cached brand: ${brand.name}');
      return const Right(null);
    } catch (e) {
      _logger.error('Error caching brand: $e', e);
      return Left(CacheFailure(
        message: 'Failed to cache brand',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Brand?>> getCachedBrand(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final brandsJsonStrings = prefs.getStringList(StorageConstants.cachedBrandsKey) ?? [];

      for (final jsonString in brandsJsonStrings) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          final brand = BrandModel.fromJson(json).toEntity();

          if (brand.id == id) {
            _logger.info('Successfully retrieved cached brand: $id');
            return Right(brand);
          }
        } catch (e) {
          _logger.error('Error parsing cached brand: $e', e);
        }
      }

      _logger.warning('Brand not found in cache: $id');
      return const Right(null);
    } catch (e) {
      _logger.error('Error getting cached brand: $e', e);
      return Left(CacheFailure(
        message: 'Failed to get cached brand',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> cacheBrandInvitations(List<BrandInvitation> invitations) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert invitations to JSON for storage
      final List<Map<String, dynamic>> invitationsJson = invitations
          .map((invitation) => BrandInvitationModel.fromEntity(invitation).toJson())
          .toList();

      await prefs.setStringList(
        StorageConstants.cachedBrandInvitationsKey,
        invitationsJson.map((json) => jsonEncode(json)).toList(),
      );

      _logger.info('Successfully cached ${invitations.length} brand invitations locally');
      return const Right(null);
    } catch (e) {
      _logger.error('Error caching brand invitations: $e', e);
      return Left(CacheFailure(
        message: 'Failed to cache brand invitations',
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<BrandInvitation>>> getCachedBrandInvitations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final invitationsJsonStrings = prefs.getStringList(StorageConstants.cachedBrandInvitationsKey) ?? [];

      final List<BrandInvitation> invitations = invitationsJsonStrings
          .map((jsonString) {
            try {
              final json = jsonDecode(jsonString) as Map<String, dynamic>;
              return BrandInvitationModel.fromJson(json).toEntity();
            } catch (e) {
              _logger.error('Error parsing cached invitation: $e', e);
              return null;
            }
          })
          .where((invitation) => invitation != null)
          .cast<BrandInvitation>()
          .toList();

      _logger.info('Successfully retrieved ${invitations.length} cached brand invitations');
      return Right(invitations);
    } catch (e) {
      _logger.error('Error getting cached brand invitations: $e', e);
      return Left(CacheFailure(
        message: 'Failed to get cached brand invitations',
        originalError: e,
      ));
    }
  }
}