import 'package:equatable/equatable.dart';

/// Abstract base class untuk semua brand invitation events
/// Extends Equatable untuk value comparison
abstract class BrandInvitationEvent extends Equatable {
  const BrandInvitationEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk load invitations
class LoadInvitationsEvent extends BrandInvitationEvent {
  final String brandId;
  final String? status; // pending, accepted, declined, expired

  const LoadInvitationsEvent({
    required this.brandId,
    this.status,
  });

  @override
  List<Object> get props => [brandId, status ?? ''];
}

/// Event untuk create invitation
class CreateInvitationEvent extends BrandInvitationEvent {
  final String brandId;
  final String email;
  final String role;
  final List<String> branchIds;
  final DateTime? expiresAt;

  const CreateInvitationEvent({
    required this.brandId,
    required this.email,
    required this.role,
    this.branchIds = const [],
    this.expiresAt,
  });

  @override
  List<Object> get props => [
        brandId,
        email,
        role,
        branchIds,
        expiresAt ?? DateTime.now(),
      ];
}

/// Event untuk accept invitation
class AcceptInvitationEvent extends BrandInvitationEvent {
  final String invitationId;
  final String token;

  const AcceptInvitationEvent({
    required this.invitationId,
    required this.token,
  });

  @override
  List<Object> get props => [invitationId, token];
}

/// Event untuk reject invitation
class RejectInvitationEvent extends BrandInvitationEvent {
  final String invitationId;

  const RejectInvitationEvent({required this.invitationId});

  @override
  List<Object> get props => [invitationId];
}

/// Event untuk revoke invitation
class RevokeInvitationEvent extends BrandInvitationEvent {
  final String invitationId;

  const RevokeInvitationEvent({required this.invitationId});

  @override
  List<Object> get props => [invitationId];
}

/// Event untuk refresh invitations
class RefreshInvitationsEvent extends BrandInvitationEvent {
  final String brandId;
  final String? status;

  const RefreshInvitationsEvent({
    required this.brandId,
    this.status,
  });

  @override
  List<Object> get props => [brandId, status ?? ''];
}

/// Event untuk reset invitation state
class ResetInvitationStateEvent extends BrandInvitationEvent {
  const ResetInvitationStateEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk get received invitations
class GetReceivedInvitationsEvent extends BrandInvitationEvent {
  const GetReceivedInvitationsEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk get sent invitations
class GetSentInvitationsEvent extends BrandInvitationEvent {
  const GetSentInvitationsEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk resend invitation
class ResendInvitationEvent extends BrandInvitationEvent {
  final String invitationId;

  const ResendInvitationEvent({required this.invitationId});

  @override
  List<Object> get props => [invitationId];
}

/// Event untuk validate invitation token
class ValidateInvitationTokenEvent extends BrandInvitationEvent {
  final String token;

  const ValidateInvitationTokenEvent({required this.token});

  @override
  List<Object> get props => [token];
}

/// Event untuk get invitation by ID
class GetInvitationByIdEvent extends BrandInvitationEvent {
  final String invitationId;

  const GetInvitationByIdEvent({required this.invitationId});

  @override
  List<Object> get props => [invitationId];
}

/// Event untuk update invitation
class UpdateInvitationEvent extends BrandInvitationEvent {
  final String invitationId;
  final String? role;
  final List<String>? branchIds;
  final DateTime? expiresAt;

  const UpdateInvitationEvent({
    required this.invitationId,
    this.role,
    this.branchIds,
    this.expiresAt,
  });

  @override
  List<Object> get props => [
        invitationId,
        role ?? '',
        branchIds ?? [],
        expiresAt ?? DateTime.now(),
      ];
}