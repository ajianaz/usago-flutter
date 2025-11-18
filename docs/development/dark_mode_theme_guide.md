# Dark Mode Theme System Guide

This guide explains how to use the enhanced theme system that supports dark mode in the USAGO Flutter application.

## Overview

The theme system has been enhanced to provide comprehensive dark mode support with:

1. **Dynamic Color Selection**: Colors automatically adapt based on theme brightness
2. **Helper Methods**: Easy-to-use methods for getting theme-appropriate colors
3. **Backward Compatibility**: Existing code continues to work without changes
4. **Material 3 Compliance**: Uses modern Material Design 3 theming approach

## AppColors Enhancements

### New Dark Mode Colors

The `AppColors` class now includes dedicated dark mode color constants:

```dart
// Dark mode colors
static const Color darkBackground = Color(0xFF121212);
static const Color darkSurface = Color(0xFF1E1E1E);
static const Color darkTextPrimary = Color(0xFFFFFFFF);
static const Color darkTextSecondary = Color(0xFFE0E0E0);
static const Color darkTextDisabled = Color(0xFF666666);
static const Color darkBorder = Color(0xFF333333);
```

### Helper Methods

Use these helper methods to get colors that automatically adapt to the current theme:

```dart
// Get colors based on current theme
Color backgroundColor = AppColors.getBackground(context);
Color surfaceColor = AppColors.getSurface(context);
Color textColor = AppColors.getTextPrimary(context);
Color secondaryTextColor = AppColors.getTextSecondary(context);
Color borderColor = AppColors.getBorder(context);
```

### Generic Color Helper

For custom color selection:

```dart
Color adaptiveColor = AppColors.getColorForBrightness(
  context: context,
  lightColor: Colors.blue,
  darkColor: Colors.lightBlue,
);
```

## AppTextStyles Enhancements

### Dynamic Text Styles

New dynamic methods that adapt to theme brightness:

```dart
// Dynamic text styles (recommended for new code)
Text(
  'Title',
  style: AppTextStyles.headline1Dynamic(context), // Automatically adapts to theme
),

Text(
  'Body text',
  style: AppTextStyles.bodyMediumDynamic(context), // Automatically adapts to theme
),

Text(
  'Caption',
  style: AppTextStyles.captionDynamic(context), // Automatically adapts to theme
),
```

### Static Text Styles (Backward Compatible)

Existing static methods continue to work:

```dart
// Static text styles (existing code continues to work)
Text(
  'Title',
  style: AppTextStyles.headline1, // Uses light mode colors
),
```

### Dynamic Style Helper

Convert any static style to dynamic:

```dart
TextStyle dynamicStyle = AppTextStyles.getDynamicTextStyle(
  context,
  AppTextStyles.headline1, // Static style
);
```

## Usage Examples

