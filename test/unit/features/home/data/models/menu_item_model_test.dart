import 'package:flutter_test/flutter_test.dart';
import 'package:usago/features/home/data/models/menu_item_model.dart';

void main() {
  group('MenuItemModel', () {
    test('should create MenuItemModel from JSON correctly', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test Menu',
        'description': 'Test Description',
        'icon': 'test_icon',
        'route': '/test-route',
        'requiredPermissions': ['admin', 'user'],
        'isEnabled': true,
        'sortOrder': 1,
        'category': 'test',
      };

      // Act
      final result = MenuItemModel.fromJson(json);

      // Assert
      expect(result.id, '1');
      expect(result.title, 'Test Menu');
      expect(result.description, 'Test Description');
      expect(result.icon, 'test_icon');
      expect(result.route, '/test-route');
      expect(result.requiredPermissions, ['admin', 'user']);
      expect(result.isEnabled, true);
      expect(result.sortOrder, 1);
      expect(result.category, 'test');
    });

    test('should convert MenuItemModel to JSON correctly', () {
      // Arrange
      const model = MenuItemModel(
        id: '1',
        title: 'Test Menu',
        description: 'Test Description',
        icon: 'test_icon',
        route: '/test-route',
        requiredPermissions: ['admin', 'user'],
        isEnabled: true,
        sortOrder: 1,
        category: 'test',
      );

      // Act
      final result = model.toJson();

      // Assert
      expect(result['id'], '1');
      expect(result['title'], 'Test Menu');
      expect(result['description'], 'Test Description');
      expect(result['icon'], 'test_icon');
      expect(result['route'], '/test-route');
      expect(result['requiredPermissions'], ['admin', 'user']);
      expect(result['isEnabled'], true);
      expect(result['sortOrder'], 1);
      expect(result['category'], 'test');
    });

    test('should create MenuItemModel from entity correctly', () {
      // Arrange
      const entity = MenuItemModel(
        id: '1',
        title: 'Test Menu',
        description: 'Test Description',
        icon: 'test_icon',
        route: '/test-route',
        requiredPermissions: ['admin', 'user'],
        isEnabled: true,
        sortOrder: 1,
        category: 'test',
      );

      // Act
      final result = MenuItemModel.fromEntity(entity);

      // Assert
      expect(result.id, entity.id);
      expect(result.title, entity.title);
      expect(result.description, entity.description);
      expect(result.icon, entity.icon);
      expect(result.route, entity.route);
      expect(result.requiredPermissions, entity.requiredPermissions);
      expect(result.isEnabled, entity.isEnabled);
      expect(result.sortOrder, entity.sortOrder);
      expect(result.category, entity.category);
    });

    test('should convert to entity correctly', () {
      // Arrange
      const model = MenuItemModel(
        id: '1',
        title: 'Test Menu',
        description: 'Test Description',
        icon: 'test_icon',
        route: '/test-route',
        requiredPermissions: ['admin', 'user'],
        isEnabled: true,
        sortOrder: 1,
        category: 'test',
      );

      // Act
      final result = model.toEntity();

      // Assert
      expect(result.id, model.id);
      expect(result.title, model.title);
      expect(result.description, model.description);
      expect(result.icon, model.icon);
      expect(result.route, model.route);
      expect(result.requiredPermissions, model.requiredPermissions);
      expect(result.isEnabled, model.isEnabled);
      expect(result.sortOrder, model.sortOrder);
      expect(result.category, model.category);
    });

    test('getDefaultMenuItems should include brand menu item', () {
      // Act
      final menuItems = MenuItemModel.getDefaultMenuItems();

      // Assert
      expect(menuItems.isNotEmpty, true);

      // Find the brand menu item
      final brandMenuItem = menuItems.firstWhere(
        (item) => item.id == '2',
        orElse: () => throw Exception('Brand menu item not found'),
      );

      // Verify brand menu item properties
      expect(brandMenuItem.title, 'Brand');
      expect(brandMenuItem.description, 'Kelola brand dan cabang');
      expect(brandMenuItem.icon, 'business');
      expect(brandMenuItem.route, '/brand-selection');
      expect(brandMenuItem.category, 'management');
      expect(brandMenuItem.sortOrder, 2);
      expect(brandMenuItem.isEnabled, true);
    });

    test('getDefaultMenuItems should maintain correct order after adding brand', () {
      // Act
      final menuItems = MenuItemModel.getDefaultMenuItems();

      // Assert
      expect(menuItems.length, 9); // Should have 9 items after adding brand

      // Verify the order is correct
      expect(menuItems[0].id, '1'); // Dashboard
      expect(menuItems[1].id, '2'); // Brand
      expect(menuItems[2].id, '3'); // Pesanan
      expect(menuItems[3].id, '4'); // Produk
      expect(menuItems[4].id, '5'); // Pelanggan
      expect(menuItems[5].id, '6'); // Laporan
      expect(menuItems[6].id, '7'); // Keuangan
      expect(menuItems[7].id, '8'); // Pengaturan
      expect(menuItems[8].id, '9'); // Notifikasi
    });
  });
}