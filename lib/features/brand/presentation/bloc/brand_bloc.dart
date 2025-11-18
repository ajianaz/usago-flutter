import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/brand_invitation.dart';
import '../../domain/repositories/brand_repository.dart';
import 'brand_event.dart';
import 'brand_state.dart';

/// Brand BLoC
/// Handles all brand state management
class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository _brandRepository;

  BrandBloc({
    required BrandRepository brandRepository,
  }) : _brandRepository = brandRepository,
       super(const BrandInitial()) {
    // Register event handlers
    on<LoadUserBrandsEvent>(_onLoadUserBrandsEvent);
    on<LoadAccessibleBrandsEvent>(_onLoadAccessibleBrandsEvent);
    on<CreateBrandEvent>(_onCreateBrandEvent);
    on<SwitchBrandEvent>(_onSwitchBrandEvent);
    on<InviteUserEvent>(_onInviteUserEvent);
    on<AcceptInvitationEvent>(_onAcceptInvitationEvent);
    on<DeclineInvitationEvent>(_onDeclineInvitationEvent);
    on<GetBrandByIdEvent>(_onGetBrandByIdEvent);
    on<GetBrandBySlugEvent>(_onGetBrandBySlugEvent);
    on<UpdateBrandEvent>(_onUpdateBrandEvent);
    on<DeleteBrandEvent>(_onDeleteBrandEvent);
    on<GetBrandInvitationsEvent>(_onGetBrandInvitationsEvent);
    on<LoadUserInvitationsEvent>(_onLoadUserInvitationsEvent);
    on<GetReceivedInvitationsEvent>(_onGetReceivedInvitationsEvent);
    on<GetSentInvitationsEvent>(_onGetSentInvitationsEvent);
    on<CancelInvitationEvent>(_onCancelInvitationEvent);
    on<ResendInvitationEvent>(_onResendInvitationEvent);
    on<TransferOwnershipEvent>(_onTransferOwnershipEvent);
    on<SearchBrandsEvent>(_onSearchBrandsEvent);
    on<ClearBrandSearchEvent>(_onClearBrandSearchEvent);

    // Load user brands on initialization
    add(LoadUserBrandsEvent());
  }

  Future<void> _onLoadUserBrandsEvent(LoadUserBrandsEvent event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());

    final userBrandsResult = await _brandRepository.getUserBrands();
    final accessibleBrandsResult = await _brandRepository.getAccessibleBrands();
    final activeBrandResult = await _brandRepository.getActiveBrand();

    final userBrands = userBrandsResult.fold((failure) => <Brand>[], (brands) => brands);
    final accessibleBrands = accessibleBrandsResult.fold((failure) => <Brand>[], (brands) => brands);
    final activeBrand = activeBrandResult.fold((failure) => null as Brand?, (brand) => brand);

    if (userBrandsResult.isLeft() && accessibleBrandsResult.isLeft()) {
      final failure = userBrandsResult.fold((failure) => failure, (_) => null as dynamic);
      emit(BrandError(failure?.message ?? 'Failed to load brands'));
    } else {
      emit(BrandLoaded(
        userBrands: userBrands,
        accessibleBrands: accessibleBrands,
        activeBrand: activeBrand,
      ));
    }
  }

  Future<void> _onLoadAccessibleBrandsEvent(LoadAccessibleBrandsEvent event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());

    final result = await _brandRepository.getAccessibleBrands();

    emit(result.fold(
      (failure) => BrandError(failure.message),
      (accessibleBrands) {
        // Get current state to preserve user brands and active brand
        final currentState = state;
        if (currentState is BrandLoaded) {
          return BrandLoaded(
            userBrands: currentState.userBrands,
            accessibleBrands: accessibleBrands,
            activeBrand: currentState.activeBrand,
          );
        }
        return BrandLoaded(
          userBrands: [],
          accessibleBrands: accessibleBrands,
          activeBrand: null,
        );
      },
    ));
  }

  Future<void> _onCreateBrandEvent(CreateBrandEvent event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());

    final result = await _brandRepository.createBrand(event.brandData);

    emit(result.fold(
      (failure) => BrandError(failure.message),
      (brand) {
        // Reload brands after successful creation
        add(LoadUserBrandsEvent());
        return BrandOperationSuccess('Brand created successfully');
      },
    ));
  }

  Future<void> _onSwitchBrandEvent(SwitchBrandEvent event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());

    final result = await _brandRepository.switchActiveBrand(event.brandId);

    emit(result.fold(
      (failure) => BrandError(failure.message),
      (brand) {
        // Reload brands after successful switch
        add(LoadUserBrandsEvent());
        return BrandOperationSuccess('Switched to ${brand.name}');
      },
    ));
  }

  Future<void> _onInviteUserEvent(InviteUserEvent event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());

    final result = await _brandRepository.inviteUser(event.brandId, event.invitationData);

    emit(result.fold(
      (failure) => BrandError(failure.message),
      (invitation) => BrandOperationSuccess('User invited successfully'),
    ));
  }

  Future<void> _onAcceptInvitationEvent(AcceptInvitationEvent event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());

    final result = await _brandRepository.acceptInvitation(event.invitationId, event.token);

    emit(result.fold(
      (failure) => BrandError(failure.message),
      (_) {
        // Reload brands after accepting invitation
        add(LoadUserBrandsEvent());
        return BrandOperationSuccess('Invitation accepted successfully');
      },
    ));
  }

  Future<void> _onDeclineInvitationEvent(DeclineInvitationEvent event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());

    final result = await _brandRepository.declineInvitation(event.invitationId);

    emit(result.fold(
      (failure) => BrandError(failure.message),
      (_) => BrandOperationSuccess('Invitation declined'),
    ));
  }

  Future<void> _onGetBrandByIdEvent(GetBrandByIdEvent event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());

    final result = await _brandRepository.getBrandById(event.brandId);

    emit(result.fold(
      (failure) => BrandError(failure.message),
      (brand) => BrandOperationSuccess('Brand found: ${brand.name}'),
    ));
  }

  Future<void> _onGetBrandBySlugEvent(GetBrandBySlugEvent event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());

    final result = await _brandRepository.getBrandBySlug(event.slug);

    emit(result.fold(
      (failure) => BrandError(failure.message),
      (brand) => BrandOperationSuccess('Brand found: ${brand.name}'),
    ));
  }

  Future<void> _onUpdateBrandEvent(UpdateBrandEvent event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());

    final result = await _brandRepository.updateBrand(event.brandId, event.brandData);

    emit(result.fold(
      (failure) => BrandError(failure.message),
      (brand) {
        // Reload brands after successful update
        add(LoadUserBrandsEvent());
        return BrandOperationSuccess('Brand updated successfully');
      },
    ));
  }

  Future<void> _onDeleteBrandEvent(DeleteBrandEvent event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());

    final result = await _brandRepository.deleteBrand(event.brandId);

    emit(result.fold(
      (failure) => BrandError(failure.message),
      (_) {
        // Reload brands after successful deletion
        add(LoadUserBrandsEvent());
        return BrandOperationSuccess('Brand deleted successfully');
      },
    ));
  }

  Future<void> _onGetBrandInvitationsEvent(GetBrandInvitationsEvent event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());

    final result = await _brandRepository.getBrandInvitations(event.brandId);

    emit(result.fold(
      (failure) => BrandError(failure.message),
      (invitations) => BrandOperationSuccess('Loaded ${invitations.length} invitations'),
    ));
  }

  Future<void> _onTransferOwnershipEvent(TransferOwnershipEvent event, Emitter<BrandState> emit) async {
    emit(const BrandLoading());

    final result = await _brandRepository.transferOwnership(
      event.brandId,
      event.newOwnerId,
      event.confirmationCode,
    );

    emit(result.fold(
      (failure) => BrandError(failure.message),
      (_) => BrandOperationSuccess('Ownership transferred successfully'),
    ));
}

