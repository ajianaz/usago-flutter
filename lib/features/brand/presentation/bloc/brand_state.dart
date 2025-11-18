import 'package:equatable/equatable.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/brand_invitation.dart';

/// Abstract base class for all brand states
/// Extends Equatable for value comparison
abstract class BrandState extends Equatable {
  const BrandState();

  @override
  List<Object> get props => [];
}

/// Initial state when brand bloc is first created
class BrandInitial extends BrandState {
  const BrandInitial();

  @override
  List<Object> get props => [];
}

/// Loading state when brand operation is in progress
class BrandLoading extends BrandState {
  const BrandLoading();

  @override
  List<Object> get props => [];
}

/// State when brands are successfully loaded
class BrandLoaded extends BrandState {
  final List<Brand> userBrands;
  final List<Brand> accessibleBrands;
  final Brand? activeBrand;

  const BrandLoaded({
    required this.userBrands,
    required this.accessibleBrands,
    this.activeBrand,
  });

  @override
  List<Object> get props => [userBrands, accessibleBrands, activeBrand ?? Object()];
}

/// State when brand operation succeeds
class BrandOperationSuccess extends BrandState {
  final String message;

  const BrandOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

/// State when brand invitations are loaded
class BrandInvitationsLoaded extends BrandState {
  final List<BrandInvitation> sentInvitations;
  final List<BrandInvitation> receivedInvitations;

  const BrandInvitationsLoaded({
    required this.sentInvitations,
    required this.receivedInvitations,
  });

  @override
  List<Object> get props => [sentInvitations, receivedInvitations];
}

/// State when sent invitations are loaded
class SentInvitationsLoaded extends BrandState {
  final List<BrandInvitation> invitations;

  const SentInvitationsLoaded(this.invitations);

  @override
  List<Object> get props => [invitations];
}

/// State when received invitations are loaded
class ReceivedInvitationsLoaded extends BrandState {
  final List<BrandInvitation> invitations;

  const ReceivedInvitationsLoaded(this.invitations);

  @override
  List<Object> get props => [invitations];
}

/// State when brand operation fails
class BrandError extends BrandState {
  final String message;

  const BrandError(this.message);

  @override
  List<Object> get props => [message];
}

/// State when brand search results are loaded
class BrandSearchLoaded extends BrandState {
  final List<Brand> searchResults;
  final String query;
  final Map<String, dynamic>? filters;

  const BrandSearchLoaded({
    required this.searchResults,
    required this.query,
    this.filters,
  });

  @override
  List<Object> get props => [searchResults, query, filters ?? {}];
}

/// State when brand search is in progress
class BrandSearchLoading extends BrandState {
  const BrandSearchLoading();

  @override
  List<Object> get props => [];
}