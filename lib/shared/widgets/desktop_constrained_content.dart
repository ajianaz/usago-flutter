// File: lib/shared/widgets/desktop_constrained_content.dart
import 'package:flutter/material.dart';

/// Desktop Constrained Content Widget
///
/// Constrains desktop content to tablet-portrait width (768px) and centers it horizontally.
/// This is the key component for implementing mobile-first responsive strategy
/// where desktop views mirror tablet layouts with width constraints.
class DesktopConstrainedContent extends StatelessWidget {
  final Widget child;
  final bool? applyPadding;

  const DesktopConstrainedContent({
    Key? key,
    required this.child,
    this.applyPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 768),
        child: applyPadding == true
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: child,
              )
            : child,
      ),
    );
  }
}