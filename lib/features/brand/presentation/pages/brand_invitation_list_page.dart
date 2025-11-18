import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/widgets/bloc_responsive_layout.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/brand_invitation.dart';
import '../bloc/brand_bloc.dart';
import '../bloc/brand_event.dart';
import '../bloc/brand_state.dart';
import '../widgets/invitation_card.dart';
import '../widgets/invite_user_form.dart';

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
    return BlocProvider.value(
      value: getIt<BrandBloc>(),
      child: BrandInvitationListView(brand: brand),
    );
  }
}

class BrandInvitationListView extends StatefulWidget {
  final Brand brand;

  const BrandInvitationListView({
    Key? key,
    required this.brand,
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
      context.read<BrandBloc>().add(const LoadUserInvitationsEvent());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocResponsiveLayoutListener<BrandBloc, BrandState>(
      listener: (context, state) {
        if (state is BrandOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is BrandError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, deviceType) {
        return _buildContent(context, deviceType);
      },
    );
  }

  Widget _buildContent(BuildContext context, DeviceType deviceType) {
    final isMobile = deviceType == DeviceType.mobile;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kelola Undangan',
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
              tooltip: 'Undang Pengguna Baru',
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.textSecondary,
          labelStyle: AppTextStyles.bodyMedium,
          indicatorColor: AppColors.primary,
          indicatorWeight: UIConstants.strokeWidthIndicator,
          tabs: const [
            Tab(
              icon: Icon(Icons.inbox),
              text: 'Diterima',
            ),
            Tab(
              icon: Icon(Icons.send),
              text: 'Terkirim',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReceivedInvitations(context, deviceType),
          _buildSentInvitations(context, deviceType),
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

  Widget _buildReceivedInvitations(BuildContext context, DeviceType deviceType) {
    final isMobile = deviceType == DeviceType.mobile;

    return BlocBuilder<BrandBloc, BrandState>(
      builder: (context, state) {
        if (state is BrandLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        }

        if (state is ReceivedInvitationsLoaded) {
          final invitations = state.invitations;

          if (invitations.isEmpty) {
            return _buildEmptyState(
              context,
              'Belum ada undangan yang diterima',
              'Anda belum menerima undangan brand apa pun. Undangan yang diterima akan muncul di sini.',
              Icons.inbox,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<BrandBloc>().add(const GetReceivedInvitationsEvent());
            },
            child: _buildInvitationList(
              context,
              deviceType,
              invitations,
              true,
            ),
          );
        }

        return _buildEmptyState(
          context,
          'Gagal memuat undangan',
          'Terjadi kesalahan saat memuat undangan yang diterima. Silakan coba lagi.',
          Icons.error_outline,
        );
      },
    );
  }

  Widget _buildSentInvitations(BuildContext context, DeviceType deviceType) {
    final isMobile = deviceType == DeviceType.mobile;

    return BlocBuilder<BrandBloc, BrandState>(
      builder: (context, state) {
        if (state is BrandLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          );
        }

        if (state is SentInvitationsLoaded) {
          final invitations = state.invitations;

          if (invitations.isEmpty) {
            return _buildEmptyState(
              context,
              'Belum ada undangan terkirim',
              'Anda belum mengirim undangan brand apa pun. Undangan yang terkirim akan muncul di sini.',
              Icons.send,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<BrandBloc>().add(const GetSentInvitationsEvent());
            },
            child: _buildInvitationList(
              context,
              deviceType,
              invitations,
              false,
            ),
          );
        }

        return _buildEmptyState(
          context,
          'Gagal memuat undangan',
          'Terjadi kesalahan saat memuat undangan terkirim. Silakan coba lagi.',
          Icons.error_outline,
        );
      },
    );
  }

  Widget _buildInvitationList(
    BuildContext context,
    DeviceType deviceType,
    List<BrandInvitation> invitations,
    bool isReceived,
  ) {
    final isMobile = deviceType == DeviceType.mobile;

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
                  color: Colors.black12,
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
        title: Text('Detail Undangan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Brand', invitation.brandName),
              _buildDetailRow(
                isReceived ? 'Dari' : 'Ke',
                isReceived ? invitation.inviterName : invitation.inviteeEmail,
              ),
              _buildDetailRow('Peran', invitation.formattedRole),
              _buildDetailRow('Status', invitation.formattedStatus),
              _buildDetailRow('Dikirim', invitation.createdDateFormatted),
              if (invitation.expirationDateFormatted != null)
                _buildDetailRow('Kadaluarsa', invitation.expirationDateFormatted!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.router.maybePop(),
            child: const Text('Tutup'),
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
                    'Undang Pengguna Baru',
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