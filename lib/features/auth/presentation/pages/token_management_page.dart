import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/animation_constants.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../shared/widgets/bloc_responsive_layout.dart';
import '../../../../shared/widgets/desktop_constrained_content.dart';
import '../../../../shared/widgets/language_switcher.dart';
import '../../../../shared/widgets/theme_switcher.dart';
import '../../../../shared/widgets/animated_feedback.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/themes/animation_theme.dart';
import '../../../../shared/utils/animation_utils.dart';
import '../../../../shared/themes/app_colors.dart';
import '../../../../shared/themes/app_spacing.dart';
import '../../../../shared/themes/app_text_styles.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/token_card.dart';
import '../../../../i18n/translations.g.dart';

/// Token Management Page
/// Handles user session and token management with responsive design
@RoutePage()
class TokenManagementPage extends StatefulWidget {
  const TokenManagementPage({Key? key}) : super(key: key);

  @override
  State<TokenManagementPage> createState() => _TokenManagementPageState();
}

class _TokenManagementPageState extends State<TokenManagementPage>
    with TickerProviderStateMixin {
  late AnimationController _pageEntryController;
  late AnimationController _contentController;
  late Animation<double> _pageFadeAnimation;
  late Animation<Offset> _pageSlideAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;
  late List<Animation<double>> _staggeredAnimations;

  @override
  void initState() {
    super.initState();

    _pageEntryController = AnimationController(
      duration: AnimationTheme.pageTransitionDuration,
      vsync: this,
    );

    _contentController = AnimationController(
      duration: AnimationConstants.slowDuration,
      vsync: this,
    );

    _pageFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageEntryController,
      curve: AnimationTheme.pageTransitionCurve,
    ));

    _pageSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageEntryController,
      curve: AnimationTheme.pageTransitionCurve,
    ));

    _contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _staggeredAnimations = AnimationUtils.createStaggeredAnimations(
      controller: _contentController,
      count: 4,
      staggerDelay: const Duration(milliseconds: 150),
    );

    // Start animations
    _pageEntryController.forward().then((_) {
      _contentController.forward();
    });

    // Load tokens when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTokens();
    });
  }

  @override
  void dispose() {
    _pageEntryController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _loadTokens() {
    context.read<AuthBloc>().add(const GetRefreshTokensEvent());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pageEntryController,
      builder: (context, child) {
        return BlocResponsiveLayout<AuthBloc, AuthState>(
          builder: (context, authBloc, state, deviceType) {
            return FadeTransition(
              opacity: _pageFadeAnimation,
              child: SlideTransition(
                position: _pageSlideAnimation,
                child: Scaffold(
                  appBar: _buildAppBar(context),
                  body: _buildBody(context, authBloc, state, deviceType),
                ),
              ),
            );
          },
          listener: (context, state) {
            _handleAuthStates(context, state);
          },
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Token Management'),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.router.maybePop();
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: const ThemeSwitcher(),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: const LanguageSwitcher(),
        ),
      ],
    );
  }

  void _handleAuthStates(BuildContext context, AuthState state) {
    if (state is GetRefreshTokensSuccess) {
      _showSuccessFeedback(context, 'Tokens loaded successfully');
    } else if (state is RevokeTokenSuccess) {
      _showSuccessFeedback(context, 'Token revoked successfully');
      // Reload tokens after revoking
      _loadTokens();
    } else if (state is RevokeAllTokensSuccess) {
      _showSuccessFeedback(context, 'All tokens revoked successfully');
      // Reload tokens after revoking all
      _loadTokens();
    } else if (state is AuthFailure) {
      _showErrorFeedback(context, state.message);
    }
  }

  void _showSuccessFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AnimatedToast(
          message: message,
          type: FeedbackType.success,
          duration: const Duration(seconds: 2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  void _showErrorFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AnimatedToast(
          message: message,
          type: FeedbackType.error,
          duration: const Duration(seconds: 3),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  Widget _buildBody(BuildContext context, AuthBloc authBloc, AuthState state,
      DeviceType deviceType) {
    if (state is AuthLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final content = _buildUnconstrainedContent(context, deviceType, state);

    // Apply desktop constraint
    if (deviceType == DeviceType.desktop) {
      return DesktopConstrainedContent(child: content);
    }

    return content;
  }

  Widget _buildUnconstrainedContent(
      BuildContext context, DeviceType deviceType, AuthState state) {
    final padding = _getPaddingForDeviceType(deviceType);

    if (deviceType == DeviceType.mobile) {
      return SingleChildScrollView(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            _buildWelcomeSection(context),
            const SizedBox(height: 40),
            _buildTokenList(context, state),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      );
    }

    // Tablet layout (vertical like mobile, but with enhanced spacing)
    return SingleChildScrollView(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 80),
          _buildWelcomeSection(context),
          const SizedBox(height: 60),
          _buildTokenList(context, state),
          const SizedBox(height: 32),
          _buildActionButtons(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  EdgeInsets _getPaddingForDeviceType(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return context.responsivePadding;
      case DeviceType.tablet:
        return const EdgeInsets.all(32.0);
      case DeviceType.desktop:
        // Desktop content will be constrained, so we don't need special padding here
        return EdgeInsets.zero;
    }
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return AnimatedBuilder(
      animation:
          Listenable.merge([_contentFadeAnimation, _contentSlideAnimation]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _contentFadeAnimation,
          child: SlideTransition(
            position: _contentSlideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _staggeredAnimations[0],
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.8 + (_staggeredAnimations[0].value * 0.2),
                      child: Icon(
                        FontAwesomeIcons.key,
                        size: context.responsiveValue(
                          mobile: 48.0,
                          tablet: 64.0,
                          desktop: 96.0,
                        ),
                        color: context.colorScheme.primary,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                AnimatedBuilder(
                  animation: _staggeredAnimations[1],
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _staggeredAnimations[1],
                      child: Text(
                        'Token Management',
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontSize: context.responsiveFontSize(24),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                AnimatedBuilder(
                  animation: _staggeredAnimations[2],
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _staggeredAnimations[2],
                      child: Text(
                        'Manage your active sessions and devices',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: context.responsiveFontSize(16),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTokenList(BuildContext context, AuthState state) {
    if (state is GetRefreshTokensSuccess) {
      final tokens = state.tokens;

      if (tokens.isEmpty) {
        return _buildEmptyState(context);
      }

      return AnimatedBuilder(
        animation: _staggeredAnimations[3],
        builder: (context, child) {
          return FadeTransition(
            opacity: _staggeredAnimations[3],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Sessions',
                  style: AppTextStyles.headline6Dynamic(context).copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...tokens
                    .map((token) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TokenCard(
                            token: token,
                            onRevoke: () =>
                                _showRevokeTokenDialog(context, token),
                          ),
                        ))
                    .toList(),
              ],
            ),
          );
        },
      );
    }

    return _buildLoadingState(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingAllLg,
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: AppSpacing.radiusLg,
        border: Border.all(color: AppColors.getBorder(context)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: AppSpacing.paddingAllLg,
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: AppSpacing.radiusXl,
            ),
            child: Icon(
              FontAwesomeIcons.shieldHalved,
              size: 64,
              color: AppColors.info,
            ),
          ),
          AppSpacing.verticalGapLg,
          Text(
            'No Active Sessions',
            style: AppTextStyles.headline6Dynamic(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalGapSm,
          Text(
            'You don\'t have any active sessions on other devices',
            style: AppTextStyles.bodyMediumDynamic(context).copyWith(
              color: AppColors.getTextSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingAllLg,
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: AppSpacing.radiusLg,
        border: Border.all(color: AppColors.getBorder(context)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          AppSpacing.verticalGapMd,
          Text(
            'Loading sessions...',
            style: AppTextStyles.bodyMediumDynamic(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'Refresh Tokens',
          onPressed: _loadTokens,
          isFullWidth: true,
          icon: const Icon(Icons.refresh),
        ),
        AppSpacing.verticalGapMd,
        CustomButton(
          text: 'Revoke All Tokens',
          onPressed: () => _showRevokeAllTokensDialog(context),
          isFullWidth: true,
          variant: ButtonVariant.outline,
          icon: const Icon(Icons.delete_sweep),
        ),
      ],
    );
  }

  void _showRevokeTokenDialog(
      BuildContext context, Map<String, dynamic> token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Revoke Token'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to revoke this token?'),
            const SizedBox(height: 8),
            Text(
              'Device: ${token['deviceName'] ?? 'Unknown Device'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Last seen: ${token['lastSeen'] ?? 'Unknown'}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.router.maybePop(),
            child: Text(context.t.common.cancel),
          ),
          TextButton(
            onPressed: () {
              context.router.maybePop();
              context.read<AuthBloc>().add(
                    RevokeTokenEvent(refreshToken: token['token'] ?? ''),
                  );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text('Revoke'),
          ),
        ],
      ),
    );
  }

  void _showRevokeAllTokensDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Revoke All Tokens'),
        content: Text(
            'Are you sure you want to revoke all tokens? This will sign you out from all devices.'),
        actions: [
          TextButton(
            onPressed: () => context.router.maybePop(),
            child: Text(context.t.common.cancel),
          ),
          TextButton(
            onPressed: () {
              context.router.maybePop();
              context.read<AuthBloc>().add(const RevokeAllTokensEvent());
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text('Revoke All'),
          ),
        ],
      ),
    );
  }
}
