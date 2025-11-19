import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/brand_invitation.dart';
import '../models/brand_model.dart';
import '../models/brand_invitation_model.dart';
import 'brand_remote_datasource.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/brand_endpoints.dart';
import '../../../../core/utils/logger.dart';

/// Implementation of BrandRemoteDataSource
/// Handles all remote API calls for brand operations
class BrandRemoteDataSourceImpl implements BrandRemoteDataSource {
  final DioClient _dioClient;
  final AppLogger _logger;

  BrandRemoteDataSourceImpl(DioClient dioClient, AppLogger logger)
      : _dioClient = dioClient,
        _logger = logger;

  @override
  Future<Either<Failure, List<Brand>>> getUserBrands() async {
    try {
      final response = await _dioClient.get(BrandEndpoints.getUserBrands);

      final List<dynamic> dataList = response['data'] ?? [];
      final List<Brand> brands = dataList
          .map((json) => BrandModel.fromJson(json).toEntity())
          .toList();

      _logger.info('Successfully fetched ${brands.length} user brands');
      return Right(brands);
    } on DioException catch (e) {
      _logger.error('Dio error in getUserBrands: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in getUserBrands: $e');
      return Left(ServerFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<Brand>>> getAccessibleBrands() async {
    try {
      final response = await _dioClient.get(BrandEndpoints.getAccessibleBrands);

      final List<dynamic> dataList = response['data'] ?? [];
      final List<Brand> brands = dataList
          .map((json) => BrandModel.fromJson(json).toEntity())
          .toList();

      _logger.info('Successfully fetched ${brands.length} accessible brands');
      return Right(brands);
    } on DioException catch (e) {
      _logger.error('Dio error in getAccessibleBrands: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in getAccessibleBrands: $e');
      return Left(ServerFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Brand>> getBrandById(String id) async {
    try {
      final endpoint = BrandEndpoints.getBrand.replaceAll('{id}', id);
      final response = await _dioClient.get(endpoint);

      final brand = BrandModel.fromJson(response['data']).toEntity();

      _logger.info('Successfully fetched brand by ID: $id');
      return Right(brand);
    } on DioException catch (e) {
      _logger.error('Dio error in getBrandById: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in getBrandById: $e');
      return Left(ServerFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Brand>> getBrandBySlug(String slug) async {
    try {
      final endpoint = BrandEndpoints.getBrandBySlug.replaceAll('{slug}', slug);
      final response = await _dioClient.get(endpoint);

      final brand = BrandModel.fromJson(response['data']).toEntity();

      _logger.info('Successfully fetched brand by slug: $slug');
      return Right(brand);
    } on DioException catch (e) {
      _logger.error('Dio error in getBrandBySlug: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in getBrandBySlug: $e');
      return Left(ServerFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Brand>> createBrand(Map<String, dynamic> brandData) async {
    try {
      // Send data as Map object, let Dio handle JSON serialization
      final response = await _dioClient.post(
        BrandEndpoints.createBrand,
        data: brandData,
      );

      final brand = BrandModel.fromJson(response['data']).toEntity();

      _logger.info('Successfully created brand: ${brand.name}');
      return Right(brand);
    } on DioException catch (e) {
      _logger.error('Dio error in createBrand: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in createBrand: $e');
      return Left(ServerFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Brand>> updateBrand(String id, Map<String, dynamic> brandData) async {
    try {
      // Send data as Map object, let Dio handle JSON serialization
      final endpoint = BrandEndpoints.updateBrand.replaceAll('{id}', id);
      final response = await _dioClient.put(
        endpoint,
        data: brandData,
      );

      final brand = BrandModel.fromJson(response['data']).toEntity();

      _logger.info('Successfully updated brand: $id');
      return Right(brand);
    } on DioException catch (e) {
      _logger.error('Dio error in updateBrand: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in updateBrand: $e');
      return Left(ServerFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBrand(String id) async {
    try {
      final endpoint = BrandEndpoints.deleteBrand.replaceAll('{id}', id);
      await _dioClient.delete(endpoint);

      _logger.info('Successfully deleted brand: $id');
      return const Right(null);
    } on DioException catch (e) {
      _logger.error('Dio error in deleteBrand: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in deleteBrand: $e');
      return Left(ServerFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Brand>> switchActiveBrand(String brandId) async {
    try {
      // Send data as Map object, let Dio handle JSON serialization
      final response = await _dioClient.post(
        BrandEndpoints.switchActiveBrand,
        data: {'brandId': brandId},
      );

      final brand = BrandModel.fromJson(response['data']).toEntity();

      _logger.info('Successfully switched to active brand: $brandId');
      return Right(brand);
    } on DioException catch (e) {
      _logger.error('Dio error in switchActiveBrand: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in switchActiveBrand: $e');
      return Left(ServerFailure(
        message: e.toString(),
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
      // Send data as Map object, let Dio handle JSON serialization
      final endpoint = BrandEndpoints.transferOwnership.replaceAll('{id}', brandId);
      await _dioClient.post(
        endpoint,
        data: {
          'newOwnerId': newOwnerId,
          'confirmationCode': confirmationCode,
        },
      );

      _logger.info('Successfully transferred ownership for brand: $brandId');
      return const Right(null);
    } on DioException catch (e) {
      _logger.error('Dio error in transferOwnership: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in transferOwnership: $e');
      return Left(ServerFailure(
        message: e.toString(),
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
      // Send data as Map object, let Dio handle JSON serialization
      final endpoint = BrandEndpoints.inviteUser.replaceAll('{id}', brandId);
      final response = await _dioClient.post(
        endpoint,
        data: invitationData,
      );

      final invitation = BrandInvitationModel.fromJson(response['data']).toEntity();

      _logger.info('Successfully invited user to brand: $brandId');
      return Right(invitation);
    } on DioException catch (e) {
      _logger.error('Dio error in inviteUser: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in inviteUser: $e');
      return Left(ServerFailure(
        message: e.toString(),
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
      // Send data as Map object, let Dio handle JSON serialization
      await _dioClient.post(
        BrandEndpoints.acceptInvitation,
        data: {
          'invitationId': invitationId,
          'token': token,
        },
      );

      _logger.info('Successfully accepted invitation: $invitationId');
      return const Right(null);
    } on DioException catch (e) {
      _logger.error('Dio error in acceptInvitation: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in acceptInvitation: $e');
      return Left(ServerFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> declineInvitation(String invitationId) async {
    try {
      final endpoint = BrandEndpoints.declineInvitation.replaceAll('{invitationId}', invitationId);
      await _dioClient.post(endpoint);

      _logger.info('Successfully declined invitation: $invitationId');
      return const Right(null);
    } on DioException catch (e) {
      _logger.error('Dio error in declineInvitation: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in declineInvitation: $e');
      return Left(ServerFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<BrandInvitation>>> getBrandInvitations(String brandId) async {
    try {
      final endpoint = BrandEndpoints.getBrandInvitations.replaceAll('{id}', brandId);
      final response = await _dioClient.get(endpoint);

      final List<dynamic> dataList = response['data'] ?? [];
      final List<BrandInvitation> invitations = dataList
          .map((json) => BrandInvitationModel.fromJson(json).toEntity())
          .toList();

      _logger.info('Successfully fetched ${invitations.length} invitations for brand: $brandId');
      return Right(invitations);
    } on DioException catch (e) {
      _logger.error('Dio error in getBrandInvitations: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in getBrandInvitations: $e');
      return Left(ServerFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getBrandStats(String brandId) async {
    try {
      final endpoint = BrandEndpoints.getBrandStats.replaceAll('{id}', brandId);
      final response = await _dioClient.get(endpoint);

      final stats = Map<String, dynamic>.from(response['data'] ?? {});

      _logger.info('Successfully fetched stats for brand: $brandId');
      return Right(stats);
    } on DioException catch (e) {
      _logger.error('Dio error in getBrandStats: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in getBrandStats: $e');
      return Left(ServerFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, List<BrandInvitation>>> getUserInvitations() async {
    try {
      final response = await _dioClient.get(BrandEndpoints.getUserInvitations);

      final List<dynamic> dataList = response['data'] ?? [];
      final List<BrandInvitation> invitations = dataList
          .map((json) => BrandInvitationModel.fromJson(json).toEntity())
          .toList();

      _logger.info('Successfully fetched ${invitations.length} user invitations');
      return Right(invitations);
    } on DioException catch (e) {
      _logger.error('Dio error in getUserInvitations: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in getUserInvitations: $e');
      return Left(ServerFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> cancelInvitation(String invitationId) async {
    try {
      final endpoint = BrandEndpoints.cancelInvitation.replaceAll('{invitationId}', invitationId);
      await _dioClient.delete(endpoint);

      _logger.info('Successfully cancelled invitation: $invitationId');
      return const Right(null);
    } on DioException catch (e) {
      _logger.error('Dio error in cancelInvitation: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in cancelInvitation: $e');
      return Left(ServerFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> resendInvitation(String invitationId) async {
    try {
      final endpoint = BrandEndpoints.resendInvitation.replaceAll('{invitationId}', invitationId);
      await _dioClient.post(endpoint);

      _logger.info('Successfully resent invitation: $invitationId');
      return const Right(null);
    } on DioException catch (e) {
      _logger.error('Dio error in resendInvitation: $e');
      return Left(ServerFailure(
        message: e.message ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        originalError: e,
      ));
    } catch (e) {
      _logger.error('Unexpected error in resendInvitation: $e');
      return Left(ServerFailure(
        message: e.toString(),
        originalError: e,
      ));
    }
  }
}