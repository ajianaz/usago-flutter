import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/widgets/bloc_responsive_layout.dart';
import '../../../../shared/widgets/responsive_builder.dart';
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
    return const CreateBrandView();
  }
}

class CreateBrandView extends StatefulWidget {
  const CreateBrandView({super.key});

  @override
  State<CreateBrandView> createState() => _CreateBrandViewState();
}

class _CreateBrandViewState extends State<CreateBrandView> {
  @override
  Widget build(BuildContext context) {
    return BlocResponsiveLayoutListener<BrandBloc, BrandState>(
      bloc: context.read<BrandBloc>(),
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
      builder: (context, deviceType) {
        return _buildContent(context, deviceType);
      },
    );
  }

  Widget _buildContent(BuildContext context, DeviceType deviceType) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Buat Brand Baru',
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
      ),
      body: ResponsiveBuilder(
        builder: (context, deviceType) {
          return _buildForm(context, deviceType);
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, DeviceType deviceType) {
    final isMobile = deviceType == DeviceType.mobile;

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
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primary.withValues(alpha: 0.05),
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
                    color: AppColors.onPrimary,
                    size: UIConstants.fontSizeXXLarge,
                  ),
                  const SizedBox(height: UIConstants.spacingDefault),
                  Text(
                    'Buat Brand Baru',
                    style: AppTextStyles.headline3.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: UIConstants.paddingSmall),
                  Text(
                    'Lengkapi data brand Anda dan mulai beroperasi',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: isMobile ? UIConstants.spacingDefault : UIConstants.spacingExtraLarge),
          ],

          // Form Section
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(isMobile ? UIConstants.paddingDefault : UIConstants.paddingExtraLarge),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(UIConstants.borderRadiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
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
                    'Informasi Brand',
                    style: AppTextStyles.headline4.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: UIConstants.paddingSmall),

                  // Form Description
                  Text(
                    'Isi form berikut dengan data yang diperlukan untuk membuat brand baru. Pastikan semua informasi yang ditandai dengan benar.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Brand Form
                  const CreateBrandForm(),
                ],
              ),
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