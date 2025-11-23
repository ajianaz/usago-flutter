import 'package:equatable/equatable.dart';

/// Abstract base class untuk semua brand management events
/// Extends Equatable untuk value comparison
abstract class BrandManagementEvent extends Equatable {
  const BrandManagementEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk membuat brand baru
class CreateBrandEvent extends BrandManagementEvent {
  final String name;
  final String? logoUrl;
  final String businessType;
  final String? industry;
  final String? description;
  final String timezone;
  final String currency;
  final Map<String, dynamic>? settings;

  const CreateBrandEvent({
    required this.name,
    this.logoUrl,
    required this.businessType,
    this.industry,
    this.description,
    required this.timezone,
    required this.currency,
    this.settings,
  });

  @override
  List<Object> get props => [
        name,
        logoUrl ?? '',
        businessType,
        industry ?? '',
        description ?? '',
        timezone,
        currency,
        settings ?? {},
      ];
}

/// Event untuk update brand
class UpdateBrandEvent extends BrandManagementEvent {
  final String brandId;
  final String? name;
  final String? businessType;
  final String? industry;
  final String? description;
  final String? timezone;
  final String? currency;
  final Map<String, dynamic>? settings;

  const UpdateBrandEvent({
    required this.brandId,
    this.name,
    this.businessType,
    this.industry,
    this.description,
    this.timezone,
    this.currency,
    this.settings,
  });

  @override
  List<Object> get props => [
        brandId,
        name ?? '',
        businessType ?? '',
        industry ?? '',
        description ?? '',
        timezone ?? '',
        currency ?? '',
        settings ?? {},
      ];
}

/// Event untuk menghapus brand
class DeleteBrandEvent extends BrandManagementEvent {
  final String brandId;

  const DeleteBrandEvent(this.brandId);

  @override
  List<Object> get props => [brandId];
}

/// Event untuk refresh data brand
class RefreshBrandEvent extends BrandManagementEvent {
  final String brandId;

  const RefreshBrandEvent(this.brandId);

  @override
  List<Object> get props => [brandId];
}

/// Event untuk transfer ownership brand
class TransferOwnershipEvent extends BrandManagementEvent {
  final String brandId;
  final String newOwnerEmail;
  final String confirmationCode;
  final String? message;

  const TransferOwnershipEvent({
    required this.brandId,
    required this.newOwnerEmail,
    required this.confirmationCode,
    this.message,
  });

  @override
  List<Object> get props => [
        brandId,
        newOwnerEmail,
        confirmationCode,
        message ?? '',
      ];
}

/// Event untuk reset state ke initial
class ResetBrandManagementEvent extends BrandManagementEvent {
  const ResetBrandManagementEvent();

  @override
  List<Object> get props => [];
}
