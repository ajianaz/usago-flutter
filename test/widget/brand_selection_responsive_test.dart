import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usago/features/brand/presentation/pages/brand_selection_page.dart';
import 'package:usago/features/brand/presentation/bloc/brand_bloc.dart';
import 'package:usago/features/brand/presentation/bloc/brand_state.dart';
import 'package:usago/features/brand/domain/entities/brand.dart';

void main() {
  group('Brand Selection Page Responsive Tests', () {
    late BrandBloc mockBrandBloc;

    setUp(() {
      mockBrandBloc = MockBrandBloc();
    });

    testWidgets('Mobile layout renders correctly', (WidgetTester tester) async {
      // Arrange
      final brands = [
        Brand(
          id: '1',
          name: 'Test Brand 1',
          slug: 'test-brand-1',
          ownerId: 'user1',
          description: 'Test Description',
          businessType: 'SERVICE',
          settings: {},
          timezone: 'UTC',
          currency: 'USD',
          subscriptionTier: 'BASIC',
          subscriptionStatus: 'ACTIVE',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now(),
        ),
      ];

      // Mock the state stream
      final streamController = StreamController<BrandState>();
      when(() => mockBrandBloc.stream).thenAnswer((_) => streamController.stream);
      when(() => mockBrandBloc.state).thenReturn(
        BrandLoaded(
          userBrands: brands,
          accessibleBrands: [],
          activeBrand: brands.first,
        ),
      );

      // Set mobile screen size
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BrandBloc>.value(
            value: mockBrandBloc,
            child: const BrandSelectionPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BrandSelectionPage), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);

      // Verify mobile grid has 2 columns
      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(2));

      streamController.close();
    });

    testWidgets('Tablet layout renders correctly', (WidgetTester tester) async {
      // Arrange
      final brands = [
        Brand(
          id: '1',
          name: 'Test Brand 1',
          slug: 'test-brand-1',
          ownerId: 'user1',
          description: 'Test Description',
          businessType: 'SERVICE',
          settings: {},
          timezone: 'UTC',
          currency: 'USD',
          subscriptionTier: 'BASIC',
          subscriptionStatus: 'ACTIVE',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now(),
        ),
      ];

      // Mock the state stream
      final streamController = StreamController<BrandState>();
      when(() => mockBrandBloc.stream).thenAnswer((_) => streamController.stream);
      when(() => mockBrandBloc.state).thenReturn(
        BrandLoaded(
          userBrands: brands,
          accessibleBrands: [],
          activeBrand: brands.first,
        ),
      );

      // Set tablet screen size
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BrandBloc>.value(
            value: mockBrandBloc,
            child: const BrandSelectionPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BrandSelectionPage), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);

      // Verify tablet grid has 3 columns
      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(3));

      streamController.close();
    });

    testWidgets('Desktop layout renders correctly with constraint', (WidgetTester tester) async {
      // Arrange
      final brands = [
        Brand(
          id: '1',
          name: 'Test Brand 1',
          slug: 'test-brand-1',
          ownerId: 'user1',
          description: 'Test Description',
          businessType: 'SERVICE',
          settings: {},
          timezone: 'UTC',
          currency: 'USD',
          subscriptionTier: 'BASIC',
          subscriptionStatus: 'ACTIVE',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now(),
        ),
      ];

      // Mock the state stream
      final streamController = StreamController<BrandState>();
      when(() => mockBrandBloc.stream).thenAnswer((_) => streamController.stream);
      when(() => mockBrandBloc.state).thenReturn(
        BrandLoaded(
          userBrands: brands,
          accessibleBrands: [],
          activeBrand: brands.first,
        ),
      );

      // Set desktop screen size
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      tester.binding.window.physicalSizeTestValue = const Size(1200, 800);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BrandBloc>.value(
            value: mockBrandBloc,
            child: const BrandSelectionPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(BrandSelectionPage), findsOneWidget);
      expect(find.byType(GridView), findsOneWidget);

      // Verify desktop grid has 3 columns
      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(3));

      streamController.close();
    });

    testWidgets('Search bar renders consistently across screen sizes', (WidgetTester tester) async {
      // Arrange
      final brands = [
        Brand(
          id: '1',
          name: 'Test Brand 1',
          slug: 'test-brand-1',
          ownerId: 'user1',
          description: 'Test Description',
          businessType: 'SERVICE',
          settings: {},
          timezone: 'UTC',
          currency: 'USD',
          subscriptionTier: 'BASIC',
          subscriptionStatus: 'ACTIVE',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now(),
        ),
      ];

      // Mock the state stream
      final streamController = StreamController<BrandState>();
      when(() => mockBrandBloc.stream).thenAnswer((_) => streamController.stream);
      when(() => mockBrandBloc.state).thenReturn(
        BrandLoaded(
          userBrands: brands,
          accessibleBrands: [],
          activeBrand: brands.first,
        ),
      );

      // Test mobile
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<BrandBloc>.value(
            value: mockBrandBloc,
            child: const BrandSelectionPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);

      // Test tablet
      tester.binding.window.physicalSizeTestValue = const Size(800, 1200);
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);

      // Test desktop
      tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);

      streamController.close();
    });
  });
}

// Mock BrandBloc for testing
class MockBrandBloc extends Mock implements BrandBloc {}