Future<void> _onLoadUserInvitationsEvent(LoadUserInvitationsEvent event, Emitter<BrandState> emit) async {
  emit(const BrandLoading());

  // For now, we'll use a placeholder implementation
  // In a real app, this would call repository methods to get user invitations
  final sentInvitations = <BrandInvitation>[];
  final receivedInvitations = <BrandInvitation>[];

  emit(BrandInvitationsLoaded(
    sentInvitations: sentInvitations,
    receivedInvitations: receivedInvitations,
  ));
}

Future<void> _onGetReceivedInvitationsEvent(GetReceivedInvitationsEvent event, Emitter<BrandState> emit) async {
  emit(const BrandLoading());

  // For now, we'll use a placeholder implementation
  // In a real app, this would call repository method to get received invitations
  final invitations = <BrandInvitation>[];

  emit(ReceivedInvitationsLoaded(invitations));
}

Future<void> _onGetSentInvitationsEvent(GetSentInvitationsEvent event, Emitter<BrandState> emit) async {
  emit(const BrandLoading());

  // For now, we'll use a placeholder implementation
  // In a real app, this would call repository method to get sent invitations
  final invitations = <BrandInvitation>[];

  emit(SentInvitationsLoaded(invitations));
}

Future<void> _onCancelInvitationEvent(CancelInvitationEvent event, Emitter<BrandState> emit) async {
  emit(const BrandLoading());

  // For now, we'll use a placeholder implementation
  // In a real app, this would call repository method to cancel invitation
  await Future.delayed(const Duration(seconds: 1));

  emit(const BrandOperationSuccess('Invitation cancelled'));
}

Future<void> _onResendInvitationEvent(ResendInvitationEvent event, Emitter<BrandState> emit) async {
  emit(const BrandLoading());

  // For now, we'll use a placeholder implementation
  // In a real app, this would call repository method to resend invitation
  await Future.delayed(const Duration(seconds: 1));

  emit(const BrandOperationSuccess('Invitation resent'));
}

Future<void> _onSearchBrandsEvent(SearchBrandsEvent event, Emitter<BrandState> emit) async {
  emit(const BrandSearchLoading());

  // For now, we'll simulate search by filtering existing brands
  // In a real app, this would call the repository search method
  final currentState = state;
  if (currentState is BrandLoaded) {
    final allBrands = <Brand>[...currentState.userBrands, ...currentState.accessibleBrands];

    // Filter brands based on query
    final filteredBrands = allBrands.where((brand) {
      final nameMatch = brand.name.toLowerCase().contains(event.query.toLowerCase());
      final slugMatch = brand.slug.toLowerCase().contains(event.query.toLowerCase());
      final descriptionMatch = brand.description?.toLowerCase().contains(event.query.toLowerCase()) ?? false;

      return nameMatch || slugMatch || descriptionMatch;
    }).toList();

    await Future.delayed(const Duration(milliseconds: 300)); // Simulate search delay

    emit(BrandSearchLoaded(
      searchResults: filteredBrands,
      query: event.query,
      filters: event.filters,
    ));
  } else {
    // If no brands are loaded, return empty results
    await Future.delayed(const Duration(milliseconds: 300));
    emit(BrandSearchLoaded(
      searchResults: [],
      query: event.query,
      filters: event.filters,
    ));
  }
}

Future<void> _onClearBrandSearchEvent(ClearBrandSearchEvent event, Emitter<BrandState> emit) async {
  // Reload brands to clear search state
  add(LoadUserBrandsEvent());
}
}