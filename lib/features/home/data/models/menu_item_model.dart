import '../../domain/entities/menu_item.dart';

/// Menu item model for data layer
class MenuItemModel extends MenuItem {
  const MenuItemModel({
    required super.id,
    required super.title,
    required super.description,
    required super.icon,
    required super.route,
    super.requiredPermissions = const [],
    super.isEnabled = true,
    super.sortOrder = 0,
    super.category,
  });

  /// Create MenuItemModel from JSON
  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
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

  /// Convert MenuItemModel to JSON
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

  /// Create MenuItemModel from MenuItem entity
  factory MenuItemModel.fromEntity(MenuItem entity) {
    return MenuItemModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      icon: entity.icon,
      route: entity.route,
      requiredPermissions: entity.requiredPermissions,
      isEnabled: entity.isEnabled,
      sortOrder: entity.sortOrder,
      category: entity.category,
    );
  }

  /// Convert to MenuItem entity
  MenuItem toEntity() {
    return MenuItem(
      id: id,
      title: title,
      description: description,
      icon: icon,
      route: route,
      requiredPermissions: requiredPermissions,
      isEnabled: isEnabled,
      sortOrder: sortOrder,
      category: category,
    );
  }

  /// Create default menu items for demo/testing
  static List<MenuItemModel> getDefaultMenuItems() {
    return [
      MenuItemModel(
        id: '1',
        title: 'Dashboard',
        description: 'Lihat overview dan statistik',
        icon: 'dashboard',
        route: '/dashboard',
        category: 'management',
        sortOrder: 1,
      ),
      MenuItemModel(
        id: '2',
        title: 'Pesanan',
        description: 'Kelola pesanan customer',
        icon: 'orders',
        route: '/orders',
        category: 'operations',
        sortOrder: 2,
      ),
      MenuItemModel(
        id: '3',
        title: 'Produk',
        description: 'Kelola produk dan inventory',
        icon: 'products',
        route: '/products',
        category: 'operations',
        sortOrder: 3,
      ),
      MenuItemModel(
        id: '4',
        title: 'Pelanggan',
        description: 'Kelola data pelanggan',
        icon: 'customers',
        route: '/customers',
        category: 'management',
        sortOrder: 4,
      ),
      MenuItemModel(
        id: '5',
        title: 'Laporan',
        description: 'Lihat laporan penjualan',
        icon: 'reports',
        route: '/reports',
        category: 'reports',
        sortOrder: 5,
      ),
      MenuItemModel(
        id: '6',
        title: 'Keuangan',
        description: 'Kelola keuangan dan pembayaran',
        icon: 'finance',
        route: '/finance',
        category: 'management',
        sortOrder: 6,
      ),
      MenuItemModel(
        id: '7',
        title: 'Pengaturan',
        description: 'Pengaturan sistem',
        icon: 'settings',
        route: '/settings',
        category: 'settings',
        sortOrder: 7,
      ),
      MenuItemModel(
        id: '8',
        title: 'Notifikasi',
        description: 'Pusat notifikasi',
        icon: 'notifications',
        route: '/notifications',
        category: 'settings',
        sortOrder: 8,
      ),
    ];
  }
}