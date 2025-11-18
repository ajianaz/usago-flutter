import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:usago/features/brand/domain/entities/brand.dart';
import 'package:usago/features/brand/presentation/bloc/brand_bloc.dart';
import 'package:usago/features/brand/presentation/bloc/brand_state.dart';
import 'package:usago/features/brand/presentation/pages/brand_transfer_page.dart';

import 'brand_transfer_page_test.mocks.dart';

/// Integration test to verify BrandTransferPage uses BrandBloc from context
/// rather than creating a new instance
void main() {
  group('BrandTransferPage Integration', () {
    late MockBrandBloc mockBrandBloc;
    late Brand testBrand;

    setUp(() {
      mockBrandBloc = MockBrandBloc();
      testBrand = Brand(
        id: 'test-brand-id',
        name: 'Test Brand',
        slug: 'test-brand',
        ownerId: 'test-owner-id',
        businessType: 'retail',
        settings: {},
        timezone: 'Asia/Jakarta',
        currency: 'IDR',
        subscriptionTier: 'basic',
        subscriptionStatus: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Stub the stream property to avoid MissingStubError
      when(mockBrandBloc.stream).thenAnswer((_) => Stream.empty());
      when(mockBrandBloc.state).thenReturn(BrandInitial());
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<BrandBloc>.value(
          value: mockBrandBloc,
          child: BrandTransferPage(brand: testBrand),
        ),
      );
    }

    testWidgets('should use BrandBloc from context without creating new instance', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify that the page can access the BrandBloc from context
      final brandBloc = tester.element(find.byType(BrandTransferPage)).read<BrandBloc>();

      // Verify it's the same instance we provided
      expect(brandBloc, same(mockBrandBloc));

      // Verify the page renders correctly
      expect(find.byType(BrandTransferPage), findsOneWidget);
      expect(find.text('Transfer Kepemilikanan Brand'), findsOneWidget);
    });

    testWidgets('should not have BlocProvider wrapper in widget tree', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find all BlocProvider widgets in the tree
      final blocProviders = find.byType(BlocProvider<BrandBloc>);

      // We should find exactly 2 BlocProvider widgets:
      // 1. The one we provide at the top level
      // 2. The one created by BlocResponsiveLayout (but it uses context.read)
      expect(blocProviders, findsNWidgets(2));

      // Verify the BrandBloc from context is still our mock
      final contextBrandBloc = tester.element(find.byType(BrandTransferPage)).read<BrandBloc>();
      expect(contextBrandBloc, same(mockBrandBloc));
    });
  });
}