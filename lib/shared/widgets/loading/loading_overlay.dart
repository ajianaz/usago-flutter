import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/animation_theme.dart';
import '../../utils/animation_utils.dart';

/// Loading overlay yang dapat digunakan di seluruh aplikasi
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;
  final Color? spinnerColor;
  final double? spinnerSize;
  final TextStyle? messageStyle;
  final bool barrierDismissible;
  final VoidCallback? onDismiss;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.message,
    this.backgroundColor,
    this.spinnerColor,
    this.spinnerSize,
    this.messageStyle,
    this.barrierDismissible = false,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) _buildLoadingOverlay(context),
      ],
    );
  }

  Widget _buildLoadingOverlay(BuildContext context) {
    return GestureDetector(
      onTap: barrierDismissible ? onDismiss : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: backgroundColor ?? Colors.black.withOpacity(0.5),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSpinner(),
              if (message != null) ...[
                AppSpacing.verticalGapMd,
                _buildMessage(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpinner() {
    return Builder(
      builder: (context) {
        return OptimizedAnimationBuilder(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.linear,
          repeat: true,
          builder: (context, animation) {
            return Transform.rotate(
              angle: animation.value * 2 * 3.14159265359,
              child: SizedBox(
                width: spinnerSize ?? 48,
                height: spinnerSize ?? 48,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    spinnerColor ?? AppColors.primary,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Text(
      message!,
      style: messageStyle ??
          const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
      textAlign: TextAlign.center,
    );
  }
}

/// Simple loading overlay untuk penggunaan cepat
class SimpleLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const SimpleLoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: child,
    );
  }
}

/// Loading overlay dengan custom design
class CustomLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Widget? customLoader;
  final String? message;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? overlayColor;
  final Color? containerColor;

  const CustomLoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.customLoader,
    this.message,
    this.padding,
    this.borderRadius,
    this.overlayColor,
    this.containerColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) _buildCustomLoadingOverlay(context),
      ],
    );
  }

  Widget _buildCustomLoadingOverlay(BuildContext context) {
    return Container(
      color: overlayColor ?? Colors.black.withOpacity(0.3),
      child: Center(
        child: Container(
          padding: padding ?? AppSpacing.paddingAllLg,
          decoration: BoxDecoration(
            color: containerColor ?? Colors.white,
            borderRadius: borderRadius ?? AppSpacing.radiusLg,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (customLoader != null)
                customLoader!
              else
                _buildDefaultSpinner(context),
              if (message != null) ...[
                AppSpacing.verticalGapMd,
                Text(
                  message!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultSpinner(BuildContext context) {
    return Builder(
      builder: (context) {
        return OptimizedAnimationBuilder(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.linear,
          repeat: true,
          builder: (context, animation) {
            return Transform.rotate(
              angle: animation.value * 2 * 3.14159265359,
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Loading overlay dengan progress indicator
class ProgressLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final double progress;
  final String? message;
  final Color? backgroundColor;
  final Color? progressColor;

  const ProgressLoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    required this.progress,
    this.message,
    this.backgroundColor,
    this.progressColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) _buildProgressOverlay(context),
      ],
    );
  }

  Widget _buildProgressOverlay(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: AppSpacing.paddingAllLg,
          margin: AppSpacing.paddingHorizontalLg,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppSpacing.radiusLg,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildProgressIndicator(context),
              if (message != null) ...[
                AppSpacing.verticalGapMd,
                Text(
                  message!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
              AppSpacing.verticalGapSm,
              Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return SizedBox(
      width: 200,
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: AppColors.border,
        valueColor: AlwaysStoppedAnimation<Color>(
          progressColor ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

/// Loading overlay manager untuk mengelola multiple loading states
class LoadingOverlayManager {
  static final Map<String, bool> _loadingStates = {};
  static final Map<String, String?> _loadingMessages = {};
  static final Map<String, double> _loadingProgress = {};

  static void setLoading(String key, bool isLoading, {String? message}) {
    _loadingStates[key] = isLoading;
    if (message != null) {
      _loadingMessages[key] = message;
    }
  }

  static void setProgress(String key, double progress, {String? message}) {
    _loadingProgress[key] = progress;
    if (message != null) {
      _loadingMessages[key] = message;
    }
  }

  static bool isLoading(String key) {
    return _loadingStates[key] ?? false;
  }

  static String? getMessage(String key) {
    return _loadingMessages[key];
  }

  static double? getProgress(String key) {
    return _loadingProgress[key];
  }

  static void clearLoading(String key) {
    _loadingStates.remove(key);
    _loadingMessages.remove(key);
    _loadingProgress.remove(key);
  }

  static void clearAllLoading() {
    _loadingStates.clear();
    _loadingMessages.clear();
    _loadingProgress.clear();
  }
}

/// Loading overlay dengan BLoC integration
class BlocLoadingOverlay<T> extends StatelessWidget {
  final T state;
  final Widget child;
  final String? loadingMessage;
  final bool Function(T state) isLoading;
  final String? Function(T state)? getErrorMessage;
  final Widget Function(BuildContext, String)? errorBuilder;

  const BlocLoadingOverlay({
    Key? key,
    required this.state,
    required this.child,
    this.loadingMessage,
    required this.isLoading,
    this.getErrorMessage,
    this.errorBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoadingState = isLoading(state);
    final errorMessage = getErrorMessage?.call(state);

    if (errorMessage != null && errorBuilder != null) {
      return errorBuilder!(context, errorMessage);
    }

    return LoadingOverlay(
      isLoading: isLoadingState,
      message: isLoadingState ? loadingMessage : null,
      child: child,
    );
  }
}
