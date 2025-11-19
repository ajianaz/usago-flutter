import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failure.dart';
import '../../../domain/entities/brand_invitation.dart';
import '../../../domain/usecases/invitation/get_brand_invitations_usecase.dart';
import '../../../domain/usecases/invitation/create_brand_invitation_usecase.dart';
import '../../../domain/usecases/invitation/accept_brand_invitation_usecase.dart';
import '../../../domain/usecases/invitation/reject_brand_invitation_usecase.dart';
import '../../../domain/usecases/invitation/revoke_brand_invitation_usecase.dart';
import '../../../domain/usecases/common/params/invitation_params.dart';
import 'brand_invitation_event.dart';
import 'brand_invitation_state.dart';

/// Brand Invitation BLoC
/// Bertanggung jawab untuk operasi CRUD pada brand invitation
/// Menggunakan use cases untuk business logic
class BrandInvitationBloc extends Bloc<BrandInvitationEvent, BrandInvitationState> {
  final GetBrandInvitationsUseCase _getBrandInvitationsUseCase;
  final CreateBrandInvitationUseCase _createBrandInvitationUseCase;
  final AcceptBrandInvitationUseCase _acceptBrandInvitationUseCase;
  final RejectBrandInvitationUseCase _rejectBrandInvitationUseCase;
  final RevokeBrandInvitationUseCase _revokeBrandInvitationUseCase;

  // Cache untuk menyimpan invitations
  List<BrandInvitation> _cachedInvitations = [];

  BrandInvitationBloc({
    required GetBrandInvitationsUseCase getBrandInvitationsUseCase,
    required CreateBrandInvitationUseCase createBrandInvitationUseCase,
    required AcceptBrandInvitationUseCase acceptBrandInvitationUseCase,
    required RejectBrandInvitationUseCase rejectBrandInvitationUseCase,
    required RevokeBrandInvitationUseCase revokeBrandInvitationUseCase,
  })  : _getBrandInvitationsUseCase = getBrandInvitationsUseCase,
        _createBrandInvitationUseCase = createBrandInvitationUseCase,
        _acceptBrandInvitationUseCase = acceptBrandInvitationUseCase,
        _rejectBrandInvitationUseCase = rejectBrandInvitationUseCase,
        _revokeBrandInvitationUseCase = revokeBrandInvitationUseCase,
        super(const BrandInvitationInitial()) {
    // Register event handlers
    on<LoadInvitationsEvent>(_onLoadInvitations);
    on<CreateInvitationEvent>(_onCreateInvitation);
    on<AcceptInvitationEvent>(_onAcceptInvitation);
    on<RejectInvitationEvent>(_onRejectInvitation);
    on<RevokeInvitationEvent>(_onRevokeInvitation);
    on<RefreshInvitationsEvent>(_onRefreshInvitations);
    on<ResetInvitationStateEvent>(_onResetInvitationState);
    on<GetReceivedInvitationsEvent>(_onGetReceivedInvitations);
    on<GetSentInvitationsEvent>(_onGetSentInvitations);
    on<ResendInvitationEvent>(_onResendInvitation);
    on<ValidateInvitationTokenEvent>(_onValidateInvitationToken);
    on<GetInvitationByIdEvent>(_onGetInvitationById);
    on<UpdateInvitationEvent>(_onUpdateInvitation);
  }

  /// Handler untuk load invitations
  Future<void> _onLoadInvitations(
    LoadInvitationsEvent event,
    Emitter<BrandInvitationState> emit,
  ) async {
    emit(const BrandInvitationLoading());

    // Buat parameter untuk use case
    final params = GetBrandInvitationsParams(
      brandId: event.brandId,
      status: event.status,
    );

    // Panggil use case
    final result = await _getBrandInvitationsUseCase(params);

    // Handle result
    result.fold(
      (failure) => emit(BrandInvitationError(
        message: _mapFailureToMessage(failure),
        errorCode: _mapFailureToErrorCode(failure),
      )),
      (invitations) {
        _cachedInvitations = invitations;

        if (invitations.isEmpty) {
          emit(BrandInvitationEmpty(
            message: 'Tidak ada invitation ${event.status ?? ''} untuk brand ini',
            brandId: event.brandId,
            status: event.status,
          ));
        } else {
          emit(BrandInvitationsLoaded(
            invitations: invitations,
            brandId: event.brandId,
            status: event.status,
          ));
        }
      },
    );
  }

  /// Handler untuk create invitation
  Future<void> _onCreateInvitation(
    CreateInvitationEvent event,
    Emitter<BrandInvitationState> emit,
  ) async {
    // Validasi input
    final validationErrors = _validateCreateInvitationData(event);
    if (validationErrors.isNotEmpty) {
      emit(InvitationValidationError(errors: validationErrors));
      return;
    }

    emit(const BrandInvitationLoading());

    // Buat parameter untuk use case
    final params = CreateInvitationParams(
      brandId: event.brandId,
      email: event.email,
      role: event.role,
      branchIds: event.branchIds,
      expiresAt: event.expiresAt,
    );

    // Panggil use case
    final result = await _createBrandInvitationUseCase(params);

    // Handle result
    result.fold(
      (failure) => emit(BrandInvitationError(
        message: _mapFailureToMessage(failure),
        errorCode: _mapFailureToErrorCode(failure),
      )),
      (invitation) {
        _cachedInvitations.add(invitation);
        emit(BrandInvitationCreated(
          invitation: invitation,
          message: 'Invitation berhasil dikirim ke ${invitation.inviteeEmail}',
        ));
      },
    );
  }

