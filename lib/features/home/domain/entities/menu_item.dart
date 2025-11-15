import 'package:equatable/equatable.dart';

/// Menu item entity for home page feature cards
class MenuItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String route;
  final List<String> requiredPermissions;
  final bool isEnabled;
  final int sortOrder;
  final String? category;

  const MenuItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    this.requiredPermissions = const [],
    this.isEnabled = true,
    this.sortOrder = 0,
    this.category,
  });

  /// Create MenuItem from JSON
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      route: json['route'] as String,
      requiredPermissions: (json['requiredPermissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isEnabled: json['isEnabled'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 0,
      category: json['category'] as String?,
    );
  }

  /// Convert MenuItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'route': route,
      'requiredPermissions': requiredPermissions,
      'isEnabled': isEnabled,
      'sortOrder': sortOrder,
      'category': category,
    };
  }

  /// Check if user has permission to access this menu
  bool hasPermission(List<String> userPermissions) {
    if (requiredPermissions.isEmpty) return true;
    return requiredPermissions
        .any((permission) => userPermissions.contains(permission));
  }

  /// Get display name for category
  String get categoryDisplayName {
    switch (category) {
      case 'management':
        return 'Manajemen';
      case 'operations':
        return 'Operasional';
      case 'reports':
        return 'Laporan';
      case 'settings':
        return 'Pengaturan';
      default:
        return 'Umum';
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        icon,
        route,
        requiredPermissions,
        isEnabled,
        sortOrder,
        category,
      ];

  @override
  String toString() {
    return 'MenuItem(id: $id, title: $title, route: $route)';
  }
}
