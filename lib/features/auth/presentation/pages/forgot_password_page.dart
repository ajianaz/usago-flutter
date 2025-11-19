import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/animation_constants.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../shared/widgets/animated_button.dart';
import '../../../../shared/widgets/animated_feedback.dart';
import '../../../../shared/widgets/animated_text_field.dart';
import '../../../../shared/widgets/bloc_responsive_layout.dart';
import '../../../../shared/widgets/desktop_constrained_content.dart';
import '../../../../shared/widgets/language_switcher.dart';
import '../../../../shared/widgets/theme_switcher.dart';
import '../../../../shared/themes/animation_theme.dart';
import '../../../../shared/utils/animation_utils.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../i18n/translations.g.dart';

/// Forgot Password Page
/// Handles password reset requests with responsive design
@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;

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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pageEntryController.dispose();
    _contentController.dispose();
    super.dispose();
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
      title: Text(context.t.auth.forgot_password),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.pop();
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
    setState(() {
      _isSubmitting = state is AuthLoading;
    });

    if (state is PasswordResetEmailSent) {
      _showSuccessFeedback(context, state.email);
      // Navigate back to login after successful submission
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          if (context.mounted) {
            context.pop();
          }
        }
      });
    } else if (state is AuthFailure) {
      _showErrorFeedback(context, state.message);
    }
  }

  void _showSuccessFeedback(BuildContext context, String email) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AnimatedToast(
          message: context.t.messages.password_reset_email_sent,
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

  Widget _buildBody(BuildContext context, AuthBloc authBloc, AuthState state, DeviceType deviceType) {
    if (state is AuthLoading && _isSubmitting) {
      return const Center(child: CircularProgressIndicator());
    }

    final content = _buildUnconstrainedContent(context, deviceType, authBloc);

    // Apply desktop constraint
    if (deviceType == DeviceType.desktop) {
      return DesktopConstrainedContent(child: content);
    }

    return content;
  }

  Widget _buildUnconstrainedContent(BuildContext context, DeviceType deviceType, AuthBloc authBloc) {
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
            AnimatedBuilder(
              animation: _staggeredAnimations[3],
              builder: (context, child) {
                return FadeTransition(
                  opacity: _staggeredAnimations[3],
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.2),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _contentController,
                      curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
                    )),
                    child: _buildForgotPasswordForm(context, authBloc),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildBackToLoginLink(context),
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
          AnimatedBuilder(
            animation: _staggeredAnimations[3],
            builder: (context, child) {
              return FadeTransition(
                opacity: _staggeredAnimations[3],
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.2),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _contentController,
                    curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
                  )),
                  child: _buildForgotPasswordForm(context, authBloc),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          _buildBackToLoginLink(context),
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
      animation: Listenable.merge([_contentFadeAnimation, _contentSlideAnimation]),
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
                        context.t.auth.forgot_password,
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
                        context.t.auth.forgot_password_description,
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

  Widget _buildForgotPasswordForm(BuildContext context, AuthBloc authBloc) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          AnimatedTextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            labelText: context.t.auth.email,
            hintText: context.t.auth.enter_your_email,
            prefixIcon: const Icon(FontAwesomeIcons.envelope),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.t.validation.required;
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return context.t.validation.email_invalid;
              }
              return null;
            },
            enabled: !_isSubmitting,
          ),
          const SizedBox(height: 24),

          // Submit Button
          AnimatedButton(
            text: context.t.auth.send_reset_link,
            onPressed: _isSubmitting ? null : () => _submitForm(authBloc),
            isLoading: _isSubmitting,
            isFullWidth: true,
            size: AnimatedButtonSize.large,
          ),
        ],
      ),
    );
  }

  Widget _buildBackToLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(context.t.auth.remember_password),
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text(context.t.auth.back_to_login),
        ),
      ],
    );
  }

  void _submitForm(AuthBloc authBloc) {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      authBloc.add(ForgotPasswordEvent(email: email));
    }
  }
}
