import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../app/router.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../domain/entities/brand.dart';

/// Navigation service for brand-related pages
/// This service handles navigation between brand pages with proper parameter passing
class BrandNavigationService {
  /// Navigate to brand statistics page
  static void navigateToStats(BuildContext context, Brand brand) {
    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to stats for ${brand.name}'),
        backgroundColor: AppColors.info, // Info color
        duration: const Duration(seconds: 1),
      ),
    );

    // Navigate after a short delay to allow the snackbar to show
    Future.delayed(const Duration(milliseconds: 500), () {
      // Use of generated route class with brand parameter
      AutoRouter.of(context).push(BrandStatsRoute(brand: brand));
    });
  }

  /// Navigate to brand invitations page
  static void navigateToInvitations(BuildContext context, Brand brand) {
    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to invitations for ${brand.name}'),
        backgroundColor: AppColors.warning, // Warning color
        duration: const Duration(seconds: 1),
      ),
    );

    // Navigate after a short delay to allow the snackbar to show
    Future.delayed(const Duration(milliseconds: 500), () {
      // Use of generated route class with brand parameter
      AutoRouter.of(context).push(BrandInvitationListRoute(brand: brand));
    });
  }

  /// Navigate to brand transfer page
  static void navigateToTransfer(BuildContext context, Brand brand) {
    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to transfer for ${brand.name}'),
        backgroundColor: AppColors.success, // Success color
        duration: const Duration(seconds: 1),
      ),
    );

    // Navigate after a short delay to allow the snackbar to show
    Future.delayed(const Duration(milliseconds: 500), () {
      // Use of generated route class with brand parameter
      AutoRouter.of(context).push(BrandTransferRoute(brand: brand));
    });
  }
}