  /// Handler untuk accept invitation
  Future<void> _onAcceptInvitation(
    AcceptInvitationEvent event,
    Emitter<BrandInvitationState> emit,
  ) async {
    emit(const BrandInvitationLoading());

    // Buat parameter untuk use case
    final params = AcceptInvitationParams(
      invitationId: event.invitationId,
      token: event.token,
    );

    // Panggil use case
    final result = await _acceptBrandInvitationUseCase(params);

    // Handle result
    result.fold(
      (failure) => emit(BrandInvitationError(
        message: _mapFailureToMessage(failure),
        errorCode: _mapFailureToErrorCode(failure),
        invitationId: event.invitationId,
      )),
      (_) {
        // Remove dari cache
        _cachedInvitations.removeWhere((inv) => inv.id == event.invitationId);

        // Find the invitation from cache before removal
        final removedInvitation = _cachedInvitations.where((inv) => inv.id == event.invitationId).firstOrNull;

        if (removedInvitation != null) {
          emit(BrandInvitationAccepted(
            invitation: removedInvitation,
            message: 'Invitation dari ${removedInvitation.brandName} berhasil diterima',
          ));
        } else {
          emit(BrandInvitationAccepted(
            invitation: BrandInvitation(
              id: event.invitationId,
              brandId: 'unknown',
              brandName: 'Unknown Brand',
              inviterId: 'unknown',
              inviterName: 'Unknown',
              inviteeEmail: 'unknown@example.com',
              role: 'UNKNOWN',
              status: 'ACCEPTED',
              createdAt: DateTime.now(),
            ),
            message: 'Invitation berhasil diterima',
          ));
        }
      },
    );
  }

  /// Handler untuk reject invitation
  Future<void> _onRejectInvitation(
    RejectInvitationEvent event,
    Emitter<BrandInvitationState> emit,
  ) async {
    emit(const BrandInvitationLoading());

    // Buat parameter untuk use case
    final params = RejectInvitationParams(invitationId: event.invitationId);

    // Panggil use case
    final result = await _rejectBrandInvitationUseCase(params);

    // Handle result
    result.fold(
      (failure) => emit(BrandInvitationError(
        message: _mapFailureToMessage(failure),
        errorCode: _mapFailureToErrorCode(failure),
        invitationId: event.invitationId,
      )),
      (_) {
        // Remove dari cache
        _cachedInvitations.removeWhere((inv) => inv.id == event.invitationId);

        emit(BrandInvitationRejected(
          invitationId: event.invitationId,
          message: 'Invitation berhasil ditolak',
        ));
      },
    );
  }

  /// Handler untuk revoke invitation
  Future<void> _onRevokeInvitation(
    RevokeInvitationEvent event,
    Emitter<BrandInvitationState> emit,
  ) async {
    emit(const BrandInvitationLoading());

    // Buat parameter untuk use case
    final params = RevokeInvitationParams(invitationId: event.invitationId);

    // Panggil use case
    final result = await _revokeBrandInvitationUseCase(params);

    // Handle result
    result.fold(
      (failure) => emit(BrandInvitationError(
        message: _mapFailureToMessage(failure),
        errorCode: _mapFailureToErrorCode(failure),
        invitationId: event.invitationId,
      )),
      (_) {
        // Remove dari cache
        _cachedInvitations.removeWhere((inv) => inv.id == event.invitationId);

        emit(BrandInvitationRevoked(
          invitationId: event.invitationId,
          message: 'Invitation berhasil dibatalkan',
        ));
      },
    );
  }

  /// Handler untuk refresh invitations
  Future<void> _onRefreshInvitations(
    RefreshInvitationsEvent event,
    Emitter<BrandInvitationState> emit,
  ) async {
    // Clear cache
    _cachedInvitations = [];

    // Load ulang
    add(LoadInvitationsEvent(
      brandId: event.brandId,
      status: event.status,
    ));
  }

  /// Handler untuk reset state
  Future<void> _onResetInvitationState(
    ResetInvitationStateEvent event,
    Emitter<BrandInvitationState> emit,
  ) async {
    _cachedInvitations = [];
    emit(const BrandInvitationInitial());
  }

  /// Handler untuk get received invitations
  Future<void> _onGetReceivedInvitations(
    GetReceivedInvitationsEvent event,
    Emitter<BrandInvitationState> emit,
  ) async {
    // TODO: Implement get received invitations
    // Untuk sekarang, kita akan filter dari cache
    final receivedInvitations = _cachedInvitations.where((inv) => inv.isPending).toList();

    if (receivedInvitations.isEmpty) {
      emit(const ReceivedInvitationsLoaded(receivedInvitations: []));
    } else {
      emit(ReceivedInvitationsLoaded(receivedInvitations: receivedInvitations));
    }
  }

