import 'package:equatable/equatable.dart';

/// Abstract base class untuk semua brand switching events
/// Extends Equatable untuk value comparison
abstract class BrandSwitchingEvent extends Equatable {
  const BrandSwitchingEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk switch active brand
class SwitchActiveBrandEvent extends BrandSwitchingEvent {
  final String brandId;
  final String? branchId;

  const SwitchActiveBrandEvent({
    required this.brandId,
    this.branchId,
  });

  @override
  List<Object> get props => [brandId, branchId ?? ''];
}

/// Event untuk get active brand status
class GetActiveBrandStatusEvent extends BrandSwitchingEvent {
  const GetActiveBrandStatusEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk reset switching state
class ResetBrandSwitchingEvent extends BrandSwitchingEvent {
  const ResetBrandSwitchingEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk pre-check sebelum switching
class PreCheckBrandSwitchEvent extends BrandSwitchingEvent {
  final String brandId;

  const PreCheckBrandSwitchEvent({required this.brandId});

  @override
  List<Object> get props => [brandId];
}

/// Event untuk confirm brand switch
class ConfirmBrandSwitchEvent extends BrandSwitchingEvent {
  final String brandId;
  final bool confirmPermission;

  const ConfirmBrandSwitchEvent({
    required this.brandId,
    required this.confirmPermission,
  });

  @override
  List<Object> get props => [brandId, confirmPermission];
}

/// Event untuk cancel brand switch
class CancelBrandSwitchEvent extends BrandSwitchingEvent {
  const CancelBrandSwitchEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk get switching history
class GetSwitchingHistoryEvent extends BrandSwitchingEvent {
  const GetSwitchingHistoryEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk clear switching history
class ClearSwitchingHistoryEvent extends BrandSwitchingEvent {
  const ClearSwitchingHistoryEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk validate brand access
class ValidateBrandAccessEvent extends BrandSwitchingEvent {
  final String brandId;

  const ValidateBrandAccessEvent({required this.brandId});

  @override
  List<Object> get props => [brandId];
}

/// Event untuk sync brand data after switching
class SyncBrandDataEvent extends BrandSwitchingEvent {
  final String brandId;

  const SyncBrandDataEvent({required this.brandId});

  @override
  List<Object> get props => [brandId];
}
