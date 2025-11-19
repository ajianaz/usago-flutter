import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/utils/animation_utils.dart';
import '../../../../shared/widgets/bloc_responsive_layout.dart';
import '../../../../shared/widgets/desktop_constrained_content.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../domain/entities/brand.dart';
import '../bloc/brand_list/brand_list_bloc.dart';
import '../bloc/brand_list/brand_list_event.dart';
import '../bloc/brand_list/brand_list_state.dart';
import '../bloc/brand_switching/brand_switching_bloc.dart';
import '../bloc/brand_switching/brand_switching_event.dart';
import '../bloc/brand_switching/brand_switching_state.dart';
import '../widgets/brand_card.dart';
import '../widgets/brand_card_skeleton.dart';
import '../widgets/brand_selector.dart';
import '../services/brand_navigation_service.dart';
import '../../../../app/router.dart';
import '../../../../i18n/translations.g.dart';

/// Brand Selection Page
/// Allows users to select from available brands or create new ones
@RoutePage()
class BrandSelectionPage extends StatelessWidget {
  const BrandSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => context.read<BrandListBloc>()),
        BlocProvider(create: (context) => context.read<BrandSwitchingBloc>()),
      ],
      child: BlocResponsiveLayout<BrandListBloc, BrandListState>(
        builder: (context, bloc, state, deviceType) {
          return BrandSelectionView(deviceType: deviceType);
        },
        listener: (context, state) {
          if (state is BrandListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
      ),
    );
  }
}

class BrandSelectionView extends StatefulWidget {
  final DeviceType deviceType;

  const BrandSelectionView({super.key, required this.deviceType});

  @override
  State<BrandSelectionView> createState() => _BrandSelectionViewState();
}