  /// Handler untuk get sent invitations
  Future<void> _onGetSentInvitations(
    GetSentInvitationsEvent event,
    Emitter<BrandInvitationState> emit,
  ) async {
    // TODO: Implement get sent invitations
    // Untuk sekarang, kita akan filter dari cache
    final sentInvitations = _cachedInvitations.where((inv) => inv.isPending).toList();

    if (sentInvitations.isEmpty) {
      emit(const SentInvitationsLoaded(sentInvitations: []));
    } else {
      emit(SentInvitationsLoaded(sentInvitations: sentInvitations));
    }
  }

  /// Handler untuk resend invitation
  Future<void> _onResendInvitation(
    ResendInvitationEvent event,
    Emitter<BrandInvitationState> emit,
  ) async {
    // TODO: Implement resend invitation
    // Untuk sekarang, kita akan emit success state
    emit(BrandInvitationResent(
      invitationId: event.invitationId,
      message: 'Invitation berhasil dikirim ulang',
    ));
  }

  /// Handler untuk validate invitation token
  Future<void> _onValidateInvitationToken(
    ValidateInvitationTokenEvent event,
    Emitter<BrandInvitationState> emit,
  ) async {
    // TODO: Implement token validation
    // Untuk sekarang, kita akan emit success state dengan mock data

    // Mock invitation untuk testing
    final mockInvitation = BrandInvitation(
      id: 'mock-id',
      brandId: 'mock-brand-id',
      brandName: 'Mock Brand',
      inviterId: 'mock-inviter-id',
      inviterName: 'Mock Inviter',
      inviteeEmail: 'test@example.com',
      role: 'BRAND_MEMBER',
      status: 'PENDING',
      branchIds: const [],
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );

    emit(InvitationTokenValidated(
      invitation: mockInvitation,
      isValid: true,
    ));
  }

  /// Handler untuk get invitation by ID
  Future<void> _onGetInvitationById(
    GetInvitationByIdEvent event,
    Emitter<BrandInvitationState> emit,
  ) async {
    // Cari di cache
    final invitation = _cachedInvitations.where((inv) => inv.id == event.invitationId).firstOrNull;

    if (invitation != null) {
      emit(InvitationDetailLoaded(invitation: invitation));
    } else {
      emit(BrandInvitationError(
        message: 'Invitation tidak ditemukan',
        errorCode: 'NOT_FOUND',
        invitationId: event.invitationId,
      ));
    }
  }

  /// Handler untuk update invitation
  Future<void> _onUpdateInvitation(
    UpdateInvitationEvent event,
    Emitter<BrandInvitationState> emit,
  ) async {
    // TODO: Implement update invitation
    // Untuk sekarang, kita akan emit success state dengan mock data

    // Cari invitation di cache
    final index = _cachedInvitations.indexWhere((inv) => inv.id == event.invitationId);
    if (index != -1) {
      final updatedInvitation = _cachedInvitations[index].copyWith(
        role: event.role,
        expiresAt: event.expiresAt,
      );

      _cachedInvitations[index] = updatedInvitation;

      emit(BrandInvitationUpdated(
        invitation: updatedInvitation,
        message: 'Invitation berhasil diperbarui',
      ));
    } else {
      emit(BrandInvitationError(
        message: 'Invitation tidak ditemukan',
        errorCode: 'NOT_FOUND',
        invitationId: event.invitationId,
      ));
    }
  }

  /// Validasi data untuk membuat invitation
  Map<String, String> _validateCreateInvitationData(CreateInvitationEvent event) {
    final errors = <String, String>{};

    // Validasi email
    if (event.email.trim().isEmpty) {
      errors['email'] = 'Email tidak boleh kosong';
    } else {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(event.email.trim())) {
        errors['email'] = 'Format email tidak valid';
      }
    }

    // Validasi role
    if (event.role.trim().isEmpty) {
      errors['role'] = 'Role tidak boleh kosong';
    }

    // Validasi expiration date jika ada
    if (event.expiresAt != null && event.expiresAt!.isBefore(DateTime.now())) {
      errors['expiresAt'] = 'Tanggal kedaluwarsa tidak boleh di masa lalu';
    }

    return errors;
  }

  /// Mapping failure ke user-friendly message
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case NetworkFailure:
        return 'Tidak ada koneksi internet. Periksa koneksi Anda dan coba lagi.';
      case ValidationFailure:
        return failure.message;
      case BetterAuthFailure:
        return 'Anda tidak memiliki izin untuk melakukan operasi invitation';
      default:
        return 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.';
    }
  }

  /// Mapping failure ke error code
  String? _mapFailureToErrorCode(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        final serverFailure = failure as ServerFailure;
        return serverFailure.statusCode?.toString();
      case NetworkFailure:
        return 'NETWORK_ERROR';
      case ValidationFailure:
        return 'VALIDATION_ERROR';
      case BetterAuthFailure:
        return 'AUTH_ERROR';
      default:
        return 'UNKNOWN_ERROR';
    }
  }
}