import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/widgets/bloc_responsive_layout.dart';
import '../../../../shared/widgets/desktop_constrained_content.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/brand_invitation.dart';
import '../bloc/brand_invitation/brand_invitation_bloc.dart';
import '../bloc/brand_invitation/brand_invitation_event.dart';
import '../bloc/brand_invitation/brand_invitation_state.dart';
import '../widgets/invitation_card.dart';
import '../widgets/invite_user_form.dart';
import '../helpers/index.dart'; // Import formatter helpers
import '../../../../i18n/translations.g.dart';

/// Brand Invitation List Page
/// Shows all invitations for a brand (sent and received)
@RoutePage()
class BrandInvitationListPage extends StatelessWidget {
  final Brand brand;

  const BrandInvitationListPage({
    Key? key,
    required this.brand,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<BrandInvitationBloc>(),
      child: BlocResponsiveLayout<BrandInvitationBloc, BrandInvitationState>(
        builder: (context, bloc, state, deviceType) {
          return BrandInvitationListView(brand: brand, deviceType: deviceType);
        },
        listener: (context, state) {
          if (state is BrandInvitationCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is BrandInvitationAccepted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is BrandInvitationRejected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is BrandInvitationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }
}

class BrandInvitationListView extends StatefulWidget {
  final Brand brand;
  final DeviceType deviceType;

  const BrandInvitationListView({
    Key? key,
    required this.brand,
    required this.deviceType,
  }) : super(key: key);

  @override
  State<BrandInvitationListView> createState() => _BrandInvitationListViewState();
}

class _BrandInvitationListViewState extends State<BrandInvitationListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load invitations when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BrandInvitationBloc>().add(LoadInvitationsEvent(brandId: widget.brand.id));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);

    // Apply desktop constraint
    if (widget.deviceType == DeviceType.desktop) {
      return DesktopConstrainedContent(child: content);
    }

    return content;
  }

  Widget _buildContent(BuildContext context) {
    final isMobile = widget.deviceType == DeviceType.mobile;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t.brand.manage_invitations_page,
          style: AppTextStyles.headline5.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.router.maybePop(),
        ),
        actions: [
          if (!isMobile) ...[
            IconButton(
              icon: const Icon(
                Icons.person_add,
                color: AppColors.textPrimary,
              ),
              onPressed: () => _showInviteUserDialog(context),
              tooltip: context.t.brand.invite_new_user_tooltip,
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.textSecondary,
          labelStyle: AppTextStyles.bodyMedium,
          indicatorColor: AppColors.primary,
          indicatorWeight: UIConstants.strokeWidthIndicator,
          tabs: [
            Tab(
              icon: Icon(Icons.inbox),
              text: context.t.brand.received,
            ),
            Tab(
              icon: Icon(Icons.send),
              text: context.t.brand.sent,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReceivedInvitations(context),
          _buildSentInvitations(context),
        ],
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              onPressed: () => _showInviteUserDialog(context),
              backgroundColor: AppColors.primary,
              child: const Icon(
                Icons.person_add,
                color: AppColors.onPrimary,
              ),
            )
          : null,
    );
  }

  Widget _buildReceivedInvitations(BuildContext context) {
    final isMobile = widget.deviceType == DeviceType.mobile;

    return BlocBuilder<BrandInvitationBloc, BrandInvitationState>(
      builder: (context, state) {
        if (state is BrandInvitationLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        }

        if (state is BrandInvitationsLoaded) {
          final invitations = state.invitations;

          if (invitations.isEmpty) {
            return _buildEmptyState(
              context,
              context.t.brand.no_received_invitations,
              context.t.brand.no_received_invitations_message,
              Icons.inbox,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<BrandInvitationBloc>().add(RefreshInvitationsEvent(brandId: widget.brand.id));
            },
            child: _buildInvitationList(
              context,
              invitations,
              true,
            ),
          );
        }

        return _buildEmptyState(
          context,
          context.t.brand.failed_to_load_invitations,
          context.t.brand.failed_to_load_received_invitations,
          Icons.error_outline,
        );
      },
    );
  }

  Widget _buildSentInvitations(BuildContext context) {
    final isMobile = widget.deviceType == DeviceType.mobile;

    return BlocBuilder<BrandInvitationBloc, BrandInvitationState>(
      builder: (context, state) {
        if (state is BrandInvitationLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        }

        if (state is BrandInvitationsLoaded) {
          final invitations = state.invitations;

          if (invitations.isEmpty) {
            return _buildEmptyState(
              context,
              context.t.brand.no_sent_invitations,
              context.t.brand.no_sent_invitations_message,
              Icons.send,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<BrandInvitationBloc>().add(RefreshInvitationsEvent(brandId: widget.brand.id));
            },
            child: _buildInvitationList(
              context,
              invitations,
              false,
            ),
          );
        }

        return _buildEmptyState(
          context,
          context.t.brand.failed_to_load_invitations,
          context.t.brand.failed_to_load_sent_invitations,
          Icons.error_outline,
        );
      },
    );
  }

  Widget _buildInvitationList(
    BuildContext context,
    List<BrandInvitation> invitations,
    bool isReceived,
  ) {
    final isMobile = widget.deviceType == DeviceType.mobile;

    if (isMobile) {
      return ListView.builder(
        padding: EdgeInsets.all(AppSpacing.md),
        itemCount: invitations.length,
        itemBuilder: (context, index) {
          final invitation = invitations[index];
          return InvitationCard(
            invitation: invitation,
            isReceived: isReceived,
            onTap: () => _showInvitationDetails(context, invitation, isReceived: isReceived),
          );
        },
      );
    } else {
      final crossAxisCount = isMobile ? 1 : 2;
      final childAspectRatio = isMobile ? null : 1.2;

      return GridView.builder(
        padding: EdgeInsets.all(AppSpacing.lg),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: childAspectRatio ?? 1.0,
        ),
        itemCount: invitations.length,
        itemBuilder: (context, index) {
          final invitation = invitations[index];
          return InvitationCard(
            invitation: invitation,
            isReceived: isReceived,
            onTap: () => _showInvitationDetails(context, invitation, isReceived: isReceived),
          );
        },
      );
    }
  }

  Widget _buildEmptyState(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: UIConstants.containerSizeDefault,
            padding: EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(UIConstants.borderRadiusLarge),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.12),
                  blurRadius: UIConstants.elevationCard,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: UIConstants.fontSizeXXXLarge,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  title,
                  style: AppTextStyles.headline6.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showInvitationDetails(BuildContext context, BrandInvitation invitation, {bool isReceived = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.brand.invitation_details),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(context.t.brand.brand_label, invitation.brandName),
              _buildDetailRow(
                isReceived ? context.t.brand.from_label : context.t.brand.to_label,
                isReceived ? invitation.inviterName : invitation.inviteeEmail,
              ),
              _buildDetailRow(context.t.brand.role_label, invitation.displayRole(context)),
              _buildDetailRow(context.t.brand.status, invitation.displayStatus(context)),
              if (invitation.branchIds.isNotEmpty)
                _buildDetailRow('Cabang', '${invitation.branchIds.length} cabang'),
              _buildDetailRow(context.t.brand.sent_label, invitation.displayCreatedDate(context)),
              if (invitation.displayExpirationDate(context) != null)
                _buildDetailRow(context.t.brand.expires_label, invitation.displayExpirationDate(context)!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.router.maybePop(),
            child: Text(context.t.brand.close_label),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: UIConstants.widthSmall,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _showInviteUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxWidth: UIConstants.widthMedium,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.t.brand.invite_new_user,
                    style: AppTextStyles.headline5.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.router.maybePop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              Expanded(
                child: InviteUserForm(brand: widget.brand),
              ),
            ],
          ),
        ),
      ),
    );
  }
}