import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import '../../../../i18n/translations.g.dart';

/// User dashboard entity for home page statistics and info
class UserDashboard extends Equatable {
  final String userId;
  final String userName;
  final String userEmail;
  final String? userRole;
  final String? branchName;
  final String? brandName;
  final int totalOrders;
  final int pendingTasks;
  final int unreadNotifications;
  final DateTime lastLogin;
  final Map<String, dynamic> quickStats;

  const UserDashboard({
    required this.userId,
    required this.userName,
    required this.userEmail,
    this.userRole,
    this.branchName,
    this.brandName,
    this.totalOrders = 0,
    this.pendingTasks = 0,
    this.unreadNotifications = 0,
    required this.lastLogin,
    this.quickStats = const {},
  });

  /// Create UserDashboard from JSON
  factory UserDashboard.fromJson(Map<String, dynamic> json) {
    return UserDashboard(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String,
      userRole: json['userRole'] as String?,
      branchName: json['branchName'] as String?,
      brandName: json['brandName'] as String?,
      totalOrders: json['totalOrders'] as int? ?? 0,
      pendingTasks: json['pendingTasks'] as int? ?? 0,
      unreadNotifications: json['unreadNotifications'] as int? ?? 0,
      lastLogin: DateTime.parse(json['lastLogin'] as String),
      quickStats: json['quickStats'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Convert UserDashboard to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userRole': userRole,
      'branchName': branchName,
      'brandName': brandName,
      'totalOrders': totalOrders,
      'pendingTasks': pendingTasks,
      'unreadNotifications': unreadNotifications,
      'lastLogin': lastLogin.toIso8601String(),
      'quickStats': quickStats,
    };
  }

  /// Get display name for user role
  String roleDisplayName(BuildContext context) {
    final t = Translations.of(context);
    switch (userRole?.toUpperCase()) {
      case 'BRAND_OWNER':
        return t.brand.brand_owner;
      case 'BRANCH_MANAGER':
        return t.brand.branch_manager;
      case 'BRANCH_ADMIN':
        return t.brand.branch_admin;
      case 'BRANCH_STAFF':
        return t.brand.branch_staff;
      case 'CROSS_BRANCH_VIEWER':
        return t.brand.cross_branch_viewer;
      // Legacy values for backward compatibility
      case 'OWNER':
        return t.brand.role_owner;
      case 'ADMIN':
        return t.brand.role_admin;
      case 'MANAGER':
        return t.brand.role_manager;
      case 'STAFF':
        return t.brand.role_employee; // Using employee as closest match
      case 'CASHIER':
        return 'Kasir'; // No direct translation, using hardcoded
      case 'ACCOUNTANT':
        return 'Akuntan'; // No direct translation, using hardcoded
      case 'VIEWER':
        return t.brand.cross_branch_viewer; // Using closest match
      default:
        return userRole ?? 'Unknown';
    }
  }

  /// Get formatted last login time
  String get lastLoginFormatted {
    final now = DateTime.now();
    final difference = now.difference(lastLogin);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  /// Get user's full display info
  String userDisplayInfo(BuildContext context) {
    final parts = <String>[];
    if (userName.isNotEmpty) parts.add(userName);
    if (roleDisplayName(context) != 'Unknown') parts.add(roleDisplayName(context));
    if (branchName != null) parts.add(branchName!);

    return parts.join(' • ');
  }

  /// Check if user has pending items
  bool get hasPendingItems => pendingTasks > 0 || unreadNotifications > 0;

  /// Get total pending count
  int get totalPendingCount => pendingTasks + unreadNotifications;

  /// Create empty dashboard
  static UserDashboard empty() {
    return UserDashboard(
      userId: '',
      userName: '',
      userEmail: '',
      lastLogin: DateTime.now(),
    );
  }

  /// Copy with modified fields
  UserDashboard copyWith({
    String? userId,
    String? userName,
    String? userEmail,
    String? userRole,
    String? branchName,
    String? brandName,
    int? totalOrders,
    int? pendingTasks,
    int? unreadNotifications,
    DateTime? lastLogin,
    Map<String, dynamic>? quickStats,
  }) {
    return UserDashboard(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userRole: userRole ?? this.userRole,
      branchName: branchName ?? this.branchName,
      brandName: brandName ?? this.brandName,
      totalOrders: totalOrders ?? this.totalOrders,
      pendingTasks: pendingTasks ?? this.pendingTasks,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      lastLogin: lastLogin ?? this.lastLogin,
      quickStats: quickStats ?? this.quickStats,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        userName,
        userEmail,
        userRole,
        branchName,
        brandName,
        totalOrders,
        pendingTasks,
        unreadNotifications,
        lastLogin,
        quickStats,
      ];

  @override
  String toString() {
    return 'UserDashboard(userId: $userId, userName: $userName, userRole: $userRole)';
  }
}