import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../i18n/translations.g.dart';
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
  final DeviceType deviceType;

  const CreateBrandForm({
    Key? key,
    this.brand, // Optional brand for edit mode
    required this.deviceType,
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

  // Helper methods to get translated labels
  String _getBusinessTypeLabel(String value) {
    switch (value) {
      case 'SERVICE':
        return context.t.brand.service;
      case 'RETAIL':
        return context.t.brand.retail;
      case 'MANUFACTURING':
        return context.t.brand.manufacturing;
      case 'OTHER':
        return context.t.brand.other;
      default:
        return value;
    }
  }

  String _getTimezoneLabel(String value) {
    switch (value) {
      case 'Asia/Jakarta':
        return context.t.brand.timezone_jakarta;
      case 'Asia/Singapore':
        return context.t.brand.timezone_singapore;
      case 'Asia/Bangkok':
        return context.t.brand.timezone_bangkok;
      case 'Asia/Kuala_Lumpur':
        return context.t.brand.timezone_kuala_lumpur;
      case 'Asia/Manila':
        return context.t.brand.timezone_manila;
      case 'UTC':
        return context.t.brand.timezone_utc;
      default:
        return value;
    }
  }

  String _getCurrencyLabel(String value) {
    switch (value) {
      case 'IDR':
        return context.t.brand.currency_idr;
      case 'USD':
        return context.t.brand.currency_usd;
      case 'EUR':
        return context.t.brand.currency_eur;
      case 'SGD':
        return context.t.brand.currency_sgd;
      case 'MYR':
        return context.t.brand.currency_myr;
      case 'THB':
        return context.t.brand.currency_thb;
      case 'PHP':
        return context.t.brand.currency_php;
      default:
        return value;
    }
  }

  // Business type options
  final List<Map<String, String>> _businessTypes = [
    {'value': 'SERVICE', 'label': 'Service'},
    {'value': 'RETAIL', 'label': 'Retail'},
    {'value': 'MANUFACTURING', 'label': 'Manufacturing'},
    {'value': 'OTHER', 'label': 'Other'},
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
    {'value': 'IDR', 'label': 'Indonesian Rupiah (IDR)'},
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
    return _buildForm(context, widget.deviceType);
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
                    _isEditMode ? context.t.brand.edit_brand : context.t.brand.create_brand,
                    style: AppTextStyles.headline4Dynamic(context).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEditMode
                        ? context.t.brand.edit_brand_description
                        : context.t.brand.create_brand_description,
                    style: AppTextStyles.bodyMediumDynamic(context).copyWith(
                      color: AppColors.getTextSecondary(context),
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
                      labelText: context.t.brand.brand_name,
                      hintText: context.t.brand.enter_brand_name,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.t.brand.brand_name_required;
                        }
                        if (value.trim().length < 3) {
                          return context.t.brand.brand_name_min_length;
                        }
                        if (value.trim().length > 50) {
                          return context.t.brand.brand_name_max_length;
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: AppSpacing.md),

                    // Slug Field
                    AnimatedTextField(
                      controller: _slugController,
                      labelText: context.t.brand.slug,
                      hintText: context.t.brand.url_friendly_identifier,
                      keyboardType: TextInputType.text,
                      enabled: !_autoGenerateSlug || _isEditMode,
                      prefixIcon: Icon(
                        Icons.link,
                        size: 20,
                        color: AppColors.getTextSecondary(context),
                      ),
                      suffixIcon: !_isEditMode && _autoGenerateSlug
                          ? IconButton(
                              icon: Icon(
                                Icons.lock_open,
                                size: 20,
                                color: AppColors.getTextSecondary(context),
                              ),
                              onPressed: _toggleAutoGenerateSlug,
                              tooltip: context.t.brand.enable_manual_slug_input,
                            )
                          : (!_isEditMode ? IconButton(
                              icon: Icon(
                                Icons.lock,
                                size: 20,
                                color: AppColors.primary,
                              ),
                              onPressed: _toggleAutoGenerateSlug,
                              tooltip: context.t.brand.auto_generate_from_name_tooltip,
                            ) : null),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context.t.brand.slug_required;
                        }
                        if (value.trim().length < 3) {
                          return context.t.brand.slug_min_length;
                        }
                        if (value.trim().length > 50) {
                          return context.t.brand.slug_max_length;
                        }
                        // Check if slug contains only valid characters
                        if (!RegExp(r'^[a-z0-9-]+$').hasMatch(value.trim())) {
                          return context.t.brand.slug_invalid_characters;
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
                              return AppColors.getBorder(context);
                            }),
                            checkColor: AppColors.onPrimary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              context.t.brand.auto_generate_from_name,
                              style: AppTextStyles.bodySmallDynamic(context).copyWith(
                                color: AppColors.getTextSecondary(context),
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
                      labelText: context.t.brand.description,
                      hintText: context.t.brand.brand_description,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      validator: (value) {
                        if (value != null && value.trim().length > 500) {
                          return context.t.brand.description_max_length;
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: AppSpacing.md),

                    // Industry
                    AnimatedTextField(
                      controller: _industryController,
                      labelText: context.t.brand.industry,
                      hintText: context.t.brand.brand_industry,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value != null && value.trim().length > 100) {
                          return context.t.brand.industry_max_length;
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: AppSpacing.lg),

                    // Business Type Dropdown
                    Text(
                      context.t.brand.business_type,
                      style: AppTextStyles.bodyMediumDynamic(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      decoration: BoxDecoration(
                        borderRadius: AppSpacing.radiusSm,
                        border: Border.all(color: AppColors.getBorder(context)),
                      ),
                      child: DropdownButtonHideUnderline(
                        items: _businessTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type['value']!,
                            child: Text(
                              _getBusinessTypeLabel(type['value']!),
                              style: AppTextStyles.bodyMediumDynamic(context),
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
                      context.t.brand.timezone,
                      style: AppTextStyles.bodyMediumDynamic(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      decoration: BoxDecoration(
                        borderRadius: AppSpacing.radiusSm,
                        border: Border.all(color: AppColors.getBorder(context)),
                      ),
                      child: DropdownButtonHideUnderline(
                        items: _timezones.map((timezone) {
                          return DropdownMenuItem<String>(
                            value: timezone['value']!,
                            child: Text(
                              _getTimezoneLabel(timezone['value']!),
                              style: AppTextStyles.bodyMediumDynamic(context),
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
                      context.t.brand.currency,
                      style: AppTextStyles.bodyMediumDynamic(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      decoration: BoxDecoration(
                        borderRadius: AppSpacing.radiusSm,
                        border: Border.all(color: AppColors.getBorder(context)),
                      ),
                      child: DropdownButtonHideUnderline(
                        items: _currencies.map((currency) {
                          return DropdownMenuItem<String>(
                            value: currency['value']!,
                            child: Text(
                              _getCurrencyLabel(currency['value']!),
                              style: AppTextStyles.bodyMediumDynamic(context),
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
                          text: _isEditMode ? context.t.brand.update_brand_btn : context.t.brand.create_brand_btn,
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
      style: AppTextStyles.bodyMediumDynamic(context),
      dropdownColor: AppColors.getSurface(context),
      icon: Icon(
        Icons.arrow_drop_down,
        color: AppColors.getTextSecondary(context),
      ),
    );
  }
}