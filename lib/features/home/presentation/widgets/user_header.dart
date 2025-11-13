import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/user_dashboard.dart';

class UserHeader extends StatelessWidget {
  final User? user;
  final UserDashboard? userDashboard;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;

  const UserHeader({
    Key? key,
    this.user,
    this.userDashboard,
    this.onProfileTap,
    this.onNotificationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: AppSpacing.paddingCard,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppSpacing.radiusCard,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Profile Picture
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.onPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.onPrimary.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: user?.hasProfilePicture == true
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            user!.profilePicture!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildDefaultAvatar();
                            },
                          ),
                        )
                      : _buildDefaultAvatar(),
                ),
              ),
              AppSpacing.gapLg,
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang! 👋',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onPrimary.withOpacity(0.9),
                      ),
                    ),
                    AppSpacing.verticalGapXs,
                    Text(
                      user?.displayName ?? 'User',
                      style: AppTextStyles.headline5.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (userDashboard?.roleDisplayName != null) ...[
                      AppSpacing.verticalGapXs,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.onPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          userDashboard!.roleDisplayName,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    if (userDashboard?.branchName != null) ...[
                      AppSpacing.verticalGapXs,
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.store,
                            size: 16,
                            color: AppColors.onPrimary.withOpacity(0.8),
                          ),
                          AppSpacing.gapXs,
                          Text(
                            userDashboard!.branchName!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.onPrimary.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Notification Button
              if (onNotificationTap != null)
                GestureDetector(
                  onTap: onNotificationTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.bell,
                          color: AppColors.onPrimary,
                          size: 24,
                        ),
                        if (userDashboard?.unreadNotifications != null &&
                            userDashboard!.unreadNotifications > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  userDashboard!.unreadNotifications > 9
                                      ? '9+'
                                      : '${userDashboard!.unreadNotifications}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.onPrimary,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          if (userDashboard?.hasPendingItems == true) ...[
            AppSpacing.verticalGapMd,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.5),
                ),
              ),
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.triangleExclamation,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  AppSpacing.gapSm,
                  Expanded(
                    child: Text(
                      'Anda memiliki ${userDashboard!.totalPendingCount} item yang perlu ditangani',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Center(
      child: Text(
        user?.initials ?? '?',
        style: AppTextStyles.headline4.copyWith(
          color: AppColors.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}