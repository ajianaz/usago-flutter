import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:usago/core/extensions/context_extension.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/widgets/bloc_responsive_layout.dart';
import '../../../../shared/widgets/desktop_constrained_content.dart';
import '../bloc/brand_bloc.dart';
import '../bloc/brand_state.dart';
import '../widgets/create_brand_form.dart';

/// Create Brand Page
/// Wrapper page for brand creation form
@RoutePage()
class CreateBrandPage extends StatelessWidget {
  const CreateBrandPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocResponsiveLayout<BrandBloc, BrandState>(
      builder: (context, bloc, state, deviceType) {
        return CreateBrandView(deviceType: deviceType);
      },
      listener: (context, state) {
        if (state is BrandOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Navigate back to brand selection after successful creation
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              context.router.maybePop();
            }
          });
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
    );
  }
}

class CreateBrandView extends StatefulWidget {
  final DeviceType deviceType;

  const CreateBrandView({super.key, required this.deviceType});

  @override
  State<CreateBrandView> createState() => _CreateBrandViewState();
}

class _CreateBrandViewState extends State<CreateBrandView> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t.brand.create_brand,
          style: AppTextStyles.headline5Dynamic(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.getTextPrimary(context),
          ),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    final isMobile = widget.deviceType == DeviceType.mobile;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(isMobile ? UIConstants.paddingDefault : UIConstants.paddingExtraLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          if (!isMobile) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(UIConstants.paddingExtraLarge),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.1),
                    AppColors.primary.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.1 : 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(UIConstants.borderRadiusLarge),
                  bottomRight: Radius.circular(UIConstants.borderRadiusLarge),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FaIcon(
                    FontAwesomeIcons.building,
                    color: AppColors.getTextPrimary(context),
                    size: UIConstants.fontSizeXXLarge,
                  ),
                  const SizedBox(height: UIConstants.spacingDefault),
                  Text(
                    context.t.brand.create_brand,
                    style: AppTextStyles.headline3Dynamic(context).copyWith(
                      color: AppColors.getTextPrimary(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: UIConstants.paddingSmall),
                  Text(
                    context.t.brand.brand_description,
                    style: AppTextStyles.bodyLargeDynamic(context).copyWith(
                      color: AppColors.getTextPrimary(context).withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: isMobile ? UIConstants.spacingDefault : UIConstants.spacingExtraLarge),
          ],

          // Form Section
          Container(
              width: double.infinity,
              padding: EdgeInsets.all(isMobile ? UIConstants.paddingDefault : UIConstants.paddingExtraLarge),
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
                  // Form Title
                  Text(
                    context.t.brand.brand_info,
                    style: AppTextStyles.headline4Dynamic(context).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: UIConstants.paddingSmall),

                  // Form Description
                  Text(
                    context.t.brand.brand_description,
                    style: AppTextStyles.bodyMediumDynamic(context).copyWith(
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Brand Form
                  CreateBrandForm(deviceType: widget.deviceType),
                ],
              ),
            ),

          // Bottom spacing for mobile
          if (isMobile) ...[
            SizedBox(height: AppSpacing.xl),
          ],
        ],
      ),
    );
  }
}