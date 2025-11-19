import 'package:fpdart/fpdart.dart';
import '../common/usecase.dart';
import '../common/params/invitation_params.dart';
import '../../../../../core/errors/failure.dart';
import '../../entities/brand_invitation.dart';
import '../../repositories/brand_repository.dart';

/// Use case untuk mendapatkan daftar invitations
class GetBrandInvitationsUseCase implements UseCase<List<BrandInvitation>, GetBrandInvitationsParams> {
  final BrandRepository _repository;
  final String _currentUserId;

  GetBrandInvitationsUseCase({
    required BrandRepository repository,
    required String currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId;

  @override
  Future<Either<Failure, List<BrandInvitation>>> call(GetBrandInvitationsParams params) async {
    try {
      // Log execution
      print('GetBrandInvitationsUseCase: Getting invitations for brand ${params.brandId} with status ${params.status ?? 'all'} for user $_currentUserId');

      // Cek apakah user memiliki permission untuk melihat invitations brand ini
      final permissionResult = await _checkViewPermission(params.brandId);
      if (permissionResult != null) {
        return Left(permissionResult);
      }

      // Delegate ke repository
      final result = await _repository.getBrandInvitations(params.brandId);

      // Filter berdasarkan status jika specified
      return result.fold(
        (failure) {
          print('GetBrandInvitationsUseCase: Failed to get brand invitations - ${failure.message}');
          return Left(failure);
        },
        (invitations) {
          // Filter berdasarkan status jika specified
          var filteredInvitations = invitations;

          if (params.status != null && params.status!.trim().isNotEmpty) {
            final status = params.status!.trim().toLowerCase();
            filteredInvitations = invitations.where((invitation) {
              return invitation.status.toLowerCase() == status;
            }).toList();
          }

          // Sort berdasarkan created date (newest first)
          filteredInvitations.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          print('GetBrandInvitationsUseCase: Successfully retrieved ${filteredInvitations.length} invitations');
          return Right(filteredInvitations);
        },
      );
    } catch (e) {
      print('GetBrandInvitationsUseCase: Unexpected error - $e');
      return Left(ServerFailure(message: 'Gagal mengambil data invitation: ${e.toString()}'));
    }
  }

  /// Cek permission untuk melihat invitations brand
  Future<Failure?> _checkViewPermission(String brandId) async {
    try {
      // Ambil data brand untuk cek ownership
      final brandResult = await _repository.getBrandById(brandId);

      return brandResult.fold(
        (failure) {
          if (failure is ServerFailure && failure.statusCode == 404) {
            return const ValidationFailure(message: 'Brand tidak ditemukan');
          }
          return ServerFailure(message: 'Gagal memeriksa permission: ${failure.message}');
        },
        (brand) {
          // Cek apakah user adalah owner atau memiliki akses
          if (brand.ownerId != _currentUserId) {
            // Untuk sekarang, hanya owner yang bisa melihat invitations
            // TODO: Implementasi logika permission yang lebih kompleks jika needed
            return const ValidationFailure(message: 'Anda tidak memiliki permission untuk melihat invitations brand ini');
          }
          return null;
        },
      );
    } catch (e) {
      return ServerFailure(message: 'Gagal memeriksa permission: ${e.toString()}');
    }
  }
}