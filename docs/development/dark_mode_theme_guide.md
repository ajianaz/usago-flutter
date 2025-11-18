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
  style: AppTextStyles.headline1(context), // Automatically adapts to theme
),

Text(
  'Body text',
  style: AppTextStyles.bodyMedium(context), // Automatically adapts to theme
),

Text(
  'Caption',
  style: AppTextStyles.caption(context), // Automatically adapts to theme
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
            style: AppTextStyles.headline4(context),
          ),
          Text(
            'Dynamic Body',
            style: AppTextStyles.bodyMedium(context),
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
              style: AppTextStyles.headline6(context),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium(context),
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
style: AppTextStyles.headline1(context)
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
  style: AppTextStyles.headline1(context),
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
style: AppTextStyles.bodyMedium(context)

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