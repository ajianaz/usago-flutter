import 'package:equatable/equatable.dart';

/// Abstract base class untuk semua token management events
/// Extends Equatable untuk value comparison
abstract class TokenManagementEvent extends Equatable {
  const TokenManagementEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk load semua refresh tokens
class LoadTokensEvent extends TokenManagementEvent {
  const LoadTokensEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk revoke single token
class RevokeTokenEvent extends TokenManagementEvent {
  final String refreshToken;
  final String? deviceName;

  const RevokeTokenEvent({
    required this.refreshToken,
    this.deviceName,
  });

  @override
  List<Object> get props => [refreshToken, deviceName ?? ''];
}

/// Event untuk revoke semua tokens
class RevokeAllTokensEvent extends TokenManagementEvent {
  const RevokeAllTokensEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk refresh token list
class RefreshTokensEvent extends TokenManagementEvent {
  const RefreshTokensEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk clear token management state
class ClearTokenManagementEvent extends TokenManagementEvent {
  const ClearTokenManagementEvent();

  @override
  List<Object> get props => [];
}

/// Event untuk filter tokens berdasarkan device
class FilterTokensEvent extends TokenManagementEvent {
  final String? deviceType;
  final String? searchTerm;

  const FilterTokensEvent({
    this.deviceType,
    this.searchTerm,
  });

  @override
  List<Object> get props => [deviceType ?? '', searchTerm ?? ''];
}

/// Event untuk sort tokens
class SortTokensEvent extends TokenManagementEvent {
  final TokenSortType sortType;
  final bool ascending;

  const SortTokensEvent({
    required this.sortType,
    this.ascending = true,
  });

  @override
  List<Object> get props => [sortType, ascending];
}

/// Enum untuk token sort types
enum TokenSortType {
  lastSeen,
  deviceName,
  createdAt,
  expiresAt,
}
