import 'package:equatable/equatable.dart';
import 'token_management_event.dart';

/// Abstract base class untuk semua token management states
/// Extends Equatable untuk value comparison
abstract class TokenManagementState extends Equatable {
  const TokenManagementState();

  @override
  List<Object> get props => [];
}

/// Initial state ketika token management bloc pertama kali dibuat
class TokenManagementInitial extends TokenManagementState {
  const TokenManagementInitial();

  @override
  List<Object> get props => [];
}

/// Loading state ketika operasi token management sedang berlangsung
class TokenManagementLoading extends TokenManagementState {
  const TokenManagementLoading();

  @override
  List<Object> get props => [];
}

/// State ketika tokens berhasil dimuat
class TokenManagementLoaded extends TokenManagementState {
  final List<Map<String, dynamic>> tokens;
  final List<Map<String, dynamic>> filteredTokens;
  final TokenSortType sortType;
  final bool ascending;
  final String? deviceTypeFilter;
  final String? searchTerm;

  const TokenManagementLoaded({
    required this.tokens,
    required this.filteredTokens,
    this.sortType = TokenSortType.lastSeen,
    this.ascending = false,
    this.deviceTypeFilter,
    this.searchTerm,
  });

  @override
  List<Object> get props => [
        tokens,
        filteredTokens,
        sortType,
        ascending,
        deviceTypeFilter ?? '',
        searchTerm ?? '',
      ];

  TokenManagementLoaded copyWith({
    List<Map<String, dynamic>>? tokens,
    List<Map<String, dynamic>>? filteredTokens,
    TokenSortType? sortType,
    bool? ascending,
    String? deviceTypeFilter,
    String? searchTerm,
  }) {
    return TokenManagementLoaded(
      tokens: tokens ?? this.tokens,
      filteredTokens: filteredTokens ?? this.filteredTokens,
      sortType: sortType ?? this.sortType,
      ascending: ascending ?? this.ascending,
      deviceTypeFilter: deviceTypeFilter ?? this.deviceTypeFilter,
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }
}

/// State ketika token berhasil direvoke
class TokenManagementRevoked extends TokenManagementState {
  final String tokenId;
  final String? deviceName;
  final String message;

  const TokenManagementRevoked({
    required this.tokenId,
    this.deviceName,
    required this.message,
  });

  @override
  List<Object> get props => [tokenId, deviceName ?? '', message];
}

/// State ketika semua tokens berhasil direvoke
class TokenManagementAllRevoked extends TokenManagementState {
  final String message;

  const TokenManagementAllRevoked({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

/// State ketika operasi token management gagal
class TokenManagementError extends TokenManagementState {
  final String message;
  final String? errorCode;

  const TokenManagementError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object> get props => [message, errorCode ?? ''];
}

/// State untuk konfirmasi revoke token
class TokenManagementRevokeConfirmation extends TokenManagementState {
  final Map<String, dynamic> token;

  const TokenManagementRevokeConfirmation({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}

/// State untuk konfirmasi revoke all tokens
class TokenManagementRevokeAllConfirmation extends TokenManagementState {
  final int tokenCount;

  const TokenManagementRevokeAllConfirmation({
    required this.tokenCount,
  });

  @override
  List<Object> get props => [tokenCount];
}

/// State ketika tidak ada tokens
class TokenManagementEmpty extends TokenManagementState {
  const TokenManagementEmpty();

  @override
  List<Object> get props => [];
}

/// State untuk refresh tokens
class TokenManagementRefreshing extends TokenManagementState {
  final List<Map<String, dynamic>> currentTokens;

  const TokenManagementRefreshing({
    required this.currentTokens,
  });

  @override
  List<Object> get props => [currentTokens];
}
