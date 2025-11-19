import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/brand_management/brand_management_bloc.dart';
import '../bloc/brand_management/brand_management_state.dart';
import '../bloc/brand_list/brand_list_bloc.dart';
import '../bloc/brand_list/brand_list_state.dart';
import '../bloc/brand_search/brand_search_bloc.dart';
import '../bloc/brand_search/brand_search_state.dart';
import '../bloc/brand_switching/brand_switching_bloc.dart';
import '../bloc/brand_switching/brand_switching_state.dart';
import '../bloc/brand_invitation/brand_invitation_bloc.dart';
import '../bloc/brand_invitation/brand_invitation_state.dart';
import '../bloc/brand_bloc.dart';
import '../bloc/brand_state.dart';

// GetIt instance
final getIt = GetIt.instance;

/// Brand BLoC Provider Helper
///
/// Widget ini menyediakan semua BLoCs yang terkait dengan brand feature
/// dalam satu MultiBlocProvider untuk kemudahan penggunaan.
///
/// Penggunaan:
/// ```dart
/// BrandBlocProvider(
///   child: YourWidget(),
/// )
/// ```
///
/// Kemudian di dalam widget tree, Anda bisa mengakses BLoCs dengan:
/// ```dart
/// context.read<BrandManagementBloc>()
/// context.watch<BrandListBloc>()
/// // dll.
/// ```
class BrandBlocProvider extends StatelessWidget {
  final Widget child;

  const BrandBlocProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Brand Management BLoC - untuk operasi CRUD brand
        BlocProvider<BrandManagementBloc>(
          create: (context) => getIt<BrandManagementBloc>(),
        ),

        // Brand List BLoC - untuk mengelola daftar brand
        BlocProvider<BrandListBloc>(
          create: (context) => getIt<BrandListBloc>(),
        ),

        // Brand Search BLoC - untuk fungsi pencarian brand
        BlocProvider<BrandSearchBloc>(
          create: (context) => getIt<BrandSearchBloc>(),
        ),

        // Brand Switching BLoC - untuk operasi switch active brand
        BlocProvider<BrandSwitchingBloc>(
          create: (context) => getIt<BrandSwitchingBloc>(),
        ),

        // Brand Invitation BLoC - untuk operasi invitation
        BlocProvider<BrandInvitationBloc>(
          create: (context) => getIt<BrandInvitationBloc>(),
        ),

        // Legacy BrandBloc (deprecated) - untuk backward compatibility
        BlocProvider<BrandBloc>(
          create: (context) => getIt<BrandBloc>(),
        ),
      ],
      child: child,
    );
  }
}

/// Brand BLoC Provider untuk use case spesifik
///
/// Provider ini hanya menyediakan BLoCs yang dibutuhkan untuk use case tertentu
/// untuk menghemat resource dan meningkatkan performance.
class SpecificBrandBlocProvider extends StatelessWidget {
  final Widget child;
  final List<Type> blocs;

  const SpecificBrandBlocProvider({
    Key? key,
    required this.child,
    required this.blocs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providers = <BlocProvider>[];

    // Tambahkan BLoCs yang dibutuhkan saja
    for (final blocType in blocs) {
      switch (blocType) {
        case BrandManagementBloc:
          providers.add(BlocProvider<BrandManagementBloc>(
            create: (context) => getIt<BrandManagementBloc>(),
          ));
          break;
        case BrandListBloc:
          providers.add(BlocProvider<BrandListBloc>(
            create: (context) => getIt<BrandListBloc>(),
          ));
          break;
        case BrandSearchBloc:
          providers.add(BlocProvider<BrandSearchBloc>(
            create: (context) => getIt<BrandSearchBloc>(),
          ));
          break;
        case BrandSwitchingBloc:
          providers.add(BlocProvider<BrandSwitchingBloc>(
            create: (context) => getIt<BrandSwitchingBloc>(),
          ));
          break;
        case BrandInvitationBloc:
          providers.add(BlocProvider<BrandInvitationBloc>(
            create: (context) => getIt<BrandInvitationBloc>(),
          ));
          break;
        case BrandBloc:
          providers.add(BlocProvider<BrandBloc>(
            create: (context) => getIt<BrandBloc>(),
          ));
          break;
      }
    }

    return MultiBlocProvider(
      providers: providers,
      child: child,
    );
  }
}

/// Extension untuk memudahkan akses BLoCs
extension BrandBlocContext on BuildContext {
  /// Get Brand Management BLoC
  BrandManagementBloc get brandManagement => read<BrandManagementBloc>();

  /// Watch Brand Management BLoC
  BrandManagementState get watchBrandManagement => watch<BrandManagementBloc>().state;

  /// Get Brand List BLoC
  BrandListBloc get brandList => read<BrandListBloc>();

  /// Watch Brand List BLoC
  BrandListState get watchBrandList => watch<BrandListBloc>().state;

  /// Get Brand Search BLoC
  BrandSearchBloc get brandSearch => read<BrandSearchBloc>();

  /// Watch Brand Search BLoC
  BrandSearchState get watchBrandSearch => watch<BrandSearchBloc>().state;

  /// Get Brand Switching BLoC
  BrandSwitchingBloc get brandSwitching => read<BrandSwitchingBloc>();

  /// Watch Brand Switching BLoC
  BrandSwitchingState get watchBrandSwitching => watch<BrandSwitchingBloc>().state;

  /// Get Brand Invitation BLoC
  BrandInvitationBloc get brandInvitation => read<BrandInvitationBloc>();

  /// Watch Brand Invitation BLoC
  BrandInvitationState get watchBrandInvitation => watch<BrandInvitationBloc>().state;

  /// Get Legacy Brand BLoC
  BrandBloc get brandLegacy => read<BrandBloc>();

  /// Watch Legacy Brand BLoC
  BrandState get watchBrandLegacy => watch<BrandBloc>().state;
}

/// Helper untuk membuat provider dengan BLoCs yang sering digunakan bersama
class CommonBrandBlocProvider extends StatelessWidget {
  final Widget child;

  const CommonBrandBlocProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpecificBrandBlocProvider(
      blocs: [
        BrandListBloc,
        BrandSwitchingBloc,
      ],
      child: child,
    );
  }
}

/// Helper untuk membuat provider dengan BLoCs untuk brand management
class BrandManagementBlocProvider extends StatelessWidget {
  final Widget child;

  const BrandManagementBlocProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpecificBrandBlocProvider(
      blocs: [
        BrandManagementBloc,
        BrandListBloc,
      ],
      child: child,
    );
  }
}

/// Helper untuk membuat provider dengan BLoCs untuk invitation management
class BrandInvitationBlocProvider extends StatelessWidget {
  final Widget child;

  const BrandInvitationBlocProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpecificBrandBlocProvider(
      blocs: [
        BrandInvitationBloc,
        BrandListBloc,
      ],
      child: child,
    );
  }
}

/// Helper untuk membuat provider dengan BLoCs untuk search functionality
class BrandSearchBlocProvider extends StatelessWidget {
  final Widget child;

  const BrandSearchBlocProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpecificBrandBlocProvider(
      blocs: [
        BrandSearchBloc,
        BrandListBloc,
      ],
      child: child,
    );
  }
}