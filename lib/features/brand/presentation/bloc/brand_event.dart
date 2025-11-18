import 'package:equatable/equatable.dart';

/// Abstract base class for all brand events
/// Extends Equatable for value comparison
abstract class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object> get props => [];
}

/// Event to load user brands
class LoadUserBrandsEvent extends BrandEvent {
  const LoadUserBrandsEvent();

  @override
  List<Object> get props => [];
}

/// Event to load accessible brands
class LoadAccessibleBrandsEvent extends BrandEvent {
  const LoadAccessibleBrandsEvent();

  @override
  List<Object> get props => [];
}

/// Event to create a new brand
class CreateBrandEvent extends BrandEvent {
  final Map<String, dynamic> brandData;

  const CreateBrandEvent(this.brandData);

  @override
  List<Object> get props => [brandData];
}

/// Event to switch active brand
class SwitchBrandEvent extends BrandEvent {
  final String brandId;

  const SwitchBrandEvent(this.brandId);

  @override
  List<Object> get props => [brandId];
}

/// Event to invite user to brand
class InviteUserEvent extends BrandEvent {
  final String brandId;
  final Map<String, dynamic> invitationData;

  const InviteUserEvent(this.brandId, this.invitationData);

  @override
  List<Object> get props => [brandId, invitationData];
}

/// Event to accept brand invitation
class AcceptInvitationEvent extends BrandEvent {
  final String invitationId;
  final String token;

  const AcceptInvitationEvent(this.invitationId, this.token);

  @override
  List<Object> get props => [invitationId, token];
}

/// Event to decline brand invitation
class DeclineInvitationEvent extends BrandEvent {
  final String invitationId;

  const DeclineInvitationEvent(this.invitationId);

  @override
  List<Object> get props => [invitationId];
}

/// Event to get brand by ID
class GetBrandByIdEvent extends BrandEvent {
  final String brandId;

  const GetBrandByIdEvent(this.brandId);

  @override
  List<Object> get props => [brandId];
}

/// Event to get brand by slug
class GetBrandBySlugEvent extends BrandEvent {
  final String slug;

  const GetBrandBySlugEvent(this.slug);

  @override
  List<Object> get props => [slug];
}

/// Event to update brand
class UpdateBrandEvent extends BrandEvent {
  final String brandId;
  final Map<String, dynamic> brandData;

  const UpdateBrandEvent(this.brandId, this.brandData);

  @override
  List<Object> get props => [brandId, brandData];
}

/// Event to delete brand
class DeleteBrandEvent extends BrandEvent {
  final String brandId;

  const DeleteBrandEvent(this.brandId);

  @override
  List<Object> get props => [brandId];
}

/// Event to get brand invitations
class GetBrandInvitationsEvent extends BrandEvent {
  final String brandId;

  const GetBrandInvitationsEvent(this.brandId);

  @override
  List<Object> get props => [brandId];
}

/// Event to transfer ownership
class TransferOwnershipEvent extends BrandEvent {
  final String brandId;
  final String newOwnerId;
  final String confirmationCode;

  const TransferOwnershipEvent(this.brandId, this.newOwnerId, this.confirmationCode);

  @override
  List<Object> get props => [brandId, newOwnerId, confirmationCode];
}

/// Event to load user invitations (both sent and received)
class LoadUserInvitationsEvent extends BrandEvent {
  const LoadUserInvitationsEvent();

  @override
  List<Object> get props => [];
}

/// Event to get received invitations for the current user
class GetReceivedInvitationsEvent extends BrandEvent {
  const GetReceivedInvitationsEvent();

  @override
  List<Object> get props => [];
}

/// Event to get sent invitations for the current user
class GetSentInvitationsEvent extends BrandEvent {
  const GetSentInvitationsEvent();

  @override
  List<Object> get props => [];
}

/// Event to cancel a sent invitation
class CancelInvitationEvent extends BrandEvent {
  final String invitationId;

  const CancelInvitationEvent(this.invitationId);

  @override
  List<Object> get props => [invitationId];
}

/// Event to resend an invitation
class ResendInvitationEvent extends BrandEvent {
  final String invitationId;

  const ResendInvitationEvent(this.invitationId);

  @override
  List<Object> get props => [invitationId];
}

/// Event to search brands with query and filters
class SearchBrandsEvent extends BrandEvent {
  final String query;
  final Map<String, dynamic>? filters;

  const SearchBrandsEvent(this.query, {this.filters});

  @override
  List<Object> get props => [query, filters ?? {}];
}

/// Event to clear brand search results
class ClearBrandSearchEvent extends BrandEvent {
  const ClearBrandSearchEvent();

  @override
  List<Object> get props => [];
}