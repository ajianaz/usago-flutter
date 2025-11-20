import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../i18n/translations.g.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/widgets/bloc_responsive_layout.dart';
import '../../../../shared/widgets/desktop_constrained_content.dart';
import '../../domain/entities/brand.dart';
import '../bloc/brand_management/brand_management_bloc.dart';
import '../bloc/brand_management/brand_management_state.dart';
import '../bloc/brand_list/brand_list_bloc.dart';
import '../bloc/brand_list/brand_list_state.dart';
import '../bloc/brand_list/brand_list_event.dart';
import '../widgets/create_brand_form.dart';

/// Edit Brand Page
/// Wrapper page for brand editing form
@RoutePage()
class EditBrandPage extends StatelessWidget {
  final String brandId;

  const EditBrandPage({
    Key? key,
    required this.brandId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => context.read<BrandManagementBloc>()),
        BlocProvider(create: (context) => context.read<BrandListBloc>()),
      ],
      child: BlocResponsiveLayout<BrandManagementBloc, BrandManagementState>(
        builder: (context, bloc, state, deviceType) {
          return EditBrandView(brandId: brandId, deviceType: deviceType);
        },
        listener: (context, state) {
          if (state is BrandManagementUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Brand berhasil diperbarui'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );

            // Navigate back to brand selection after successful update
            Future.delayed(const Duration(seconds: 2), () {
              context.router.maybePop();
            });
          } else if (state is BrandManagementError) {
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

class EditBrandView extends StatefulWidget {
  final String brandId;
  final DeviceType deviceType;

  const EditBrandView({
    Key? key,
    required this.brandId,
    required this.deviceType,
  }) : super(key: key);

  @override
  State<EditBrandView> createState() => _EditBrandViewState();
}

class _EditBrandViewState extends State<EditBrandView> {
  Brand? _brand;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBrand();
  }

  void _loadBrand() async {
    // Load brand data by ID
    context.read<BrandListBloc>().add(const LoadAllBrandDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BrandListBloc, BrandListState>(
          listener: (context, state) {
            if (state is BrandListLoaded) {
              // When brands are loaded, find our specific brand
              final brand = state.userBrands.firstWhere(
                (brand) => brand.id == widget.brandId,
                orElse: () => state.accessibleBrands.firstWhere(
                  (brand) => brand.id == widget.brandId,
                ),
              );
              setState(() {
                _brand = brand;
                _isLoading = false;
              });
            } else if (state is BrandListError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<BrandListBloc, BrandListState>(
        builder: (context, state) {
          final content = _buildContent(context, state);

          // Apply desktop constraint
          if (widget.deviceType == DeviceType.desktop) {
            return DesktopConstrainedContent(child: content);
          }

          return content;
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, BrandListState state) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t.brand.edit_brand,
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
                    AppColors.primary.withOpacity(0.1),
                    AppColors.primary.withOpacity(0.05),
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
                    FontAwesomeIcons.edit,
                    color: AppColors.onPrimary,
                    size: UIConstants.fontSizeXXLarge,
                  ),
                  const SizedBox(height: UIConstants.spacingDefault),
                  Text(
                    context.t.brand.edit_brand,
                    style: AppTextStyles.headline3.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: UIConstants.paddingSmall),
                  Text(
                    context.t.brand.edit_brand_description,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.onPrimary.withOpacity(0.9),
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
                    style: AppTextStyles.headline4.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: UIConstants.paddingSmall),

                  // Form Description
                  Text(
                    context.t.brand.brand_info_description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Brand Form
                  if (_isLoading) ...[
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ] else if (_brand != null) ...[
                    CreateBrandForm(brand: _brand!, deviceType: widget.deviceType),
                  ] else ...[
                    Center(
                      child: Text(context.t.brand.brand_not_found),
                    ),
                  ],
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