// File: lib/shared/widgets/responsive_builder.dart
import 'package:flutter/material.dart';
import '../../core/extensions/context_extension.dart';

/// Responsive builder widget that adapts to different screen sizes
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder(context, _getDeviceType(context));
  }

  DeviceType _getDeviceType(BuildContext context) {
    if (context.isDesktop) return DeviceType.desktop;
    if (context.isTablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }
}

/// Device type enum
enum DeviceType { mobile, tablet, desktop }
