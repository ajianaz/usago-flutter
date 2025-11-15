import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Helper untuk integrasi loading states dengan BLoC pattern
class BlocLoadingHelper {
  /// Menentukan apakah BLoC state sedang loading
  static bool isLoading(BlocBase bloc) {
    final state = bloc.state;

    // Cek untuk berbagai tipe loading state yang umum
    if (state.toString().contains('Loading')) {
      return true;
    }

    // Cek untuk property isLoading jika ada
    try {
      final hasLoadingProperty = state is dynamic &&
          (state as dynamic).isLoading != null;
      if (hasLoadingProperty) {
        return (state as dynamic).isLoading == true;
      }
    } catch (e) {
      // Ignore error jika property tidak ada
    }

    return false;
  }

  /// Mendapatkan pesan loading dari BLoC state
  static String? getLoadingMessage(BlocBase bloc) {
    final state = bloc.state;

    // Cek untuk berbagai tipe loading state yang umum
    if (state.toString().contains('Loading')) {
      return 'Memuat...';
    }

    // Cek untuk property loadingMessage jika ada
    try {
      final hasMessageProperty = state is dynamic &&
          (state as dynamic).loadingMessage != null;
      if (hasMessageProperty) {
        return (state as dynamic).loadingMessage as String?;
      }
    } catch (e) {
      // Ignore error jika property tidak ada
    }

    return null;
  }

  /// Mendapatkan progress dari BLoC state
  static double? getProgress(BlocBase bloc) {
    final state = bloc.state;

    // Cek untuk property progress jika ada
    try {
      final hasProgressProperty = state is dynamic &&
          (state as dynamic).progress != null;
      if (hasProgressProperty) {
        return (state as dynamic).progress as double?;
      }
    } catch (e) {
      // Ignore error jika property tidak ada
    }

    return null;
  }

  /// Membuat loading overlay berdasarkan BLoC state
  static Widget buildLoadingOverlay({
    required BuildContext context,
    required BlocBase bloc,
    required Widget child,
    String? customMessage,
    Color? backgroundColor,
    Color? spinnerColor,
    bool barrierDismissible = false,
    VoidCallback? onDismiss,
  }) {
    return BlocBuilder(
      bloc: bloc,
      builder: (context, state) {
        return Stack(
          children: [
            child,
            if (isLoading(bloc))
              Container(
                color: backgroundColor ?? Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (customMessage != null || getLoadingMessage(bloc) != null)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            customMessage ?? getLoadingMessage(bloc) ?? 'Memuat...',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(spinnerColor ?? Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Membuat skeleton loader berdasarkan BLoC state
  static Widget buildSkeletonLoader({
    required BuildContext context,
    required BlocBase bloc,
    required Widget child,
    Widget? customSkeleton,
  }) {
    return BlocBuilder(
      bloc: bloc,
      builder: (context, state) {
        if (isLoading(bloc)) {
          return customSkeleton ??
                 Column(
                   mainAxisSize: MainAxisSize.min,
                   children: List.generate(5, (index) => Container(
                     margin: const EdgeInsets.only(bottom: 8),
                     width: double.infinity,
                     height: 80,
                     decoration: BoxDecoration(
                       color: Colors.grey[300],
                       borderRadius: BorderRadius.circular(8),
                     ),
                   )),
                 );
        }

        return child;
      },
    );
  }

  /// Membuat loading button berdasarkan BLoC state
  static Widget buildLoadingButton({
    required BuildContext context,
    required BlocBase bloc,
    required String text,
    required VoidCallback onPressed,
    ButtonVariant variant = ButtonVariant.primary,
    ButtonSize size = ButtonSize.medium,
    bool isFullWidth = false,
    Widget? icon,
    String? loadingText,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? loadingColor,
  }) {
    return BlocBuilder(
      bloc: bloc,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: isLoading(bloc) ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
            foregroundColor: foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading(bloc))
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(loadingColor ?? Colors.white),
                  ),
                )
              else if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  color: isLoading(bloc) ? Colors.white.withOpacity(0.7) : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Enum untuk button variant
enum ButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
}

/// Enum untuk button size
enum ButtonSize {
  small,
  medium,
  large,
}