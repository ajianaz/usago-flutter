// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [BrandInvitationListPage]
class BrandInvitationListRoute
    extends PageRouteInfo<BrandInvitationListRouteArgs> {
  BrandInvitationListRoute({
    Key? key,
    required Brand brand,
    List<PageRouteInfo>? children,
  }) : super(
          BrandInvitationListRoute.name,
          args: BrandInvitationListRouteArgs(
            key: key,
            brand: brand,
          ),
          initialChildren: children,
        );

  static const String name = 'BrandInvitationListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BrandInvitationListRouteArgs>();
      return BrandInvitationListPage(
        key: args.key,
        brand: args.brand,
      );
    },
  );
}

class BrandInvitationListRouteArgs {
  const BrandInvitationListRouteArgs({
    this.key,
    required this.brand,
  });

  final Key? key;

  final Brand brand;

  @override
  String toString() {
    return 'BrandInvitationListRouteArgs{key: $key, brand: $brand}';
  }
}

/// generated route for
/// [BrandSelectionPage]
class BrandSelectionRoute extends PageRouteInfo<void> {
  const BrandSelectionRoute({List<PageRouteInfo>? children})
      : super(
          BrandSelectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'BrandSelectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BrandSelectionPage();
    },
  );
}

/// generated route for
/// [BrandStatsPage]
class BrandStatsRoute extends PageRouteInfo<BrandStatsRouteArgs> {
  BrandStatsRoute({
    Key? key,
    required Brand brand,
    List<PageRouteInfo>? children,
  }) : super(
          BrandStatsRoute.name,
          args: BrandStatsRouteArgs(
            key: key,
            brand: brand,
          ),
          initialChildren: children,
        );

  static const String name = 'BrandStatsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BrandStatsRouteArgs>();
      return BrandStatsPage(
        key: args.key,
        brand: args.brand,
      );
    },
  );
}

class BrandStatsRouteArgs {
  const BrandStatsRouteArgs({
    this.key,
    required this.brand,
  });

  final Key? key;

  final Brand brand;

  @override
  String toString() {
    return 'BrandStatsRouteArgs{key: $key, brand: $brand}';
  }
}

/// generated route for
/// [BrandTransferPage]
class BrandTransferRoute extends PageRouteInfo<BrandTransferRouteArgs> {
  BrandTransferRoute({
    Key? key,
    required Brand brand,
    List<PageRouteInfo>? children,
  }) : super(
          BrandTransferRoute.name,
          args: BrandTransferRouteArgs(
            key: key,
            brand: brand,
          ),
          initialChildren: children,
        );

  static const String name = 'BrandTransferRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BrandTransferRouteArgs>();
      return BrandTransferPage(
        key: args.key,
        brand: args.brand,
      );
    },
  );
}

class BrandTransferRouteArgs {
  const BrandTransferRouteArgs({
    this.key,
    required this.brand,
  });

  final Key? key;

  final Brand brand;

  @override
  String toString() {
    return 'BrandTransferRouteArgs{key: $key, brand: $brand}';
  }
}

/// generated route for
/// [CreateBrandPage]
class CreateBrandRoute extends PageRouteInfo<void> {
  const CreateBrandRoute({List<PageRouteInfo>? children})
      : super(
          CreateBrandRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateBrandRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateBrandPage();
    },
  );
}

/// generated route for
/// [EditBrandPage]
class EditBrandRoute extends PageRouteInfo<EditBrandRouteArgs> {
  EditBrandRoute({
    Key? key,
    required String brandId,
    List<PageRouteInfo>? children,
  }) : super(
          EditBrandRoute.name,
          args: EditBrandRouteArgs(
            key: key,
            brandId: brandId,
          ),
          initialChildren: children,
        );

  static const String name = 'EditBrandRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditBrandRouteArgs>();
      return EditBrandPage(
        key: args.key,
        brandId: args.brandId,
      );
    },
  );
}

class EditBrandRouteArgs {
  const EditBrandRouteArgs({
    this.key,
    required this.brandId,
  });

  final Key? key;

  final String brandId;

  @override
  String toString() {
    return 'EditBrandRouteArgs{key: $key, brandId: $brandId}';
  }
}

/// generated route for
/// [ForgotPasswordPage]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForgotPasswordPage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [RegisterPage]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterPage();
    },
  );
}
