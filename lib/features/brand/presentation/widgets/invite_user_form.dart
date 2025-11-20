import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../../../../shared/widgets/animated_text_field.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../domain/entities/brand.dart';
import '../bloc/brand_invitation/brand_invitation_bloc.dart';
import '../bloc/brand_invitation/brand_invitation_event.dart';
import '../../../../i18n/translations.g.dart';

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
  List<String> _selectedBranchIds = [];
  bool _isLoading = false;

  // Available roles for brand invitations
  List<Map<String, String>> _availableRoles(BuildContext context) {
    return [
      {'value': 'BRAND_OWNER', 'label': context.t.brand.brand_owner},
      {'value': 'BRAND_ADMIN', 'label': context.t.brand.brand_admin},
      {'value': 'BRANCH_MANAGER', 'label': context.t.brand.branch_manager},
      {'value': 'BRANCH_ADMIN', 'label': context.t.brand.branch_admin},
      {'value': 'BRANCH_STAFF', 'label': context.t.brand.branch_staff},
      {'value': 'CROSS_BRANCH_VIEWER', 'label': context.t.brand.cross_branch_viewer},
    ];
  }

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
            context.t.brand.user_email_label,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          AnimatedTextField(
            controller: _emailController,
            labelText: context.t.brand.user_email_hint,
            hintText: context.t.brand.user_email_example,
            prefixIcon: Icon(FontAwesomeIcons.envelope, size: 20),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.t.brand.email_required;
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                return context.t.brand.email_invalid;
              }
              return null;
            },
          ),
          SizedBox(height: AppSpacing.lg),

          // Role Selection
          Text(
            context.t.brand.user_role_label,
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
                  context.t.brand.select_role_hint,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                items: _availableRoles(context).map((role) {
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

          // Branch Selection (Optional)
          if (_selectedRole == 'BRANCH_MANAGER' || _selectedRole == 'BRANCH_ADMIN' || _selectedRole == 'BRANCH_STAFF') ...[
            Text(
              context.t.brand.role_label,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih cabang untuk pengguna ini (opsional)',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  // TODO: Implement branch selection UI when branch data is available
                  // For now, we'll show a placeholder
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Fitur pemilihan cabang akan segera hadir',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),
          ],

          // Message Field (Optional)
          Text(
            '${context.t.brand.message_optional}',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          AnimatedTextField(
            controller: _messageController,
            labelText: context.t.brand.personal_message_hint,
            hintText: context.t.brand.personal_message_explanation,
            prefixIcon: Icon(FontAwesomeIcons.message, size: 20),
            maxLines: 3,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: AppSpacing.xl),

          // Submit Button
          CustomButton(
            text: context.t.brand.send_invitation,
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

      final email = _emailController.text.trim();
      final role = _selectedRole;
      final branchIds = _selectedBranchIds.isEmpty ? <String>[] : _selectedBranchIds.cast<String>();

      context.read<BrandInvitationBloc>().add(
        CreateInvitationEvent(
          brandId: widget.brand.id,
          email: email,
          role: role,
          branchIds: branchIds,
        ),
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