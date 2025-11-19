import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/widgets/bloc_responsive_layout.dart';
import '../../../../shared/widgets/desktop_constrained_content.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../domain/entities/brand.dart';
import '../bloc/brand_bloc.dart';
import '../bloc/brand_event.dart';
import '../bloc/brand_state.dart';
import '../widgets/brand_card.dart';
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
    return BlocResponsiveLayout<BrandBloc, BrandState>(
      builder: (context, bloc, state, deviceType) {
        return BrandSelectionView(deviceType: deviceType);
      },
      listener: (context, state) {
        if (state is BrandError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
    );
  }
}

class BrandSelectionView extends StatefulWidget {
  final DeviceType deviceType;

  const BrandSelectionView({super.key, required this.deviceType});

  @override
  State<BrandSelectionView> createState() => _BrandSelectionViewState();
}

class _BrandSelectionViewState extends State<BrandSelectionView> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _selectedBusinessType = 'ALL';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
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
      context.read<BrandBloc>().add(SearchBrandsEvent(query));
    }
  }

  void _clearSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    context.read<BrandBloc>().add(const ClearBrandSearchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandBloc, BrandState>(
      builder: (context, state) {
        // Handle search state changes
        if (state is BrandSearchLoaded) {
          setState(() {
            _isSearching = false;
          });
        }

        Widget content;
        if (state is BrandLoading || state is BrandSearchLoading) {
          content = _buildLoadingState(context);
        } else if (state is BrandLoaded) {
          content = _buildContent(context, state, null);
        } else if (state is BrandSearchLoaded) {
          content = _buildContent(context, null, state);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            SizedBox(height: UIConstants.spacingDefault),
            Text(
              context.t.brand.loading_brands,
              style: AppTextStyles.bodyMediumDynamic(context).copyWith(
                color: AppColors.getTextSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isMobile ? double.infinity : 400,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: UIConstants.fontSizeXXXLarge,
                    color: AppColors.getTextSecondary(context),
                  ),
                  const SizedBox(height: UIConstants.spacingDefault),
                  Text(
                    context.t.brand.no_brands_available,
                    style: AppTextStyles.headline6Dynamic(context).copyWith(
                      color: AppColors.getTextSecondary(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: UIConstants.paddingSmall),
                  Text(
                    context.t.brand.no_brands_message,
                    style: AppTextStyles.bodyMediumDynamic(context).copyWith(
                      color: AppColors.getTextSecondary(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: UIConstants.spacingLarge),
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
    );
  }

  Widget _buildContent(
    BuildContext context,
    BrandLoaded? loadedState,
    BrandSearchLoaded? searchState,
  ) {
    final isMobile = widget.deviceType == DeviceType.mobile;
    List<Brand> allBrands;
    Brand? activeBrand;

    if (loadedState != null) {
      final userBrands = loadedState.userBrands;
      final accessibleBrands = loadedState.accessibleBrands;
      activeBrand = loadedState.activeBrand;
      allBrands = <Brand>[...userBrands, ...accessibleBrands];
    } else if (searchState != null) {
      allBrands = searchState.searchResults;
      activeBrand = null; // Don't show active brand in search results
    } else {
      allBrands = [];
      activeBrand = null;
    }

    if (allBrands.isEmpty && loadedState != null) {
      return _buildEmptyState(context);
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
          if (!isMobile && loadedState != null) ...[
            BrandSelector(
              currentBrand: activeBrand,
              availableBrands: allBrands,
              onBrandSelected: (brand) {
                context.read<BrandBloc>().add(SwitchBrandEvent(brand.id));
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
          if (loadedState != null) _buildSearchBar(context, isMobile),

          // Brand List
          Expanded(
            child: _buildBrandList(context, allBrands, activeBrand, isMobile),
          ),
        ],
      ),
      floatingActionButton: loadedState != null ? FloatingActionButton(
        onPressed: () {
          context.router.push(const CreateBrandRoute());
        },
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.add,
          color: AppColors.onPrimary,
        ),
      ) : null,
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isMobile) {
    return Container(
      margin: EdgeInsets.all(isMobile ? UIConstants.paddingSmall : UIConstants.paddingDefault),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.getSurface(context),
                borderRadius: BorderRadius.circular(UIConstants.borderRadiusDefault),
                border: Border.all(color: AppColors.getBorder(context)),
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
                  prefixIcon: Icon(Icons.search, color: AppColors.getTextSecondary(context)),
                  suffixIcon: _isSearching
                      ? SizedBox(
                          width: UIConstants.avatarSizeSmall,
                          height: UIConstants.avatarSizeSmall,
                          child: CircularProgressIndicator(
                            strokeWidth: UIConstants.strokeWidthProgress,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        )
                      : IconButton(
                          icon: Icon(Icons.clear, color: AppColors.getTextSecondary(context)),
                          onPressed: _clearSearch,
                        ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: UIConstants.paddingDefault, vertical: UIConstants.paddingSmall),
                ),
              ),
            ),
          ),
          SizedBox(width: UIConstants.paddingSmall),
          // Business Type Filter
          Container(
            padding: EdgeInsets.symmetric(horizontal: UIConstants.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.getSurface(context),
              borderRadius: BorderRadius.circular(UIConstants.borderRadiusDefault),
              border: Border.all(color: AppColors.getBorder(context)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBusinessType,
                isExpanded: false,
                dropdownColor: AppColors.getSurface(context),
                hint: Text(
                  context.t.brand.type,
                  style: AppTextStyles.bodyMediumDynamic(context).copyWith(
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: 'ALL', child: Text(context.t.brand.all, style: AppTextStyles.bodyMediumDynamic(context))),
                  DropdownMenuItem(value: 'SERVICE', child: Text(context.t.brand.service, style: AppTextStyles.bodyMediumDynamic(context))),
                  DropdownMenuItem(value: 'RETAIL', child: Text(context.t.brand.retail, style: AppTextStyles.bodyMediumDynamic(context))),
                  DropdownMenuItem(value: 'MANUFACTURING', child: Text(context.t.brand.manufacturing, style: AppTextStyles.bodyMediumDynamic(context))),
                  DropdownMenuItem(value: 'OTHER', child: Text(context.t.brand.other, style: AppTextStyles.bodyMediumDynamic(context))),
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
        ],
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

    return RefreshIndicator(
      onRefresh: () async {
        context.read<BrandBloc>().add(LoadUserBrandsEvent());
      },
      child: GridView.builder(
        padding: EdgeInsets.all(isMobile ? UIConstants.paddingSmall : UIConstants.paddingDefault),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: isMobile ? UIConstants.paddingSmall : UIConstants.paddingDefault,
          crossAxisSpacing: isMobile ? UIConstants.paddingSmall : UIConstants.paddingDefault,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          final isActive = activeBrand?.id == brand.id;

          return BrandCard(
            brand: brand,
            isActive: isActive,
            onTap: () {
              context.read<BrandBloc>().add(SwitchBrandEvent(brand.id));
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
              context.read<BrandBloc>().add(DeleteBrandEvent(brand.id));
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