### Basic Widget with Dark Mode Support

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.getSurface(context),
      child: Column(
        children: [
          Text(
            'Dynamic Title',
            style: AppTextStyles.headline4Dynamic(context),
          ),
          Text(
            'Dynamic Body',
            style: AppTextStyles.bodyMediumDynamic(context),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.getBorder(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Theme-Aware Custom Widget

```dart
class ThemeAwareCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const ThemeAwareCard({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.getSurface(context),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: AppColors.getBorder(context),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.headline6Dynamic(context),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodyMediumDynamic(context),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Migration Guide

### For New Code

Always use the dynamic methods:

```dart
// ✅ Recommended - Dynamic
style: AppTextStyles.headline1Dynamic(context)
color: AppColors.getTextPrimary(context)

// ❌ Avoid - Static (unless specifically needed)
style: AppTextStyles.headline1
color: AppColors.textPrimary
```

### For Existing Code

Existing code continues to work without changes, but consider upgrading:

```dart
// Before (static)
Text(
  'Title',
  style: AppTextStyles.headline1,
),

// After (dynamic)
Text(
  'Title',
  style: AppTextStyles.headline1Dynamic(context),
),
```

## Theme Configuration

The theme system is configured in `lib/shared/themes/theme.dart`:

- **Light Theme**: Uses `AppColors.light*` color variants
- **Dark Theme**: Uses `AppColors.dark*` color variants
- **Material 3**: Compliant with Material Design 3 specifications
- **ColorScheme**: Properly configured for both themes

## Testing

Theme functionality is tested in `test/shared/themes/theme_test.dart`:

- Color helper methods return correct colors for each theme
- Dynamic text styles adapt to theme brightness
- Theme color schemes are properly configured
- Backward compatibility is maintained

## Best Practices

1. **Use Dynamic Methods**: Always prefer `AppTextStyles.method(context)` over static methods
2. **Color Helpers**: Use `AppColors.get*()` methods instead of direct color constants
3. **Theme Awareness**: Design widgets with both light and dark modes in mind
4. **Contrast**: Ensure text has proper contrast in both themes
5. **Testing**: Test widgets in both light and dark themes

## Theme Switching

Theme switching is handled by the existing `InstantThemeHelper` and `ThemeService`:

```dart
// Change theme
await InstantThemeHelper.instance.changeTheme(ThemeMode.dark);

// Toggle theme
await InstantThemeHelper.instance.toggleTheme();

// Cycle through themes
await InstantThemeHelper.instance.cycleTheme();
```

## Troubleshooting

### Colors Not Updating

Ensure you're using the dynamic methods:

```dart
// ✅ Correct - Updates with theme
color: AppColors.getSurface(context)

// ❌ Incorrect - Static color
color: AppColors.surface
```

### Text Not Adapting

Use dynamic text styles:

```dart
// ✅ Correct - Adapts to theme
style: AppTextStyles.bodyMediumDynamic(context)

// ❌ Incorrect - Static style
style: AppTextStyles.bodyMedium
```

### Build Context Issues

Make sure you have access to `BuildContext` when using dynamic methods:

```dart
@override
Widget build(BuildContext context) {
  // Context is available here
  return Container(
    color: AppColors.getSurface(context),
  );
}

## Brand Component Examples

The brand feature provides excellent examples of proper dark mode implementation. Below are real-world examples from the codebase.

### Brand Card Component

```dart
class BrandCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.getSurface(context),
      shadowColor: isActive
        ? AppColors.primary.withOpacity(0.3)
        : Theme.of(context).shadowColor.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isActive ? AppColors.primary : AppColors.getBorder(context),
          width: isActive ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            brand.displayName,
            style: AppTextStyles.headline5Dynamic(context).copyWith(
              color: isActive ? AppColors.primary : AppColors.getTextPrimary(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            brand.formattedBusinessType,
            style: AppTextStyles.captionDynamic(context).copyWith(
              color: AppColors.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Brand Form Component

```dart
class CreateBrandForm extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Text(
            'Buat Brand Baru',
            style: AppTextStyles.headline4Dynamic(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.md),

          // Dynamic text field
          AnimatedTextField(
            labelText: 'Nama Brand',
            style: AppTextStyles.inputTextDynamic(context),
            labelStyle: AppTextStyles.inputLabelDynamic(context),
            hintStyle: AppTextStyles.inputHintDynamic(context),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.getSurface(context),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.getBorder(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.getBorder(context)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),

          // Dynamic dropdown
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.getBorder(context)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBusinessType,
                dropdownColor: AppColors.getSurface(context),
                style: AppTextStyles.bodyMediumDynamic(context),
                items: _businessTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type['value'],
                    child: Text(
                      type['label']!,
                      style: AppTextStyles.bodyMediumDynamic(context),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBusinessType = value ?? 'SERVICE';
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Brand Stats Page with Cards

```dart
class BrandStatsPage extends StatelessWidget {
  Widget _buildStatsCard(BuildContext context, String title, String value) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.getBorder(context)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.12),
            blurRadius: UIConstants.elevationCard,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.headline6Dynamic(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: AppTextStyles.headline4Dynamic(context).copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
```

### Brand Selection Page with Search

```dart
class BrandSelectionPage extends StatelessWidget {
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusDefault),
        border: Border.all(color: AppColors.getBorder(context)),
      ),
      child: TextField(
        style: AppTextStyles.bodyMediumDynamic(context),
        decoration: InputDecoration(
          hintText: 'Cari brand...',
          hintStyle: AppTextStyles.bodyMediumDynamic(context).copyWith(
            color: AppColors.getTextDisabled(context),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.getTextSecondary(context)
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
```

## Advanced Techniques

### Conditional Opacity for Gradients

When using gradients in brand components, adjust opacity based on theme:

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        AppColors.primary.withValues(
          alpha: Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.1
        ),
        AppColors.primary.withValues(
          alpha: Theme.of(context).brightness == Brightness.dark ? 0.1 : 0.05
        ),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
)
```

### Theme-Aware Status Indicators

For status indicators that need to maintain visibility in both themes:

```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  decoration: BoxDecoration(
    color: _getStatusColor().withValues(
      alpha: Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.1
    ),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text(
    statusText,
    style: AppTextStyles.captionDynamic(context).copyWith(
      color: _getStatusColor(),
      fontWeight: FontWeight.w600,
    ),
  ),
)
```

### Dynamic Icon Colors

Ensure icons adapt to theme changes:

```dart
Icon(
  Icons.business_outlined,
  color: AppColors.getTextSecondary(context),
  size: UIConstants.fontSizeXXXLarge,
),
```

## Common Pitfalls and Solutions

### 1. Forgetting Context in Helper Methods

**Problem**: Using static methods without context
```dart
// ❌ Wrong
Text(
  'Title',
  style: AppTextStyles.headline5, // Static method
)
```

**Solution**: Always pass context to dynamic methods
```dart
// ✅ Correct
Text(
  'Title',
  style: AppTextStyles.headline5Dynamic(context), // Dynamic method
)
```

### 2. Hard-coded Border Colors

**Problem**: Using static border colors that don't adapt
```dart
// ❌ Wrong
Border.all(color: AppColors.border)
```

**Solution**: Use dynamic border colors
```dart
// ✅ Correct
Border.all(color: AppColors.getBorder(context))
```

### 3. Inconsistent Shadow Colors

**Problem**: Using black shadows in dark mode
```dart
// ❌ Wrong
BoxShadow(
  color: Colors.black.withOpacity(0.1),
  blurRadius: 4,
)
```

**Solution**: Use theme-aware shadows
```dart
// ✅ Correct
BoxShadow(
  color: Theme.of(context).shadowColor.withValues(alpha: 0.12),
  blurRadius: UIConstants.elevationCard,
  offset: const Offset(0, 2),
)
```

### 4. Missing Theme Updates in Dropdowns

**Problem**: Dropdowns not adapting to theme
```dart
// ❌ Wrong
DropdownButton(
  dropdownColor: Colors.white,
  style: TextStyle(color: Colors.black),
)
```

**Solution**: Use theme-aware dropdown styling
```dart
// ✅ Correct
DropdownButton(
  dropdownColor: AppColors.getSurface(context),
  style: AppTextStyles.bodyMediumDynamic(context),
)
```

## Testing Checklist for Dark Mode

### Visual Testing
- [ ] Verify all brand components render correctly in light mode
- [ ] Verify all brand components render correctly in dark mode
- [ ] Check text contrast ratios meet WCAG AA standards
- [ ] Verify border visibility in dark mode
- [ ] Test shadow appearance on dark backgrounds
- [ ] Check gradient visibility in both themes

### Functional Testing
- [ ] Test theme switching while on brand pages
- [ ] Verify form validation messages are visible in both themes
- [ ] Test interactive elements (buttons, dropdowns) in both themes
- [ ] Check popup menus and dialogs in dark mode
- [ ] Test search functionality in both themes
- [ ] Verify status indicators are visible in both themes

### Component-Specific Testing
- [ ] BrandCard: Test active/inactive states in both themes
- [ ] CreateBrandForm: Test all form fields in both themes
- [ ] BrandStatsPage: Verify statistics cards in both themes
- [ ] BrandSelectionPage: Test search and filter UI in both themes

### Accessibility Testing
- [ ] Verify WCAG contrast ratios for all text elements
- [ ] Test with screen readers in both themes
- [ ] Ensure focus indicators are visible in both themes
- [ ] Check color-only indicators have text alternatives

### Performance Testing
- [ ] Verify theme switching doesn't cause performance issues
- [ ] Test memory usage with theme changes
- [ ] Check for unnecessary widget rebuilds during theme changes

## Migration Guide for Existing Components

### Step 1: Replace Static Colors
```dart
// Before
color: AppColors.surface
border: Border.all(color: AppColors.border)

// After
color: AppColors.getSurface(context)
border: Border.all(color: AppColors.getBorder(context))
```

### Step 2: Update Text Styles
```dart
// Before
style: AppTextStyles.headline5
style: AppTextStyles.bodyMedium

// After
style: AppTextStyles.headline5Dynamic(context)
style: AppTextStyles.bodyMediumDynamic(context)
```

### Step 3: Fix Shadows
```dart
// Before
BoxShadow(color: Colors.black.withOpacity(0.1))

// After
BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.12))
```

### Step 4: Update Dropdowns and Menus
```dart
// Before
DropdownButton(dropdownColor: Colors.white)

// After
DropdownButton(dropdownColor: AppColors.getSurface(context))
```

## Conclusion

The brand feature demonstrates best practices for implementing dark mode support in Flutter applications. By using the dynamic helper methods and following the patterns shown in these examples, you can ensure your components provide a consistent experience across both light and dark themes.

Remember to always test your components in both themes and follow the migration guide when updating existing code.