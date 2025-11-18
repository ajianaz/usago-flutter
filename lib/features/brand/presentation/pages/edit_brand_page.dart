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
import '../../../../shared/widgets/responsive_builder.dart';
import '../../domain/entities/brand.dart';
import '../bloc/brand_bloc.dart';
import '../bloc/brand_state.dart';
import '../bloc/brand_event.dart';
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
    return BlocProvider.value(
      value: getIt<BrandBloc>(),
      child: EditBrandView(brandId: brandId),
    );
  }
}

class EditBrandView extends StatefulWidget {
  final String brandId;

  const EditBrandView({
    Key? key,
    required this.brandId,
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
    context.read<BrandBloc>().add(GetBrandByIdEvent(widget.brandId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BrandBloc, BrandState>(
      listener: (context, state) {
        if (state is BrandOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Navigate back to brand selection after successful update
          Future.delayed(const Duration(seconds: 2), () {
            context.router.maybePop();
          });
        } else if (state is BrandError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is BrandLoaded) {
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
        }
      },
      child: BlocBuilder<BrandBloc, BrandState>(
        builder: (context, state) {
          return _buildContent(context, state);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, BrandState state) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Brand',
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
                    'Edit Brand',
                    style: AppTextStyles.headline3.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: UIConstants.paddingSmall),
                  Text(
                    'Perbarui data brand yang ada sesuai kebutuhan Anda',
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
                    'Perbarui informasi brand di bawah ini. Pastikan semua data yang diperlukan sudah benar.',
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
                    CreateBrandForm(brand: _brand!),
                  ] else ...[
                    const Center(
                      child: Text('Brand tidak ditemukan'),
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