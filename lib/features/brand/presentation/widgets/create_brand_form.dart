import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../../../../shared/widgets/animated_text_field.dart';
import '../../../../shared/widgets/responsive_builder.dart';
import '../../domain/entities/brand.dart';
import '../bloc/brand_bloc.dart';
import '../bloc/brand_state.dart';
import '../bloc/brand_event.dart';

/// Brand Form Widget
/// Handles brand creation and editing with validation and auto-slug generation
class CreateBrandForm extends StatefulWidget {
  final Brand? brand; // Add brand parameter for edit mode

  const CreateBrandForm({
    Key? key,
    this.brand, // Optional brand for edit mode
  }) : super(key: key);

  @override
  State<CreateBrandForm> createState() => _CreateBrandFormState();
}

class _CreateBrandFormState extends State<CreateBrandForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _industryController = TextEditingController();

  String _selectedBusinessType = 'SERVICE';
  String _selectedTimezone = 'Asia/Jakarta';
  String _selectedCurrency = 'IDR';
  bool _autoGenerateSlug = true;
  bool get _isEditMode => widget.brand != null;

  // Business type options
  final List<Map<String, String>> _businessTypes = [
    {'value': 'SERVICE', 'label': 'Layanan'},
    {'value': 'RETAIL', 'label': 'Ritel'},
    {'value': 'MANUFACTURING', 'label': 'Manufaktur'},
    {'value': 'OTHER', 'label': 'Lainnya'},
  ];

  // Timezone options
  final List<Map<String, String>> _timezones = [
    {'value': 'Asia/Jakarta', 'label': 'Asia/Jakarta (WIB)'},
    {'value': 'Asia/Singapore', 'label': 'Asia/Singapore (SGT)'},
    {'value': 'Asia/Bangkok', 'label': 'Asia/Bangkok (ICT)'},
    {'value': 'Asia/Kuala_Lumpur', 'label': 'Asia/Kuala Lumpur (MYT)'},
    {'value': 'Asia/Manila', 'label': 'Asia/Manila (PHT)'},
    {'value': 'UTC', 'label': 'UTC'},
  ];

  // Currency options
  final List<Map<String, String>> _currencies = [
    {'value': 'IDR', 'label': 'Rupiah Indonesia (IDR)'},
    {'value': 'USD', 'label': 'US Dollar (USD)'},
    {'value': 'EUR', 'label': 'Euro (EUR)'},
    {'value': 'SGD', 'label': 'Singapore Dollar (SGD)'},
    {'value': 'MYR', 'label': 'Malaysian Ringgit (MYR)'},
    {'value': 'THB', 'label': 'Thai Baht (THB)'},
    {'value': 'PHP', 'label': 'Philippine Peso (PHP)'},
  ];

  @override
  void initState() {
    super.initState();
    // Pre-populate form if in edit mode
    if (_isEditMode) {
      _populateForm();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    _industryController.dispose();
    super.dispose();
  }

  void _populateForm() {
    final brand = widget.brand!;
    _nameController.text = brand.name;
    _slugController.text = brand.slug;
    _descriptionController.text = brand.description ?? '';
    _industryController.text = brand.industry ?? '';
    _selectedBusinessType = brand.businessType;
    _selectedTimezone = brand.timezone;
    _selectedCurrency = brand.currency;
    _autoGenerateSlug = false; // Disable auto-generation in edit mode
  }

  void _toggleAutoGenerateSlug() {
    setState(() {
      _autoGenerateSlug = !_autoGenerateSlug;
    });
    if (_autoGenerateSlug) {
      _generateSlug();
    }
  }

  void _generateSlug() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      final slug = name
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove special characters
          .replaceAll(RegExp(r'\s+'), '-') // Replace spaces with hyphens
          .replaceAll(RegExp(r'-+'), '-') // Remove multiple hyphens
          .trim();

      if (slug.isNotEmpty) {
        _slugController.text = slug;
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final brandData = {
        'name': _nameController.text.trim(),
        'slug': _slugController.text.trim(),
        'description': _descriptionController.text.trim(),
        'industry': _industryController.text.trim(),
        'business_type': _selectedBusinessType,
        'timezone': _selectedTimezone,
        'currency': _selectedCurrency,
        'settings': {},
      };

      if (_isEditMode) {
        context.read<BrandBloc>().add(UpdateBrandEvent(widget.brand!.id, brandData));
      } else {
        context.read<BrandBloc>().add(CreateBrandEvent(brandData));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return _buildForm(context, deviceType);
      },
    );
  }

  Widget _buildForm(BuildContext context, DeviceType deviceType) {
    final isMobile = deviceType == DeviceType.mobile;

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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isMobile ? AppSpacing.md : AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEditMode ? 'Edit Brand' : 'Buat Brand Baru',
                    style: AppTextStyles.headline4.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEditMode
                        ? 'Perbarui data brand Anda'
                        : 'Lengkapi data brand Anda dan mulai beroperasi',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.md),

            // Form Fields
            Container(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? AppSpacing.md : AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand Name
                    AnimatedTextField(
                      controller: _nameController,
                      labelText: 'Nama Brand',
                      hintText: 'Masukkan nama brand',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama brand wajib diisi';
                        }
                        if (value.trim().length < 3) {
                          return 'Nama brand minimal 3 karakter';
                        }
                        if (value.trim().length > 50) {
                          return 'Nama brand maksimal 50 karakter';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: AppSpacing.md),

                    // Slug Field
                    AnimatedTextField(
                      controller: _slugController,
                      labelText: 'Slug',
                      hintText: 'URL-friendly identifier',
                      keyboardType: TextInputType.text,
                      enabled: !_autoGenerateSlug || _isEditMode,
                      prefixIcon: Icon(
                        Icons.link,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      suffixIcon: !_isEditMode && _autoGenerateSlug
                          ? IconButton(
                              icon: Icon(
                                Icons.lock_open,
                                size: 20,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: _toggleAutoGenerateSlug,
                              tooltip: 'Enable manual slug input',
                            )
                          : (!_isEditMode ? IconButton(
                              icon: Icon(
                                Icons.lock,
                                size: 20,
                                color: AppColors.primary,
                              ),
                              onPressed: _toggleAutoGenerateSlug,
                              tooltip: 'Auto-generate from name',
                            ) : null),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Slug wajib diisi';
                        }
                        if (value.trim().length < 3) {
                          return 'Slug minimal 3 karakter';
                        }
                        if (value.trim().length > 50) {
                          return 'Slug maksimal 50 karakter';
                        }
                        // Check if slug contains only valid characters
                        if (!RegExp(r'^[a-z0-9-]+$').hasMatch(value.trim())) {
                          return 'Slug hanya boleh mengandung huruf kecil, angka, dan strip (-)';
                        }
                        return null;
                      },
                    ),

                    if (!_isEditMode) ...[
                      Row(
                        children: [
                          Checkbox(
                            value: _autoGenerateSlug,
                            onChanged: (value) {
                              setState(() {
                                _autoGenerateSlug = value ?? true;
                              });
                              if (_autoGenerateSlug) {
                                _generateSlug();
                              }
                            },
                            fillColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.primary;
                              }
                              return AppColors.border;
                            }),
                            checkColor: AppColors.onPrimary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Auto-generate dari nama',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    SizedBox(height: AppSpacing.md),

                    // Description
                    AnimatedTextField(
                      controller: _descriptionController,
                      labelText: 'Deskripsi',
                      hintText: 'Deskripsi singkat brand (opsional)',
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      validator: (value) {
                        if (value != null && value.trim().length > 500) {
                          return 'Deskripsi maksimal 500 karakter';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: AppSpacing.md),

                    // Industry
                    AnimatedTextField(
                      controller: _industryController,
                      labelText: 'Industri',
                      hintText: 'Industri brand (opsional)',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value != null && value.trim().length > 100) {
                          return 'Industri maksimal 100 karakter';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: AppSpacing.lg),

                    // Business Type Dropdown
                    Text(
                      'Tipe Bisnis',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      decoration: BoxDecoration(
                        borderRadius: AppSpacing.radiusSm,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        items: _businessTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type['value'],
                            child: Text(
                              type['label']!,
                              style: AppTextStyles.bodyMedium,
                            ),
                          );
                        }).toList(),
                        value: _selectedBusinessType,
                        onChanged: (value) {
                          setState(() {
                            _selectedBusinessType = value ?? 'SERVICE';
                          });
                        },
                      ),
                    ),

                    SizedBox(height: AppSpacing.lg),

                    // Timezone Dropdown
                    Text(
                      'Zona Waktu',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      decoration: BoxDecoration(
                        borderRadius: AppSpacing.radiusSm,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        items: _timezones.map((timezone) {
                          return DropdownMenuItem<String>(
                            value: timezone['value'],
                            child: Text(
                              timezone['label']!,
                              style: AppTextStyles.bodyMedium,
                            ),
                          );
                        }).toList(),
                        value: _selectedTimezone,
                        onChanged: (value) {
                          setState(() {
                            _selectedTimezone = value ?? 'Asia/Jakarta';
                          });
                        },
                      ),
                    ),

                    SizedBox(height: AppSpacing.lg),

                    // Currency Dropdown
                    Text(
                      'Mata Uang',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      decoration: BoxDecoration(
                        borderRadius: AppSpacing.radiusSm,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        items: _currencies.map((currency) {
                          return DropdownMenuItem<String>(
                            value: currency['value'],
                            child: Text(
                              currency['label']!,
                              style: AppTextStyles.bodyMedium,
                            ),
                          );
                        }).toList(),
                        value: _selectedCurrency,
                        onChanged: (value) {
                          setState(() {
                            _selectedCurrency = value ?? 'IDR';
                          });
                        },
                      ),
                    ),

                    SizedBox(height: AppSpacing.xl),

                    // Submit Button
                    BlocBuilder<BrandBloc, BrandState>(
                      builder: (context, state) {
                        return AnimatedButton(
                          text: _isEditMode ? 'Perbarui Brand' : 'Buat Brand',
                          isLoading: state is BrandLoading,
                          onPressed: _submitForm,
                          isFullWidth: true,
                          size: AnimatedButtonSize.large,
                        );
                      },
                    ),

                    SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom dropdown button without underline
class DropdownButtonHideUnderline<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final Function(T?)? onChanged;

  const DropdownButtonHideUnderline({
    Key? key,
    required this.items,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      onChanged: onChanged,
      items: items,
      underline: Container(),
      isExpanded: true,
      style: AppTextStyles.bodyMedium,
      dropdownColor: AppColors.surface,
      icon: Icon(
        Icons.arrow_drop_down,
        color: AppColors.textSecondary,
      ),
    );
  }
}