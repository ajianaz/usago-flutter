import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/widgets/animated_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../domain/entities/brand.dart';
import '../bloc/brand_bloc.dart';
import '../bloc/brand_event.dart';
import '../bloc/brand_state.dart';

/// Invite User Form Widget
/// Form to invite users to a brand with role selection
class InviteUserForm extends StatefulWidget {
  final Brand brand;

  const InviteUserForm({
    Key? key,
    required this.brand,
  }) : super(key: key);

  @override
  State<InviteUserForm> createState() => _InviteUserFormState();
}

class _InviteUserFormState extends State<InviteUserForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedRole = 'BRAND_ADMIN';
  bool _isLoading = false;

  // Available roles for brand invitations
  final List<Map<String, String>> _availableRoles = [
    {'value': 'BRAND_OWNER', 'label': 'Pemilik Brand'},
    {'value': 'BRAND_ADMIN', 'label': 'Admin Brand'},
    {'value': 'BRANCH_MANAGER', 'label': 'Manajer Cabang'},
    {'value': 'BRANCH_ADMIN', 'label': 'Admin Cabang'},
    {'value': 'BRANCH_STAFF', 'label': 'Staf Cabang'},
    {'value': 'CROSS_BRANCH_VIEWER', 'label': 'Penonton Lintas Cabang'},
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Field
          Text(
            'Email Pengguna',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          AnimatedTextField(
            controller: _emailController,
            labelText: 'Masukkan email pengguna yang ingin diundang',
            hintText: 'contoh: user@example.com',
            prefixIcon: Icon(FontAwesomeIcons.envelope, size: 20),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email wajib diisi';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                return 'Format email tidak valid';
              }
              return null;
            },
          ),
          SizedBox(height: AppSpacing.lg),

          // Role Selection
          Text(
            'Peran Pengguna',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedRole,
                isExpanded: true,
                hint: Text(
                  'Pilih peran',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                items: _availableRoles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role['value'],
                    child: Row(
                      children: [
                        Icon(
                          _getRoleIcon(role['value']!),
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          role['label']!,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: AppSpacing.lg),

          // Message Field (Optional)
          Text(
            'Pesan (Opsional)',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          AnimatedTextField(
            controller: _messageController,
            labelText: 'Pesan personal untuk pengguna (opsional)',
            hintText: 'Tambahkan pesan personal jika diperlukan',
            prefixIcon: Icon(FontAwesomeIcons.message, size: 20),
            maxLines: 3,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: AppSpacing.xl),

          // Submit Button
          CustomButton(
            text: 'Kirim Undangan',
            onPressed: _isLoading ? null : _submitForm,
            isLoading: _isLoading,
            isFullWidth: true,
            variant: ButtonVariant.primary,
            icon: const Icon(FontAwesomeIcons.paperPlane, size: 16),
          ),
        ],
      ),
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'BRAND_OWNER':
        return FontAwesomeIcons.crown;
      case 'BRAND_ADMIN':
        return FontAwesomeIcons.userShield;
      case 'BRANCH_MANAGER':
        return FontAwesomeIcons.usersGear;
      case 'BRANCH_ADMIN':
        return FontAwesomeIcons.userGear;
      case 'BRANCH_STAFF':
        return FontAwesomeIcons.user;
      case 'CROSS_BRANCH_VIEWER':
        return FontAwesomeIcons.eye;
      default:
        return FontAwesomeIcons.user;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final invitationData = {
        'email': _emailController.text.trim(),
        'role': _selectedRole,
        'message': _messageController.text.trim().isEmpty
            ? null
            : _messageController.text.trim(),
      };

      context.read<BrandBloc>().add(
        InviteUserEvent(widget.brand.id, invitationData),
      );

      // Reset loading state after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}

/// Dropdown button without underline
class DropdownButtonHideUnderline extends StatelessWidget {
  final Widget child;

  const DropdownButtonHideUnderline({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderlineContainer(
      child: child,
    );
  }
}

/// Container for dropdown button without underline
class DropdownButtonHideUnderlineContainer extends StatelessWidget {
  final Widget child;

  const DropdownButtonHideUnderlineContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
        ),
      ),
      child: child,
    );
  }
}