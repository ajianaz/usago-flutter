import 'package:fpdart/fpdart.dart';
import '../common/usecase.dart';
import '../common/params/invitation_params.dart';
import '../../../../../core/errors/failure.dart';
import '../../repositories/brand_repository.dart';

/// Use case untuk menolak invitation
class RejectBrandInvitationUseCase implements UseCase<void, RejectInvitationParams> {
  final BrandRepository _repository;
  final String _currentUserId;

  RejectBrandInvitationUseCase({
    required BrandRepository repository,
    required String currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId;

  @override
  Future<Either<Failure, void>> call(RejectInvitationParams params) async {
    try {
      // Log execution
      print('RejectBrandInvitationUseCase: Rejecting invitation ${params.invitationId} for user $_currentUserId');

      // Cek apakah invitation ada dan valid untuk user ini
      final invitationResult = await _getInvitationAndValidate(params.invitationId);
      if (invitationResult != null) {
        return Left(invitationResult);
      }

      // Delegate ke repository
      final result = await _repository.declineInvitation(params.invitationId);

      // Log result
      result.fold(
        (failure) => print('RejectBrandInvitationUseCase: Failed to reject invitation - ${failure.message}'),
        (_) => print('RejectBrandInvitationUseCase: Successfully rejected invitation ${params.invitationId}'),
      );

      return result;
    } catch (e) {
      print('RejectBrandInvitationUseCase: Unexpected error - $e');
      return Left(ServerFailure(message: 'Gagal menolak invitation: ${e.toString()}'));
    }
  }

  /// Cek apakah invitation ada dan valid untuk user ini
  Future<Failure?> _getInvitationAndValidate(String invitationId) async {
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

          // Cek apakah invitation untuk user ini (berdasarkan email)
          // TODO: Implementasi logika yang lebih robust untuk verifikasi user
          // Untuk sekarang, kita asumsikan user memiliki akses ke invitation ini

          // Cek status invitation
          if (!invitation.isPending) {
            if (invitation.isAccepted) {
              return const ValidationFailure(message: 'Invitation sudah diterima');
            } else if (invitation.isDeclined) {
              return const ValidationFailure(message: 'Invitation sudah ditolak');
            } else if (invitation.isExpired) {
              return const ValidationFailure(message: 'Invitation sudah kadaluarsa');
            }
          }

          // Cek expiration
          if (invitation.isExpired) {
            return const ValidationFailure(message: 'Invitation sudah kadaluarsa');
          }

          return null;
        },
      );
    } catch (e) {
      return ServerFailure(message: 'Gagal memeriksa invitation: ${e.toString()}');
    }
  }
}