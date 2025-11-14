// File: lib/shared/widgets/responsive_layout.dart
import 'package:flutter/material.dart';
import 'responsive_builder.dart';

/// Common responsive layout patterns
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceType.desktop:
            return desktop ?? tablet ?? mobile;
          case DeviceType.tablet:
            return tablet ?? mobile;
          case DeviceType.mobile:
            return mobile;
        }
      },
    );
  }
}

/// Responsive row layout
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final List<int>? breakpoints;
  final CrossAxisAlignment alignment;
  final MainAxisAlignment mainAxisAlignment;

  const ResponsiveRow({
    Key? key,
    required this.children,
    this.breakpoints,
    this.alignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        int crossAxisCount = _getCrossAxisCount(deviceType);

        return Column(
          children: [
            for (int i = 0; i < children.length; i += crossAxisCount)
              Row(
                mainAxisAlignment: mainAxisAlignment,
                crossAxisAlignment: alignment,
                children: children
                    .skip(i)
                    .take(crossAxisCount)
                    .expand((child) => [
                      Expanded(child: child),
                      if (children.indexOf(child) < i + crossAxisCount - 1)
                        const SizedBox(width: 16),
                    ])
                    .toList(),
              ),
          ],
        );
      },
    );
  }

  int _getCrossAxisCount(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.desktop:
        return breakpoints?[2] ?? 3;
      case DeviceType.tablet:
        return breakpoints?[1] ?? 2;
      case DeviceType.mobile:
        return breakpoints?[0] ?? 1;
    }
  }
}
