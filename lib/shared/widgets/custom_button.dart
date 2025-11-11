import 'package:flutter/material.dart';
import '../themes/app_spacing.dart';
import '../themes/app_text_styles.dart';

enum ButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;
  final Widget? child;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getPrimaryButtonStyle(context),
          child: _buildButtonContent(),
        );
      case ButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getSecondaryButtonStyle(context),
          child: _buildButtonContent(),
        );
      case ButtonVariant.outline:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getOutlineButtonStyle(context),
          child: _buildButtonContent(),
        );
      case ButtonVariant.ghost:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: _getGhostButtonStyle(context),
          child: _buildButtonContent(),
        );
    }
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _getTextSize(),
            height: _getTextSize(),
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          if (icon != null) ...[
            AppSpacing.gapSm,
            icon!,
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          icon!,
          AppSpacing.gapSm,
        ],
        Text(
          text,
          style: _getTextStyle(),
        ),
      ],
    );
  }

  double _getTextSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTextStyles.buttonSmall;
      case ButtonSize.medium:
        return AppTextStyles.buttonMedium;
      case ButtonSize.large:
        return AppTextStyles.buttonLarge;
    }
  }

  EdgeInsets _getButtonPadding() {
    switch (size) {
      case ButtonSize.small:
        return AppSpacing.paddingHorizontalSm + AppSpacing.paddingVerticalSm;
      case ButtonSize.medium:
        return AppSpacing.paddingHorizontalMd + AppSpacing.paddingVerticalSm;
      case ButtonSize.large:
        return AppSpacing.paddingHorizontalLg + AppSpacing.paddingVerticalMd;
    }
  }

  ButtonStyle _getPrimaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      textStyle: _getTextStyle(),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.radiusButton,
      ),
      padding: _getButtonPadding(),
    );
  }

  ButtonStyle _getSecondaryButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      foregroundColor: Theme.of(context).colorScheme.onSecondary,
      textStyle: _getTextStyle(),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.radiusButton,
      ),
      padding: _getButtonPadding(),
    );
  }

  ButtonStyle _getOutlineButtonStyle(BuildContext context) {
    return OutlinedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.primary,
      side: BorderSide(color: Theme.of(context).colorScheme.primary),
      textStyle: _getTextStyle(),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.radiusButton,
      ),
      padding: _getButtonPadding(),
    );
  }

  ButtonStyle _getGhostButtonStyle(BuildContext context) {
    return TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.primary,
      textStyle: _getTextStyle(),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.radiusButton,
      ),
      padding: _getButtonPadding(),
    );
  }
}