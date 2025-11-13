import '../../domain/entities/user_dashboard.dart';

/// User dashboard model for data layer
class UserDashboardModel extends UserDashboard {
  const UserDashboardModel({
    required super.userId,
    required super.userName,
    required super.userEmail,
    super.userRole,
    super.branchName,
    super.brandName,
    super.totalOrders = 0,
    super.pendingTasks = 0,
    super.unreadNotifications = 0,
    required super.lastLogin,
    super.quickStats = const {},
  });

  /// Create UserDashboardModel from JSON
  factory UserDashboardModel.fromJson(Map<String, dynamic> json) {
    return UserDashboardModel(
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

  /// Convert UserDashboardModel to JSON
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

  /// Create UserDashboardModel from UserDashboard entity
  factory UserDashboardModel.fromEntity(UserDashboard entity) {
    return UserDashboardModel(
      userId: entity.userId,
      userName: entity.userName,
      userEmail: entity.userEmail,
      userRole: entity.userRole,
      branchName: entity.branchName,
      brandName: entity.brandName,
      totalOrders: entity.totalOrders,
      pendingTasks: entity.pendingTasks,
      unreadNotifications: entity.unreadNotifications,
      lastLogin: entity.lastLogin,
      quickStats: entity.quickStats,
    );
  }

  /// Convert to UserDashboard entity
  UserDashboard toEntity() {
    return UserDashboard(
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      userRole: userRole,
      branchName: branchName,
      brandName: brandName,
      totalOrders: totalOrders,
      pendingTasks: pendingTasks,
      unreadNotifications: unreadNotifications,
      lastLogin: lastLogin,
      quickStats: quickStats,
    );
  }

  /// Create sample dashboard for demo/testing
  static UserDashboardModel createSample({
    String? userId,
    String? userName,
    String? userEmail,
    String? userRole,
    String? branchName,
    String? brandName,
  }) {
    return UserDashboardModel(
      userId: userId ?? 'user-123',
      userName: userName ?? 'John Doe',
      userEmail: userEmail ?? 'john.doe@example.com',
      userRole: userRole ?? 'Manager',
      branchName: branchName ?? 'Cabang Utama',
      brandName: brandName ?? 'Usago Brand',
      totalOrders: 156,
      pendingTasks: 8,
      unreadNotifications: 3,
      lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
      quickStats: {
        'todayOrders': 12,
        'weekRevenue': 4500000,
        'monthGrowth': 15.5,
        'activeCustomers': 234,
      },
    );
  }
}