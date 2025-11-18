import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/widgets/bloc_responsive_layout.dart';
import '../../../../shared/widgets/desktop_constrained_content.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/animated_text_field.dart';
import '../../domain/entities/brand.dart';
import '../bloc/brand_bloc.dart';
import '../bloc/brand_event.dart';
import '../bloc/brand_state.dart';

/// Brand Ownership Transfer Page
/// Allows brand owners to transfer ownership to another user
@RoutePage()
class BrandTransferPage extends StatefulWidget {
  final Brand brand;

  const BrandTransferPage({
    super.key,
    required this.brand,
  });

  @override
  State<BrandTransferPage> createState() => _BrandTransferPageState();
}

class _BrandTransferPageState extends State<BrandTransferPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _confirmationCodeController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;
  bool _confirmationSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _confirmationCodeController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocResponsiveLayout<BrandBloc, BrandState>(
      builder: (context, bloc, state, deviceType) {
        return _buildContent(context, deviceType);
      },
      listener: (context, state) {
        if (state is BrandOperationSuccess) {
          setState(() {
            _isLoading = false;
            _confirmationSent = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
            ),
          );
        }
        if (state is BrandError) {
          setState(() {
            _isLoading = false;
          });
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

  Widget _buildContent(BuildContext context, DeviceType deviceType) {
    final isMobile = deviceType == DeviceType.mobile;

    final content = Scaffold(
      appBar: AppBar(
        title: Text(
          'Transfer Kepemilikanan Brand',
          style: AppTextStyles.headline5.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: _buildTransferForm(context, isMobile),
    );

    // Apply desktop constraint
    if (deviceType == DeviceType.desktop) {
      return DesktopConstrainedContent(child: content);
    }

    return content;
  }

  Widget _buildTransferForm(
    BuildContext context,
    bool isMobile,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? UIConstants.paddingSmall : UIConstants.paddingDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning Card
          _buildWarningCard(context, isMobile),
          SizedBox(height: AppSpacing.lg),

          // Transfer Form
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(UIConstants.borderRadiusLarge),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.12),
                  blurRadius: UIConstants.elevationCard,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detail Transfer',
                    style: AppTextStyles.headline6.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),

                  // Current Brand Info
                  _buildBrandInfo(context),
                  SizedBox(height: AppSpacing.lg),

                  // New Owner Email
                  Text(
                    'Email Pemilik Baru',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  AnimatedTextField(
                    controller: _emailController,
                    labelText: 'Masukkan email pemilik baru',
                    hintText: 'contoh: user@example.com',
                    prefixIcon: Icon(FontAwesomeIcons.envelope, size: UIConstants.fontSizeDefault),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email wajib diisi';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(value.trim())) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Confirmation Code (shown after sending confirmation)
                  if (_confirmationSent) ...[
                    Text(
                      'Kode Konfirmasi',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    AnimatedTextField(
                      controller: _confirmationCodeController,
                      labelText: 'Masukkan kode konfirmasi',
                      hintText: 'Kode 6 digit',
                      prefixIcon: Icon(FontAwesomeIcons.key, size: UIConstants.fontSizeDefault),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Kode konfirmasi wajib diisi';
                        }
                        if (value.length != 6) {
                          return 'Kode konfirmasi harus 6 digit';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // Optional Message
                    Text(
                      'Pesan (Opsional)',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    AnimatedTextField(
                      controller: _messageController,
                      labelText: 'Pesan untuk pemilik baru',
                      hintText: 'Tambahkan pesan penjelasan jika diperlukan',
                      prefixIcon: Icon(FontAwesomeIcons.message, size: UIConstants.fontSizeDefault),
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                    ),
                  ],

                  // Action Buttons
                  SizedBox(height: AppSpacing.xl),
                  if (_confirmationSent) ...[
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Konfirmasi Transfer',
                            onPressed: _isLoading ? null : _confirmTransfer,
                            isLoading: _isLoading,
                            isFullWidth: true,
                            variant: ButtonVariant.primary,
                            icon: const Icon(FontAwesomeIcons.check, size: UIConstants.fontSizeSmall),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: CustomButton(
                            text: 'Batal',
                            onPressed: () => context.router.maybePop(),
                            isFullWidth: true,
                            variant: ButtonVariant.outline,
                            icon: const Icon(FontAwesomeIcons.xmark, size: UIConstants.fontSizeSmall),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    CustomButton(
                      text: 'Kirim Kode Konfirmasi',
                      onPressed: _isLoading ? null : _sendConfirmationCode,
                      isLoading: _isLoading,
                      isFullWidth: true,
                      variant: ButtonVariant.primary,
                      icon: const Icon(FontAwesomeIcons.paperPlane, size: UIConstants.fontSizeSmall),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warningContainer,
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.warning),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.triangleExclamation,
                color: AppColors.warning,
                size: UIConstants.fontSizeLarge,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Peringatan Transfer Kepemilikanan',
                      style: AppTextStyles.headline6.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.warning,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Tindakan ini tidak dapat dibatalkan dan akan mengubah kepemilikanan brand secara permanen. Pastikan Anda memasukkan email yang benar dan pemilik baru telah menyetujui transfer ini.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onWarning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBrandInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusDefault),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: UIConstants.containerSizeSmall,
            height: UIConstants.containerSizeSmall,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(UIConstants.borderRadiusDefault),
            ),
            child: widget.brand.logoUrl != null
                ? Image.network(
                    widget.brand.logoUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.business,
                      color: AppColors.textSecondary,
                    ),
                  )
                : Icon(
                    Icons.business,
                    color: AppColors.primary,
                    size: UIConstants.fontSizeExtraLarge,
                  ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.brand.name,
                  style: AppTextStyles.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Brand ID: ${widget.brand.id}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  widget.brand.formattedBusinessType,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendConfirmationCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate sending confirmation code
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _confirmationSent = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kode konfirmasi telah dikirim ke email pemilik baru'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  void _confirmTransfer() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final newOwnerEmail = _emailController.text.trim();
      final confirmationCode = _confirmationCodeController.text.trim();

      context.read<BrandBloc>().add(
        TransferOwnershipEvent(
          widget.brand.id,
          newOwnerEmail,
          confirmationCode,
        ),
      );
    }
  }
}