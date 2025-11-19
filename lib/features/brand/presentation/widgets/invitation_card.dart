import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../domain/entities/brand_invitation.dart';
import '../bloc/brand_invitation/brand_invitation_bloc.dart';
import '../bloc/brand_invitation/brand_invitation_event.dart';
import '../helpers/index.dart'; // Import formatter helpers
import '../../../../i18n/translations.g.dart';

/// Invitation Card Widget
/// Displays invitation details with appropriate actions based on invitation status and type
class InvitationCard extends StatelessWidget {
  final BrandInvitation invitation;
  final bool isReceived; // true for received invitations, false for sent invitations
  final VoidCallback? onTap;

  const InvitationCard({
    Key? key,
    required this.invitation,
    required this.isReceived,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with brand name and status
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invitation.brandName,
                          style: AppTextStyles.headline6.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          isReceived
                              ? '${context.t.brand.from_label}: ${invitation.inviterName}'
                              : '${context.t.brand.to_label}: ${invitation.inviteeEmail}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(context),
                ],
              ),
              SizedBox(height: AppSpacing.sm),

              // Role information
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.userTag,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    '${context.t.brand.role_label}: ${invitation.displayRole(context)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),

              // Branch information (if available)
              if (invitation.branchIds.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.codeBranch,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Cabang: ${invitation.branchIds.length} cabang',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
              ],

              // Date information
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.calendar,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    '${context.t.brand.sent_label}: ${invitation.displayCreatedDate(context)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (invitation.expiresAt != null) ...[
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      '•',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      '${context.t.brand.expires_label}: ${invitation.displayExpirationDate(context)}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: invitation.isExpired
                            ? AppColors.error
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),

              // Action buttons
              if (invitation.isPending) ...[
                SizedBox(height: AppSpacing.md),
                _buildActionButtons(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (invitation.status.toUpperCase()) {
      case 'PENDING':
        backgroundColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        icon = FontAwesomeIcons.clock;
        break;
      case 'ACCEPTED':
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        icon = FontAwesomeIcons.checkCircle;
        break;
      case 'DECLINED':
        backgroundColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        icon = FontAwesomeIcons.timesCircle;
        break;
      case 'EXPIRED':
        backgroundColor = AppColors.textSecondary.withOpacity(0.1);
        textColor = AppColors.textSecondary;
        icon = FontAwesomeIcons.hourglassEnd;
        break;
      default:
        backgroundColor = AppColors.surface;
        textColor = AppColors.textSecondary;
        icon = FontAwesomeIcons.questionCircle;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: textColor,
          ),
          SizedBox(width: AppSpacing.xs),
          Text(
            invitation.displayStatus(context),
            style: AppTextStyles.bodySmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (isReceived) {
      // Actions for received invitations
      return Row(
        children: [
          Expanded(
            child: CustomButton(
              text: context.t.brand.decline,
              onPressed: () => _showDeclineConfirmation(context),
              isFullWidth: true,
              variant: ButtonVariant.outline,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: CustomButton(
              text: context.t.brand.accept,
              onPressed: () => _showAcceptConfirmation(context),
              isFullWidth: true,
              variant: ButtonVariant.primary,
            ),
          ),
        ],
      );
    } else {
      // Actions for sent invitations
      return Row(
        children: [
          Expanded(
            child: CustomButton(
              text: context.t.brand.cancel,
              onPressed: () => _showCancelConfirmation(context),
              isFullWidth: true,
              variant: ButtonVariant.outline,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: CustomButton(
              text: context.t.brand.resend,
              onPressed: () => _resendInvitation(context),
              isFullWidth: true,
              variant: ButtonVariant.primary,
            ),
          ),
        ],
      );
    }
  }

  void _showAcceptConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.brand.accept_invitation_dialog_title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.t.brand.accept_invitation_dialog_message.replaceAll('{brandName}', invitation.brandName)),
            SizedBox(height: AppSpacing.sm),
            Text(
              context.t.brand.accept_invitation_role_info.replaceAll('{role}', invitation.displayRole(context)),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.router.maybePop(),
            child: Text(context.t.common.cancel),
          ),
          TextButton(
            onPressed: () {
              context.router.maybePop();
              // In a real app, you would get the token from the invitation or URL
              context.read<BrandInvitationBloc>().add(
                AcceptInvitationEvent(invitationId: invitation.id, token: 'token_here'),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.success,
            ),
            child: Text(context.t.brand.accept),
          ),
        ],
      ),
    );
  }

  void _showDeclineConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.brand.decline_invitation_dialog_title),
        content: Text(context.t.brand.decline_invitation_dialog_message.replaceAll('{brandName}', invitation.brandName)),
        actions: [
          TextButton(
            onPressed: () => context.router.maybePop(),
            child: Text(context.t.common.cancel),
          ),
          TextButton(
            onPressed: () {
              context.router.maybePop();
              context.read<BrandInvitationBloc>().add(
                RejectInvitationEvent(invitationId: invitation.id),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text(context.t.brand.decline),
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.brand.cancel_invitation_dialog_title),
        content: Text(context.t.brand.cancel_invitation_dialog_message.replaceAll('{email}', invitation.inviteeEmail)),
        actions: [
          TextButton(
            onPressed: () => context.router.maybePop(),
            child: Text(context.t.common.cancel),
          ),
          TextButton(
            onPressed: () {
              context.router.maybePop();
              context.read<BrandInvitationBloc>().add(
                RevokeInvitationEvent(invitationId: invitation.id),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text(context.t.brand.cancel),
          ),
        ],
      ),
    );
  }

  void _resendInvitation(BuildContext context) {
    context.read<BrandInvitationBloc>().add(
      ResendInvitationEvent(invitationId: invitation.id),
    );
  }
}