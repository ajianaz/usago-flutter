import 'package:fpdart/fpdart.dart';
import '../common/usecase.dart';
import '../common/params/invitation_params.dart';
import '../../../../../core/errors/failure.dart';
import '../../entities/brand_invitation.dart';
import '../../repositories/brand_repository.dart';

/// Use case untuk membatalkan invitation
class RevokeBrandInvitationUseCase implements UseCase<void, RevokeInvitationParams> {
  final BrandRepository _repository;
  final String _currentUserId;

  RevokeBrandInvitationUseCase({
    required BrandRepository repository,
    required String currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId;

  @override
  Future<Either<Failure, void>> call(RevokeInvitationParams params) async {
    try {
      // Log execution
      print('RevokeBrandInvitationUseCase: Revoking invitation ${params.invitationId} for user $_currentUserId');

      // Cek apakah invitation ada dan user memiliki permission
      final invitationResult = await _getInvitationAndCheckPermission(params.invitationId);
      if (invitationResult != null) {
        return Left(invitationResult);
      }

      // Delegate ke repository
      final result = await _repository.cancelInvitation(params.invitationId);

      // Log result
      result.fold(
        (failure) => print('RevokeBrandInvitationUseCase: Failed to revoke invitation - ${failure.message}'),
        (_) => print('RevokeBrandInvitationUseCase: Successfully revoked invitation ${params.invitationId}'),
      );

      return result;
    } catch (e) {
      print('RevokeBrandInvitationUseCase: Unexpected error - $e');
      return Left(ServerFailure(message: 'Gagal membatalkan invitation: ${e.toString()}'));
    }
  }

  /// Cek apakah invitation ada dan user memiliki permission untuk revoke
  Future<Failure?> _getInvitationAndCheckPermission(String invitationId) async {
    try {
      // Ambil user invitations untuk mencari invitation yang dimaksud
      final userInvitationsResult = await _repository.getUserInvitations();

      return userInvitationsResult.fold(
        (failure) {
          if (failure is ServerFailure && failure.statusCode == 404) {
            return const ValidationFailure(message: 'Invitation tidak ditemukan');
          }
          return ServerFailure(message: 'Gagal memeriksa invitation: ${failure.message}');
        },
        (invitations) {
          // Cari invitation yang sesuai
          final invitation = invitations.where((inv) => inv.id == invitationId).firstOrNull;

          if (invitation == null) {
            return const ValidationFailure(message: 'Invitation tidak ditemukan');
          }

          // Cek status invitation
          if (!invitation.isPending) {
            if (invitation.isAccepted) {
              return const ValidationFailure(message: 'Invitation sudah diterima, tidak dapat dibatalkan');
            } else if (invitation.isDeclined) {
              return const ValidationFailure(message: 'Invitation sudah ditolak');
            } else if (invitation.isExpired) {
              return const ValidationFailure(message: 'Invitation sudah kadaluarsa');
            }
          }

          // Cek permission - hanya inviter atau brand owner yang bisa revoke
          return _checkRevokePermission(invitation);
        },
      );
    } catch (e) {
      return ServerFailure(message: 'Gagal memeriksa invitation: ${e.toString()}');
    }
  }

  /// Cek permission untuk revoke invitation
  Future<Failure?> _checkRevokePermission(BrandInvitation invitation) async {
    try {
      // Jika user adalah inviter, izinkan
      if (invitation.inviterId == _currentUserId) {
        return null;
      }

      // Jika bukan inviter, cek apakah user adalah brand owner
      final brandResult = await _repository.getBrandById(invitation.brandId);

      return brandResult.fold(
        (failure) => ServerFailure(message: 'Gagal memeriksa permission brand: ${failure.message}'),
        (brand) {
          if (brand.ownerId == _currentUserId) {
            return null;
          }

          return const ValidationFailure(message: 'Anda tidak memiliki permission untuk membatalkan invitation ini');
        },
      );
    } catch (e) {
      return ServerFailure(message: 'Gagal memeriksa permission: ${e.toString()}');
    }
  }
}