import 'package:fpdart/fpdart.dart';
import '../common/usecase.dart';
import '../common/params/invitation_params.dart';
import '../../../../../core/errors/failure.dart';
import '../../entities/brand_invitation.dart';
import '../../repositories/brand_repository.dart';

/// Use case untuk membuat invitation baru
class CreateBrandInvitationUseCase implements UseCase<BrandInvitation, CreateInvitationParams> {
  final BrandRepository _repository;
  final String _currentUserId;

  CreateBrandInvitationUseCase({
    required BrandRepository repository,
    required String currentUserId,
  })  : _repository = repository,
        _currentUserId = currentUserId;

  @override
  Future<Either<Failure, BrandInvitation>> call(CreateInvitationParams params) async {
    try {
      // Log execution
      print('CreateBrandInvitationUseCase: Creating invitation for brand ${params.brandId} to ${params.email} with role ${params.role}');

      // Validasi input
      final validationResult = _validateInvitationData(params);
      if (validationResult != null) {
        return Left(validationResult);
      }

      // Cek permission untuk membuat invitation
      final permissionResult = await _checkCreatePermission(params.brandId);
      if (permissionResult != null) {
        return Left(permissionResult);
      }

      // Cek business rules
      final businessRulesResult = await _checkBusinessRules(params);
      if (businessRulesResult != null) {
        return Left(businessRulesResult);
      }

      // Persiapkan data invitation
      final invitationData = {
        'brandId': params.brandId,
        'email': params.email.trim().toLowerCase(),
        'role': params.role.trim(),
        'branchIds': params.branchIds,
        'expiresAt': params.expiresAt?.toIso8601String(),
        'inviterId': _currentUserId,
      };

      // Delegate ke repository
      final result = await _repository.inviteUser(params.brandId, invitationData);

      // Log result
      result.fold(
        (failure) => print('CreateBrandInvitationUseCase: Failed to create invitation - ${failure.message}'),
        (invitation) => print('CreateBrandInvitationUseCase: Successfully created invitation ${invitation.id} for ${invitation.inviteeEmail}'),
      );

      return result;
    } catch (e) {
      print('CreateBrandInvitationUseCase: Unexpected error - $e');
      return Left(ServerFailure(message: 'Gagal membuat invitation: ${e.toString()}'));
    }
  }

  /// Validasi data invitation
  Failure? _validateInvitationData(CreateInvitationParams params) {
    // Validasi email
    if (params.email.trim().isEmpty) {
      return const ValidationFailure(message: 'Email tidak boleh kosong');
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(params.email.trim())) {
      return const ValidationFailure(message: 'Format email tidak valid');
    }

    // Validasi role
    if (params.role.trim().isEmpty) {
      return const ValidationFailure(message: 'Role tidak boleh kosong');
    }

    final validRoles = [
      'BRAND_OWNER',
      'BRANCH_MANAGER',
      'BRANCH_ADMIN',
      'BRANCH_STAFF',
      'CROSS_BRANCH_VIEWER'
    ];

    if (!validRoles.contains(params.role.trim().toUpperCase())) {
      return const ValidationFailure(message: 'Role tidak valid');
    }

    // Validasi expiration date jika ada
    if (params.expiresAt != null) {
      if (params.expiresAt!.isBefore(DateTime.now())) {
        return const ValidationFailure(message: 'Tanggal kedaluwarsa tidak boleh di masa lalu');
      }

      // Maksimal 30 hari dari sekarang
      final maxExpiration = DateTime.now().add(const Duration(days: 30));
      if (params.expiresAt!.isAfter(maxExpiration)) {
        return const ValidationFailure(message: 'Maksimal tanggal kedaluwarsa adalah 30 hari dari sekarang');
      }
    }

    return null;
  }

  /// Cek permission untuk membuat invitation
  Future<Failure?> _checkCreatePermission(String brandId) async {
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
          // Cek apakah user adalah owner
          if (brand.ownerId != _currentUserId) {
            return const ValidationFailure(message: 'Anda tidak memiliki permission untuk membuat invitation brand ini');
          }
          return null;
        },
      );
    } catch (e) {
      return ServerFailure(message: 'Gagal memeriksa permission: ${e.toString()}');
    }
  }

  /// Cek business rules
  Future<Failure?> _checkBusinessRules(CreateInvitationParams params) async {
    try {
      // Cek apakah email yang diundang adalah owner
      final brandResult = await _repository.getBrandById(params.brandId);

      return brandResult.fold(
        (failure) => ServerFailure(message: 'Gagal memeriksa business rules: ${failure.message}'),
        (brand) async {
          // Brand owner tidak bisa di-invite ke brand yang sama
          if (brand.ownerId == _currentUserId && params.email.trim().toLowerCase() == _currentUserId.toLowerCase()) {
            return const ValidationFailure(message: 'Brand owner tidak bisa di-invite ke brand yang sama');
          }

          // Cek jumlah invitations yang sudah ada (maximum 5)
          final invitationsResult = await _repository.getBrandInvitations(params.brandId);

          return invitationsResult.fold(
            (failure) => ServerFailure(message: 'Gagal memeriksa jumlah invitations: ${failure.message}'),
            (invitations) {
              // Hitung hanya pending invitations
              final pendingInvitations = invitations.where((inv) => inv.isPending).length;

              if (pendingInvitations >= 5) {
                return const ValidationFailure(message: 'Maksimal 5 invitations pending per brand');
              }

              // Cek apakah email sudah diundang sebelumnya
              final existingInvitation = invitations.where((inv) =>
                inv.inviteeEmail.toLowerCase() == params.email.trim().toLowerCase() &&
                inv.isPending
              ).firstOrNull;

              if (existingInvitation != null) {
                return const ValidationFailure(message: 'Email ini sudah diundang dan masih pending');
              }

              return null;
            },
          );
        },
      );
    } catch (e) {
      return ServerFailure(message: 'Gagal memeriksa business rules: ${e.toString()}');
    }
  }
}