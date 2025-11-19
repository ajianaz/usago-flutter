import 'package:equatable/equatable.dart';

/// Parameter class untuk membuat brand invitation
class CreateInvitationParams extends Equatable {
  final String brandId;
  final String email;
  final String role;
  final List<String> branchIds;
  final DateTime? expiresAt;

  const CreateInvitationParams({
    required this.brandId,
    required this.email,
    required this.role,
    this.branchIds = const [],
    this.expiresAt,
  });

  @override
  List<Object?> get props => [
        brandId,
        email,
        role,
        branchIds,
        expiresAt,
      ];
}

/// Parameter class untuk menerima invitation
class AcceptInvitationParams extends Equatable {
  final String invitationId;
  final String token;

  const AcceptInvitationParams({
    required this.invitationId,
    required this.token,
  });

  @override
  List<Object?> get props => [invitationId, token];
}

/// Parameter class untuk menolak invitation
class RejectInvitationParams extends Equatable {
  final String invitationId;

  const RejectInvitationParams({required this.invitationId});

  @override
  List<Object?> get props => [invitationId];
}

/// Parameter class untuk membatalkan invitation
class RevokeInvitationParams extends Equatable {
  final String invitationId;

  const RevokeInvitationParams({required this.invitationId});

  @override
  List<Object?> get props => [invitationId];
}

/// Parameter class untuk mendapatkan invitations berdasarkan brand
class GetBrandInvitationsParams extends Equatable {
  final String brandId;
  final String? status; // pending, accepted, declined, expired

  const GetBrandInvitationsParams({
    required this.brandId,
    this.status,
  });

  @override
  List<Object?> get props => [brandId, status];
}