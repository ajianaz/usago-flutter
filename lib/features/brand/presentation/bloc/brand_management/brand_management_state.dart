import 'package:equatable/equatable.dart';
import '../../../domain/entities/brand.dart';

/// Abstract base class untuk semua brand management states
/// Extends Equatable untuk value comparison
abstract class BrandManagementState extends Equatable {
  const BrandManagementState();

  @override
  List<Object> get props => [];
}

/// Initial state ketika brand management bloc pertama kali dibuat
class BrandManagementInitial extends BrandManagementState {
  const BrandManagementInitial();

  @override
  List<Object> get props => [];
}

/// Loading state ketika operasi brand management sedang berlangsung
class BrandManagementLoading extends BrandManagementState {
  const BrandManagementLoading();

  @override
  List<Object> get props => [];
}

/// State ketika brand berhasil dimuat
class BrandManagementLoaded extends BrandManagementState {
  final Brand brand;

  const BrandManagementLoaded({required this.brand});

  @override
  List<Object> get props => [brand];
}

/// State ketika semua brands berhasil dimuat
class BrandManagementAllBrandsLoaded extends BrandManagementState {
  final List<Brand> brands;

  const BrandManagementAllBrandsLoaded({required this.brands});

  @override
  List<Object> get props => [brands];
}

/// State ketika brand berhasil dibuat
class BrandManagementCreated extends BrandManagementState {
  final Brand brand;
  final String message;

  const BrandManagementCreated({
    required this.brand,
    required this.message,
  });

  @override
  List<Object> get props => [brand, message];
}

/// State ketika brand berhasil diupdate
class BrandManagementUpdated extends BrandManagementState {
  final Brand brand;
  final String message;

  const BrandManagementUpdated({
    required this.brand,
    required this.message,
  });

  @override
  List<Object> get props => [brand, message];
}

/// State ketika brand berhasil dihapus
class BrandManagementDeleted extends BrandManagementState {
  final String brandId;
  final String message;

  const BrandManagementDeleted({
    required this.brandId,
    required this.message,
  });

  @override
  List<Object> get props => [brandId, message];
}

/// State ketika operasi brand management gagal
class BrandManagementError extends BrandManagementState {
  final String message;
  final String? errorCode;

  const BrandManagementError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object> get props => [message, errorCode ?? ''];
}

/// State untuk validasi form brand
class BrandManagementValidationError extends BrandManagementState {
  final Map<String, String> errors;

  const BrandManagementValidationError({required this.errors});

  @override
  List<Object> get props => [errors];
}

/// State untuk konfirmasi penghapusan brand
class BrandManagementDeleteConfirmation extends BrandManagementState {
  final Brand brand;

  const BrandManagementDeleteConfirmation({required this.brand});

  @override
  List<Object> get props => [brand];
}

/// State ketika proses transfer ownership sedang berlangsung
class TransferOwnershipInProgress extends BrandManagementState {
  final String brandId;
  final String newOwnerEmail;

  const TransferOwnershipInProgress({
    required this.brandId,
    required this.newOwnerEmail,
  });

  @override
  List<Object> get props => [brandId, newOwnerEmail];
}

/// State ketika transfer ownership berhasil
class TransferOwnershipSuccess extends BrandManagementState {
  final String brandId;
  final String newOwnerEmail;
  final String message;

  const TransferOwnershipSuccess({
    required this.brandId,
    required this.newOwnerEmail,
    required this.message,
  });

  @override
  List<Object> get props => [brandId, newOwnerEmail, message];
}

/// State ketika transfer ownership gagal
class TransferOwnershipError extends BrandManagementState {
  final String brandId;
  final String newOwnerEmail;
  final String message;
  final String? errorCode;

  const TransferOwnershipError({
    required this.brandId,
    required this.newOwnerEmail,
    required this.message,
    this.errorCode,
  });

  @override
  List<Object> get props => [brandId, newOwnerEmail, message, errorCode ?? ''];
}
