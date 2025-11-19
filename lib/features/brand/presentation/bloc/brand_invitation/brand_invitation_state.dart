import 'package:equatable/equatable.dart';
import '../../../domain/entities/brand_invitation.dart';

/// Abstract base class untuk semua brand invitation states
/// Extends Equatable untuk value comparison
abstract class BrandInvitationState extends Equatable {
  const BrandInvitationState();

  @override
  List<Object> get props => [];
}

/// Initial state ketika brand invitation bloc pertama kali dibuat
class BrandInvitationInitial extends BrandInvitationState {
  const BrandInvitationInitial();

  @override
  List<Object> get props => [];
}

/// Loading state ketika operasi invitation sedang berlangsung
class BrandInvitationLoading extends BrandInvitationState {
  const BrandInvitationLoading();

  @override
  List<Object> get props => [];
}

/// State ketika invitations berhasil dimuat
class BrandInvitationsLoaded extends BrandInvitationState {
  final List<BrandInvitation> invitations;
  final String? brandId;
  final String? status;

  const BrandInvitationsLoaded({
    required this.invitations,
    this.brandId,
    this.status,
  });

  @override
  List<Object> get props => [invitations, brandId ?? '', status ?? ''];
}

/// State ketika invitation berhasil dibuat
class BrandInvitationCreated extends BrandInvitationState {
  final BrandInvitation invitation;
  final String message;

  const BrandInvitationCreated({
    required this.invitation,
    required this.message,
  });

  @override
  List<Object> get props => [invitation, message];
}

/// State ketika invitation berhasil diterima
class BrandInvitationAccepted extends BrandInvitationState {
  final BrandInvitation invitation;
  final String message;

  const BrandInvitationAccepted({
    required this.invitation,
    required this.message,
  });

  @override
  List<Object> get props => [invitation, message];
}

/// State ketika invitation berhasil ditolak
class BrandInvitationRejected extends BrandInvitationState {
  final String invitationId;
  final String message;

  const BrandInvitationRejected({
    required this.invitationId,
    required this.message,
  });

  @override
  List<Object> get props => [invitationId, message];
}

/// State ketika invitation berhasil dibatalkan
class BrandInvitationRevoked extends BrandInvitationState {
  final String invitationId;
  final String message;

  const BrandInvitationRevoked({
    required this.invitationId,
    required this.message,
  });

  @override
  List<Object> get props => [invitationId, message];
}

/// State ketika operasi invitation gagal
class BrandInvitationError extends BrandInvitationState {
  final String message;
  final String? errorCode;
  final String? invitationId;

  const BrandInvitationError({
    required this.message,
    this.errorCode,
    this.invitationId,
  });

  @override
  List<Object> get props => [message, errorCode ?? '', invitationId ?? ''];
}

/// State ketika tidak ada invitations
class BrandInvitationEmpty extends BrandInvitationState {
  final String message;
  final String? brandId;
  final String? status;

  const BrandInvitationEmpty({
    this.message = 'Tidak ada invitation ditemukan',
    this.brandId,
    this.status,
  });

  @override
  List<Object> get props => [message, brandId ?? '', status ?? ''];
}

/// State untuk received invitations
class ReceivedInvitationsLoaded extends BrandInvitationState {
  final List<BrandInvitation> receivedInvitations;

  const ReceivedInvitationsLoaded({required this.receivedInvitations});

  @override
  List<Object> get props => [receivedInvitations];
}

/// State untuk sent invitations
class SentInvitationsLoaded extends BrandInvitationState {
  final List<BrandInvitation> sentInvitations;

  const SentInvitationsLoaded({required this.sentInvitations});

  @override
  List<Object> get props => [sentInvitations];
}

/// State ketika invitation berhasil di-resend
class BrandInvitationResent extends BrandInvitationState {
  final String invitationId;
  final String message;

  const BrandInvitationResent({
    required this.invitationId,
    required this.message,
  });

  @override
  List<Object> get props => [invitationId, message];
}

/// State untuk validasi invitation token
class InvitationTokenValidated extends BrandInvitationState {
  final BrandInvitation invitation;
  final bool isValid;

  const InvitationTokenValidated({
    required this.invitation,
    required this.isValid,
  });

  @override
  List<Object> get props => [invitation, isValid];
}

/// State untuk invitation detail
class InvitationDetailLoaded extends BrandInvitationState {
  final BrandInvitation invitation;

  const InvitationDetailLoaded({required this.invitation});

  @override
  List<Object> get props => [invitation];
}

/// State ketika invitation berhasil diupdate
class BrandInvitationUpdated extends BrandInvitationState {
  final BrandInvitation invitation;
  final String message;

  const BrandInvitationUpdated({
    required this.invitation,
    required this.message,
  });

  @override
  List<Object> get props => [invitation, message];
}

/// State untuk konfirmasi penghapusan invitation
class InvitationDeleteConfirmation extends BrandInvitationState {
  final BrandInvitation invitation;

  const InvitationDeleteConfirmation({required this.invitation});

  @override
  List<Object> get props => [invitation];
}

/// State untuk validasi form invitation
class InvitationValidationError extends BrandInvitationState {
  final Map<String, String> errors;

  const InvitationValidationError({required this.errors});

  @override
  List<Object> get props => [errors];
}