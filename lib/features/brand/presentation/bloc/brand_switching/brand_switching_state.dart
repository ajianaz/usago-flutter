import 'package:equatable/equatable.dart';
import '../../../domain/entities/brand.dart';

/// Abstract base class untuk semua brand switching states
/// Extends Equatable untuk value comparison
abstract class BrandSwitchingState extends Equatable {
  const BrandSwitchingState();

  @override
  List<Object> get props => [];
}

/// Initial state ketika brand switching bloc pertama kali dibuat
class BrandSwitchingInitial extends BrandSwitchingState {
  const BrandSwitchingInitial();

  @override
  List<Object> get props => [];
}

/// Loading state ketika operasi switching sedang berlangsung
class BrandSwitchingLoading extends BrandSwitchingState {
  const BrandSwitchingLoading();

  @override
  List<Object> get props => [];
}

/// State ketika brand switching berhasil
class BrandSwitchingSuccess extends BrandSwitchingState {
  final Brand previousBrand;
  final Brand newActiveBrand;
  final String message;

  const BrandSwitchingSuccess({
    required this.previousBrand,
    required this.newActiveBrand,
    required this.message,
  });

  @override
  List<Object> get props => [previousBrand, newActiveBrand, message];
}

/// State ketika active brand status berhasil dimuat
class ActiveBrandStatusLoaded extends BrandSwitchingState {
  final Brand? activeBrand;
  final bool hasActiveBrand;

  const ActiveBrandStatusLoaded({
    this.activeBrand,
    required this.hasActiveBrand,
  });

  @override
  List<Object> get props => [activeBrand ?? Object(), hasActiveBrand];
}

/// State ketika operasi switching gagal
class BrandSwitchingError extends BrandSwitchingState {
  final String message;
  final String? errorCode;
  final String? brandId;

  const BrandSwitchingError({
    required this.message,
    this.errorCode,
    this.brandId,
  });

  @override
  List<Object> get props => [message, errorCode ?? '', brandId ?? ''];
}

/// State ketika tidak ada active brand
class NoActiveBrandState extends BrandSwitchingState {
  const NoActiveBrandState();

  @override
  List<Object> get props => [];
}

/// State untuk konfirmasi switching
class BrandSwitchingConfirmation extends BrandSwitchingState {
  final Brand currentBrand;
  final Brand targetBrand;
  final String warningMessage;

  const BrandSwitchingConfirmation({
    required this.currentBrand,
    required this.targetBrand,
    required this.warningMessage,
  });

  @override
  List<Object> get props => [currentBrand, targetBrand, warningMessage];
}

/// State ketika pre-check switching selesai
class BrandSwitchPreCheckCompleted extends BrandSwitchingState {
  final Brand targetBrand;
  final bool canSwitch;
  final String? warningMessage;
  final List<String> requirements;

  const BrandSwitchPreCheckCompleted({
    required this.targetBrand,
    required this.canSwitch,
    this.warningMessage,
    this.requirements = const [],
  });

  @override
  List<Object> get props => [
        targetBrand,
        canSwitch,
        warningMessage ?? '',
        requirements,
      ];
}

/// State ketika switching history berhasil dimuat
class SwitchingHistoryLoaded extends BrandSwitchingState {
  final List<BrandSwitchRecord> history;

  const SwitchingHistoryLoaded({required this.history});

  @override
  List<Object> get props => [history];
}

/// State ketika brand access validation selesai
class BrandAccessValidationCompleted extends BrandSwitchingState {
  final String brandId;
  final bool hasAccess;
  final String? role;
  final List<String> permissions;

  const BrandAccessValidationCompleted({
    required this.brandId,
    required this.hasAccess,
    this.role,
    this.permissions = const [],
  });

  @override
  List<Object> get props => [
        brandId,
        hasAccess,
        role ?? '',
        permissions,
      ];
}

/// State ketika sync brand data selesai
class BrandDataSyncCompleted extends BrandSwitchingState {
  final String brandId;
  final bool syncSuccessful;
  final String? syncMessage;

  const BrandDataSyncCompleted({
    required this.brandId,
    required this.syncSuccessful,
    this.syncMessage,
  });

  @override
  List<Object> get props => [brandId, syncSuccessful, syncMessage ?? ''];
}

/// Record untuk brand switching history
class BrandSwitchRecord extends Equatable {
  final String brandId;
  final String brandName;
  final DateTime switchedAt;
  final String? previousBrandId;
  final String? previousBrandName;

  const BrandSwitchRecord({
    required this.brandId,
    required this.brandName,
    required this.switchedAt,
    this.previousBrandId,
    this.previousBrandName,
  });

  @override
  List<Object?> get props => [
        brandId,
        brandName,
        switchedAt,
        previousBrandId,
        previousBrandName,
      ];
}