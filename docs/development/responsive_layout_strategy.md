# Mobile-First Responsive Layout Strategy

## Overview

This document outlines the mobile-first responsive layout strategy for the USAGO Flutter application. The primary focus is to perfect the UI for mobile and tablet viewports, with desktop implementation being a secondary outcome that constrains content to tablet-portrait width and centers it horizontally.

## Core Principles

### 1. Mobile-First Vertical Layout Development
- Design and optimize for mobile viewports first (< 600dp) using vertical Column layouts
- Tablet viewports (600dp - 1200dp) follow the SAME vertical Column layout as mobile
- Tablet only enhances spacing, padding, and sizing - does NOT change layout structure
- Constrain desktop viewports (≥ 1200dp) to tablet-portrait width (768px) and center horizontally

### 2. Unified Vertical Design System
- Mobile and tablet both use vertical Column layouts with identical structure
- Desktop view directly mirrors the mobile and tablet vertical experience
- No special desktop layouts - just constrained and centered versions of the vertical tablet layout
- Consistent spacing, typography, and interaction patterns across all devices

### 3. BlocResponsiveLayout Foundation
- All pages must use `BlocResponsiveLayout` as the foundational widget
- Leverage existing `ResponsiveBuilder` for device type detection
- Maintain BLoC state management integration

## Implementation Guidelines

### Device Type Breakpoints

```dart
// From lib/core/extensions/context_extension.dart
bool get isMobile => screenWidth < 600;        // < 600dp
bool get isTablet => screenWidth >= 600 && screenWidth < 1200;  // 600dp - 1200dp
bool get isDesktop => screenWidth >= 1200;       // ≥ 1200dp
```

### Desktop Constraint Pattern

For desktop viewports, implement the following pattern:

```dart
// Desktop content should be constrained to 768px and centered
class DesktopConstrainedContent extends StatelessWidget {
  final Widget child;

  const DesktopConstrainedContent({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 768),
        child: child,
      ),
    );
  }
}
```

### Required Widget Structure

All pages must follow this structure:

```dart
@RoutePage()
class ExamplePage extends StatelessWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocResponsiveLayout<ExampleBloc, ExampleState>(
      builder: (context, bloc, state, deviceType) {
        return _buildContent(context, deviceType);
      },
      listener: (context, state) {
        // Handle state changes
      },
    );
  }

  Widget _buildContent(BuildContext context, DeviceType deviceType) {
    return Scaffold(
      appBar: AppBar(...),
      body: _buildBody(context, deviceType),
    );
  }

  Widget _buildBody(BuildContext context, DeviceType deviceType) {
    final content = _buildUnconstrainedContent(context, deviceType);

    // Apply desktop constraint
    if (deviceType == DeviceType.desktop) {
      return DesktopConstrainedContent(child: content);
    }

    return content;
  }
}
```

## Responsive Design Patterns

### 1. Grid Layouts

```dart
// Mobile: 2 columns, Tablet: 3 columns, Desktop: 3 columns (constrained)
final crossAxisCount = deviceType == DeviceType.mobile ? 2 : 3;
final childAspectRatio = deviceType == DeviceType.mobile ? 1.2 : 1.0;

GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: crossAxisCount,
    mainAxisSpacing: _getSpacing(deviceType),
    crossAxisSpacing: _getSpacing(deviceType),
    childAspectRatio: childAspectRatio,
  ),
  // ...
);
```

### 2. Typography Scaling

```dart
// Use responsive font sizes from context extension
Text(
  'Title',
  style: AppTextStyles.headline5.copyWith(
    fontSize: context.responsiveFontSize(20),
  ),
);
```

### 3. Spacing and Padding

```dart
// Use responsive spacing from context extension
Container(
  padding: context.responsivePadding,
  margin: context.responsiveMargin,
  child: child,
);
```

### 4. Form Layouts

```dart
// Forms should use single column on mobile AND tablet
// Desktop gets constrained width instead of multi-column
Widget _buildForm(BuildContext context, DeviceType deviceType) {
  final content = SingleChildScrollView(
    padding: EdgeInsets.all(_getPadding(deviceType)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Form fields - same vertical layout for mobile AND tablet
      ],
    ),
  );

  return deviceType == DeviceType.desktop
      ? DesktopConstrainedContent(child: content)
      : content;
}
```