class _BrandSelectionViewState extends State<BrandSelectionView>
    with TickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _selectedBusinessType = 'ALL';
  bool _isSearching = false;
  late AnimationController _animationController;
  late List<Animation<double>> _cardAnimations;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    // Initialize animation controller
    _animationController = AnimationController(
      duration: AnimationUtils.durationNormal,
      vsync: this,
    );

    // Load data saat page diinisialisasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BrandListBloc>().add(const LoadAllBrandDataEvent());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      _clearSearch();
    } else {
      _performSearch(query);
    }
  }

  void _performSearch(String query) {
    if (!_isSearching) {
      setState(() {
        _isSearching = true;
      });
      context.read<BrandListBloc>().add(FilterBrandsEvent(
        query: query,
        businessType: _selectedBusinessType == 'ALL' ? null : _selectedBusinessType,
      ));
    }
  }

  void _clearSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    context.read<BrandListBloc>().add(const ClearBrandFilterEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandListBloc, BrandListState>(
      builder: (context, state) {
        Widget content;
        if (state is BrandListLoading) {
          content = _buildLoadingState(context);
        } else if (state is BrandListLoaded) {
          content = _buildContent(context, state);
        } else if (state is BrandListEmpty) {
          content = _buildEmptyState(context, state.message);
        } else if (state is BrandListError) {
          content = _buildErrorState(context, state.message);
        } else {
          content = _buildEmptyState(context);
        }

        // Apply desktop constraint
        if (widget.deviceType == DeviceType.desktop) {
          return DesktopConstrainedContent(child: content);
        }

        return content;
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final isMobile = widget.deviceType == DeviceType.mobile;
    final crossAxisCount = isMobile ? 2 : 3;
    final childAspectRatio = isMobile ? 1.2 : 1.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t.brand.brand_selection,
          style: AppTextStyles.headline5Dynamic(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar skeleton
          Container(
            margin: AppSpacing.paddingAllMd,
            child: Container(
              height: 56.0,
              decoration: BoxDecoration(
                color: AppColors.getSurface(context),
                borderRadius: AppSpacing.radiusLg,
                border: Border.all(
                  color: AppColors.getBorder(context),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  AppSpacing.gapMd,
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.getTextSecondary(context).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  AppSpacing.gapMd,
                  Expanded(
                    child: Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.getTextSecondary(context).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  AppSpacing.gapMd,
                ],
              ),
            ),
          ),

          // Grid of skeleton cards
          Expanded(
            child: GridView.builder(
              padding: AppSpacing.paddingAllMd,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: childAspectRatio,
              ),
              itemCount: 6, // Show 6 skeleton cards
              itemBuilder: (context, index) {
                return BrandCardSkeleton(
                  deviceType: widget.deviceType,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, [String? message]) {
    final isMobile = widget.deviceType == DeviceType.mobile;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t.brand.brand_selection,
          style: AppTextStyles.headline5Dynamic(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.paddingAllLg,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isMobile ? double.infinity : 400,
                padding: AppSpacing.paddingAllXl,
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: AppSpacing.radiusLg,
                  border: Border.all(color: AppColors.getBorder(context)),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withValues(alpha: 0.12),
                      blurRadius: UIConstants.elevationCard,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: AppSpacing.paddingAllLg,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: AppSpacing.radiusXl,
                      ),
                      child: Icon(
                        Icons.business_outlined,
                        size: 80,
                        color: AppColors.primary,
                      ),
                    ),
                    AppSpacing.verticalGapLg,
                    Text(
                      message ?? context.t.brand.no_brands_available,
                      style: AppTextStyles.headline6Dynamic(context).copyWith(
                        color: AppColors.getTextPrimary(context),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.verticalGapSm,
                    Text(
                      context.t.brand.no_brands_message,
                      style: AppTextStyles.bodyMediumDynamic(context).copyWith(
                        color: AppColors.getTextSecondary(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.verticalGapMd,
                    Container(
                      padding: AppSpacing.paddingAllMd,
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: AppSpacing.radiusMd,
                        border: Border.all(
                          color: AppColors.info.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: AppColors.info,
                            size: 20,
                          ),
                          AppSpacing.gapSm,
                          Expanded(
                            child: Text(
                              context.t.brand.create_first_brand_message,
                              style: AppTextStyles.bodySmallDynamic(context).copyWith(
                                color: AppColors.getTextSecondary(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalGapLg,
              CustomButton(
                text: context.t.brand.create_new_brand,
                onPressed: () {
                  context.router.push(const CreateBrandRoute());
                },
                isFullWidth: !isMobile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final isMobile = widget.deviceType == DeviceType.mobile;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.t.brand.brand_selection,
          style: AppTextStyles.headline5Dynamic(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.paddingAllLg,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isMobile ? double.infinity : 400,
                padding: AppSpacing.paddingAllXl,
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: AppSpacing.radiusLg,
                  border: Border.all(color: AppColors.getBorder(context)),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withValues(alpha: 0.12),
                      blurRadius: UIConstants.elevationCard,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: AppSpacing.paddingAllLg,
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: AppSpacing.radiusXl,
                      ),
                      child: Icon(
                        Icons.error_outline,
                        size: 80,
                        color: AppColors.error,
                      ),
                    ),
                    AppSpacing.verticalGapLg,
                    Text(
                      'Terjadi Kesalahan',
                      style: AppTextStyles.headline6Dynamic(context).copyWith(
                        color: AppColors.getTextPrimary(context),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.verticalGapSm,
                    Text(
                      message,
                      style: AppTextStyles.bodyMediumDynamic(context).copyWith(
                        color: AppColors.getTextSecondary(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.verticalGapMd,
                    CustomButton(
                      text: 'Coba Lagi',
                      onPressed: () {
                        context.read<BrandListBloc>().add(const LoadAllBrandDataEvent());
                      },
                      isFullWidth: !isMobile,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    BrandListLoaded state,
  ) {
    final isMobile = widget.deviceType == DeviceType.mobile;
    final allBrands = state.allFilteredBrands;
    final activeBrand = state.activeBrand;

    if (allBrands.isEmpty) {
      return _buildEmptyState(context, 'Tidak ada brand ditemukan');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isSearching ? context.t.brand.search_results : context.t.brand.brand_selection,
          style: AppTextStyles.headline5Dynamic(context).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (!isMobile) ...[
            BrandSelector(
              currentBrand: activeBrand,
              availableBrands: allBrands,
              onBrandSelected: (brand) {
                context.read<BrandSwitchingBloc>().add(SwitchActiveBrandEvent(brandId: brand.id));
              },
              isCompact: true,
              deviceType: widget.deviceType,
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(context, isMobile),

          // Brand List
          Expanded(
            child: _buildBrandList(context, allBrands, activeBrand, isMobile),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.push(const CreateBrandRoute());
        },
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.add,
          color: AppColors.onPrimary,
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isMobile) {
    return Container(
      margin: AppSpacing.paddingAllMd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.getSurface(context),
          borderRadius: AppSpacing.radiusLg,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Input
            Container(
              decoration: BoxDecoration(
                color: AppColors.getSurface(context),
                borderRadius: BorderRadius.only(
                  topLeft: AppSpacing.radiusLg.topLeft,
                  topRight: AppSpacing.radiusLg.topRight,
                ),
                border: Border.all(
                  color: _focusNode.hasFocus
                    ? AppColors.primary.withOpacity(0.5)
                    : AppColors.getBorder(context),
                  width: _focusNode.hasFocus ? 2 : 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                style: AppTextStyles.bodyMediumDynamic(context),
                decoration: InputDecoration(
                  hintText: context.t.brand.search_brand,
                  hintStyle: AppTextStyles.bodyMediumDynamic(context).copyWith(
                    color: AppColors.getTextDisabled(context),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: _focusNode.hasFocus
                      ? AppColors.primary
                      : AppColors.getTextSecondary(context),
                  ),
                  suffixIcon: _isSearching
                      ? Padding(
                          padding: AppSpacing.paddingAllMd,
                          child: CircularProgressIndicator(
                            strokeWidth: UIConstants.strokeWidthProgress,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        )
                      : _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: AppColors.getTextSecondary(context),
                              ),
                              onPressed: _clearSearch,
                            )
                          : null,
                  border: InputBorder.none,
                  contentPadding: AppSpacing.paddingAllMd,
                ),
              ),
            ),

            // Filter Row
            Container(
              padding: AppSpacing.paddingHorizontalMd.copyWith(
                bottom: AppSpacing.md,
                top: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.getSurface(context),
                borderRadius: BorderRadius.only(
                  bottomLeft: AppSpacing.radiusLg.bottomLeft,
                  bottomRight: AppSpacing.radiusLg.bottomRight,
                ),
                border: Border.all(
                  color: AppColors.getBorder(context),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    size: 20,
                    color: AppColors.getTextSecondary(context),
                  ),
                  AppSpacing.gapSm,
                  Text(
                    'Filter by type:',
                    style: AppTextStyles.bodySmallDynamic(context).copyWith(
                      color: AppColors.getTextSecondary(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.gapMd,
                  Expanded(
                    child: Container(
                      padding: AppSpacing.paddingHorizontalSm.copyWith(
                        top: AppSpacing.xs,
                        bottom: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: AppSpacing.radiusSm,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedBusinessType,
                          isExpanded: true,
                          dropdownColor: AppColors.getSurface(context),
                          underline: const SizedBox(),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          style: AppTextStyles.bodyMediumDynamic(context).copyWith(
                            color: AppColors.getTextPrimary(context),
                            fontWeight: FontWeight.w600,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'ALL',
                              child: Row(
                                children: [
                                  Icon(Icons.apps, size: 16, color: AppColors.primary),
                                  AppSpacing.gapSm,
                                  Text(context.t.brand.all),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'SERVICE',
                              child: Row(
                                children: [
                                  Icon(Icons.support_agent, size: 16, color: AppColors.primary),
                                  AppSpacing.gapSm,
                                  Text(context.t.brand.service),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'RETAIL',
                              child: Row(
                                children: [
                                  Icon(Icons.shopping_cart, size: 16, color: AppColors.primary),
                                  AppSpacing.gapSm,
                                  Text(context.t.brand.retail),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'MANUFACTURING',
                              child: Row(
                                children: [
                                  Icon(Icons.precision_manufacturing, size: 16, color: AppColors.primary),
                                  AppSpacing.gapSm,
                                  Text(context.t.brand.manufacturing),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'OTHER',
                              child: Row(
                                children: [
                                  Icon(Icons.category, size: 16, color: AppColors.primary),
                                  AppSpacing.gapSm,
                                  Text(context.t.brand.other),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedBusinessType = value!;
                            });
                            _performSearch(_searchController.text);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandList(
    BuildContext context,
    List<Brand> brands,
    Brand? activeBrand,
    bool isMobile,
  ) {
    final crossAxisCount = isMobile ? 2 : 3;
    final childAspectRatio = isMobile ? 1.2 : 1.0;

    // Initialize animations for cards
    _cardAnimations = AnimationUtils.createStaggeredAnimations(
      controller: _animationController,
      count: brands.length,
      staggerDelay: const Duration(milliseconds: 50),
    );

    // Start the animation
    _animationController.forward();

    return RefreshIndicator(
      onRefresh: () async {
        context.read<BrandListBloc>().add(const RefreshBrandListEvent());
      },
      child: GridView.builder(
        padding: AppSpacing.paddingAllMd,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          final isActive = activeBrand?.id == brand.id;

          return AnimatedBuilder(
            animation: _cardAnimations[index],
            builder: (context, child) {
              return Transform.scale(
                scale: _cardAnimations[index].value,
                child: Opacity(
                  opacity: _cardAnimations[index].value,
                  child: BrandCard(
                    brand: brand,
                    isActive: isActive,
                    onTap: () {
                      context.read<BrandSwitchingBloc>().add(SwitchActiveBrandEvent(brandId: brand.id));
                    },
                    onEdit: () {
                      _showEditBrandDialog(context, brand);
                    },
                    onDelete: () {
                      _showDeleteBrandDialog(context, brand);
                    },
                    onViewStats: () {
                      _navigateToBrandStats(context, brand);
                    },
                    onViewInvitations: () {
                      _navigateToBrandInvitations(context, brand);
                    },
                    onTransfer: () {
                      _navigateToBrandTransfer(context, brand);
                    },
                    showOptions: true,
                    deviceType: widget.deviceType,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditBrandDialog(BuildContext context, Brand brand) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.brand.edit_brand_dialog_title, style: AppTextStyles.headline6Dynamic(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.t.brand.edit_brand_dialog_message, style: AppTextStyles.bodyMediumDynamic(context)),
            const SizedBox(height: UIConstants.paddingSmall),
            Text(
              brand.name,
              style: AppTextStyles.bodyMediumDynamic(context).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.router.maybePop(),
            child: Text(context.t.common.cancel, style: AppTextStyles.buttonMediumDynamic(context)),
          ),
          TextButton(
            onPressed: () {
              context.router.maybePop();
              // Navigate to edit brand page with brand ID
              // The brand will be fetched on the edit page
              context.router.push(EditBrandRoute(brandId: brand.id));
            },
            child: Text(context.t.common.edit, style: AppTextStyles.buttonMediumDynamic(context)),
          ),
        ],
      ),
    );
  }

  void _showDeleteBrandDialog(BuildContext context, Brand brand) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.brand.delete_brand_dialog_title, style: AppTextStyles.headline6Dynamic(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.t.brand.delete_brand_dialog_message, style: AppTextStyles.bodyMediumDynamic(context)),
            const SizedBox(height: UIConstants.paddingSmall),
            Text(
              brand.name,
              style: AppTextStyles.bodyMediumDynamic(context).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: UIConstants.paddingSmall),
            Text(
              context.t.brand.delete_brand_warning,
              style: AppTextStyles.bodySmallDynamic(context).copyWith(
                color: AppColors.getTextSecondary(context),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.router.maybePop(),
            child: Text(context.t.common.cancel, style: AppTextStyles.buttonMediumDynamic(context)),
          ),
          TextButton(
            onPressed: () {
              context.router.maybePop();
              // TODO: Implement delete with BrandManagementBloc
              // context.read<BrandManagementBloc>().add(DeleteBrandEvent(brand.id));
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text(context.t.common.delete, style: AppTextStyles.buttonMediumDynamic(context)),
          ),
        ],
      ),
    );
  }

  void _navigateToBrandStats(BuildContext context, Brand brand) {
    // Use navigation service for consistent navigation
    if (mounted) {
      BrandNavigationService.navigateToStats(context, brand);
    }
  }

  void _navigateToBrandInvitations(BuildContext context, Brand brand) {
    // Use navigation service for consistent navigation
    if (mounted) {
      BrandNavigationService.navigateToInvitations(context, brand);
    }
  }

  void _navigateToBrandTransfer(BuildContext context, Brand brand) {
    // Use navigation service for consistent navigation
    if (mounted) {
      BrandNavigationService.navigateToTransfer(context, brand);
    }
  }
}