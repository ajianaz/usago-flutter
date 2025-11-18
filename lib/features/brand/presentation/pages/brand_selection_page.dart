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
import '../../../../shared/widgets/custom_button.dart';
import '../../domain/entities/brand.dart';
import '../bloc/brand_bloc.dart';
import '../bloc/brand_event.dart';
import '../bloc/brand_state.dart';
import '../widgets/brand_card.dart';
import '../widgets/brand_selector.dart';

/// Brand Selection Page
/// Allows users to select from available brands or create new ones
@RoutePage()
class BrandSelectionPage extends StatelessWidget {
  const BrandSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BrandBloc>(
      create: (context) => BrandBloc(
        brandRepository: context.read(),
      ),
      child: const BrandSelectionView(),
    );
  }
}

class BrandSelectionView extends StatefulWidget {
  const BrandSelectionView({Key? key}) : super(key: key);

  @override
  State<BrandSelectionView> createState() => _BrandSelectionViewState();
}

class _BrandSelectionViewState extends State<BrandSelectionView> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _selectedBusinessType = 'SEMUA';
  String _selectedSortBy = 'NAMA';
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
    return BlocProvider<BrandBloc>(
      create: (context) => BrandBloc(
        brandRepository: context.read(),
      ),
      child: BlocListener<BrandBloc, BrandState>(
        listener: (context, state) {
          // Handle search state changes
          if (state is BrandSearchLoaded) {
            setState(() {
              _isSearching = false;
            });
          }
          if (state is BrandError) {
            setState(() {
              _isSearching = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<BrandBloc, BrandState>(
          builder: (context, state) {
            return ResponsiveBuilder(
              builder: (context, deviceType) {
                if (state is BrandLoading || state is BrandSearchLoading) {
                  return _buildLoadingState(context, deviceType);
                }

                if (state is BrandLoaded) {
                  return _buildContent(context, deviceType, state, null);
                }

                if (state is BrandSearchLoaded) {
                  return _buildContent(context, deviceType, null, state);
                }

                return _buildEmptyState(context, deviceType);
              },
            );
          },
        ),
      ),
    );
   }

  Widget _buildLoadingState(BuildContext context, DeviceType deviceType) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pilih Brand',
          style: AppTextStyles.headline5.copyWith(
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
              'Memuat brands...',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, DeviceType deviceType) {
    final isMobile = deviceType == DeviceType.mobile;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pilih Brand',
          style: AppTextStyles.headline5.copyWith(
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
                    Icons.business_outlined,
                    size: UIConstants.fontSizeXXXLarge,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: UIConstants.spacingDefault),
                  Text(
                    'Belum ada brand',
                    style: AppTextStyles.headline6.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: UIConstants.paddingSmall),
                  Text(
                    'Buat brand pertama untuk memulai bisnis Anda',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: UIConstants.spacingLarge),
            CustomButton(
              text: 'Buat Brand Baru',
              onPressed: () {
                context.router.pushNamed('/create-brand');
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
    DeviceType deviceType,
    BrandLoaded? loadedState,
    BrandSearchLoaded? searchState,
  ) {
    final isMobile = deviceType == DeviceType.mobile;
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
      return _buildEmptyState(context, deviceType);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isSearching ? 'Hasil Pencarian' : 'Pilih Brand',
          style: AppTextStyles.headline5.copyWith(
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
            child: _buildBrandList(context, deviceType, allBrands, activeBrand, isMobile),
          ),
        ],
      ),
      floatingActionButton: loadedState != null ? FloatingActionButton(
        onPressed: () {
          context.router.pushNamed('/create-brand');
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
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(UIConstants.borderRadiusDefault),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Cari brand...',
                  prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
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
                          icon: Icon(Icons.clear, color: AppColors.textSecondary),
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
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(UIConstants.borderRadiusDefault),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedBusinessType,
                isExpanded: false,
                hint: Text(
                  'Tipe',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                items: [
                  DropdownMenuItem(value: 'SEMUA', child: Text('Semua')),
                  DropdownMenuItem(value: 'SERVICE', child: Text('Layanan')),
                  DropdownMenuItem(value: 'RETAIL', child: Text('Ritel')),
                  DropdownMenuItem(value: 'MANUFACTURING', child: Text('Manufaktur')),
                  DropdownMenuItem(value: 'OTHER', child: Text('Lainnya')),
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
    DeviceType deviceType,
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
            showOptions: true,
          );
        },
      ),
    );
  }

  void _showEditBrandDialog(BuildContext context, Brand brand) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Brand'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Apakah Anda ingin mengedit brand ini?'),
            const SizedBox(height: UIConstants.paddingSmall),
            Text(
              '${brand.name}',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.router.maybePop(),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.router.maybePop();
              // Navigate to edit brand page with brand ID
              // The brand will be fetched on the edit page
              context.router.pushNamed('/edit-brand/${brand.id}');
            },
            child: Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showDeleteBrandDialog(BuildContext context, Brand brand) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Brand'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Apakah Anda yakin ingin menghapus brand ini?'),
            const SizedBox(height: UIConstants.paddingSmall),
            Text(
              '${brand.name}',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: UIConstants.paddingSmall),
            Text(
              'Tindakan ini tidak dapat dibatalkan.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.router.maybePop(),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.router.maybePop();
              context.read<BrandBloc>().add(DeleteBrandEvent(brand.id));
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text('Hapus'),
          ),
        ],
      ),
    );
  }
}