## Component Guidelines

### BrandCard Widget
- Mobile: Compact vertical layout with essential information
- Tablet: Same vertical layout with enhanced spacing and sizing
- Desktop: Same vertical layout constrained to 768px maximum width

### BrandSelector Widget
- Mobile: Bottom sheet or dropdown with vertical layout
- Tablet: Same vertical selector with enhanced spacing and sizing
- Desktop: Same vertical layout constrained to 768px maximum width

### CreateBrandForm Widget
- Single column vertical layout on mobile AND tablet
- Tablet only enhances spacing, padding, and sizing - maintains identical vertical structure
- Desktop: Constrained vertical tablet layout to 768px maximum width

## Migration Strategy

### Phase 1: Foundation
1. Create `DesktopConstrainedContent` helper widget
2. Update all pages to use `BlocResponsiveLayout`
3. Implement desktop width constraints

### Phase 2: Component Updates
1. Refactor individual widgets to use responsive patterns
2. Ensure consistent spacing and typography
3. Test across all device types

### Phase 3: Optimization
1. Performance testing
2. Accessibility validation
3. Cross-platform testing

## Testing Guidelines

### Device Testing
- Test on mobile (320dp - 600dp)
- Test on tablet (600dp - 1200dp)
- Test on desktop (≥ 1200dp) - verify 768px constraint

### Visual Testing
- Verify content is centered on desktop
- Check that no horizontal scrolling occurs
- Ensure touch targets meet minimum size requirements

### Functional Testing
- Verify all interactions work consistently
- Test form validation and submission
- Check navigation patterns

## Common Pitfalls to Avoid

1. **Don't create special desktop layouts** - Use constrained vertical tablet layouts
2. **Don't create horizontal tablet layouts** - Tablet must use the same vertical Column layout as mobile
3. **Don't use hardcoded breakpoints** - Use the `DeviceType` enum
4. **Don't forget to constrain desktop content** - Always apply 768px max width to vertical layout
5. **Don't mix responsive patterns** - Standardize on `BlocResponsiveLayout`
6. **Don't ignore accessibility** - Ensure touch targets work on all devices

## Code Examples

### Complete Page Example

```dart
@RoutePage()
class BrandSelectionPage extends StatelessWidget {
  const BrandSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocResponsiveLayout<BrandBloc, BrandState>(
      builder: (context, bloc, state, deviceType) {
        return _BrandSelectionView(deviceType: deviceType);
      },
      listener: (context, state) {
        if (state is BrandError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
    );
  }
}

class _BrandSelectionView extends StatelessWidget {
  final DeviceType deviceType;

  const _BrandSelectionView({required this.deviceType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Brand'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final content = _buildUnconstrainedContent(context);

    if (deviceType == DeviceType.desktop) {
      return DesktopConstrainedContent(child: content);
    }

    return content;
  }

  Widget _buildUnconstrainedContent(BuildContext context) {
    return BlocBuilder<BrandBloc, BrandState>(
      builder: (context, state) {
        if (state is BrandLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is BrandLoaded) {
          return _buildBrandGrid(context, state.brands);
        }

        return _buildEmptyState(context);
      },
    );
  }
}
```

## Conclusion

This mobile-first vertical layout strategy ensures a consistent, optimized experience across all device types while minimizing development complexity. By using the same vertical Column layout for both mobile and tablet (with tablet only enhancing spacing and sizing), and constraining desktop to the tablet-portrait width, we maintain design consistency without creating separate layout structures.

The key principles are:
- Mobile and tablet both use vertical Column layouts with identical structure
- Tablet only differs in enhanced spacing, padding, and sizing - never in layout structure
- Desktop constrains the vertical tablet layout to 768px width and centers it
- No horizontal Row layouts should be used for tablet auth pages or any other components

This approach ensures future developers can implement responsive designs without special configuration - just follow the mobile-first vertical pattern and enhance spacing for tablet.