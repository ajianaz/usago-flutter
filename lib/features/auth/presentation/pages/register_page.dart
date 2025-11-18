import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../app/router.dart';
import '../../../../core/constants/animation_constants.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../shared/widgets/bloc_responsive_layout.dart';
import '../../../../shared/widgets/responsive_builder.dart';
import '../../../../shared/widgets/language_switcher.dart';
import '../../../../shared/widgets/theme_switcher.dart';
import '../../../../shared/widgets/animated_feedback.dart';
import '../../../../shared/themes/animation_theme.dart';
import '../../../../shared/utils/animation_utils.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/register_form.dart';

/// Register Page
/// Handles user registration with responsive design
@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
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
  }

  @override
  void dispose() {
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
      title: Text(context.t.authRegister),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
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
    if (state is AuthSuccess) {
      _showSuccessFeedback(context);
      Future.delayed(const Duration(milliseconds: 1500), () {
        context.router.replace(const HomeRoute());
      });
    } else if (state is AuthFailure) {
      _showErrorFeedback(context, state.message);
    }
  }

  void _showSuccessFeedback(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AnimatedToast(
          message: 'Registration successful! Redirecting...',
          type: FeedbackType.success,
          duration: const Duration(milliseconds: 1500),
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
    if (state is AuthLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (deviceType) {
      case DeviceType.desktop:
        return _buildDesktopLayout(context, authBloc);
      case DeviceType.tablet:
        return _buildTabletLayout(context, authBloc);
      case DeviceType.mobile:
        return _buildMobileLayout(context, authBloc);
    }
  }

  Widget _buildDesktopLayout(BuildContext context, AuthBloc authBloc) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Container(
          margin: const EdgeInsets.all(32.0),
          padding: const EdgeInsets.all(48.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left side - Welcome Section
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 48.0),
                  child: _buildWelcomeSection(context),
                ),
              ),
              // Right side - Register Form
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedBuilder(
                      animation: _staggeredAnimations[3],
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _staggeredAnimations[3],
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.2, 0.0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _contentController,
                              curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
                            )),
                            child: const RegisterForm(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildLoginLink(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, AuthBloc authBloc) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildWelcomeSection(context),
          ),
          const SizedBox(width: 32),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedBuilder(
                  animation: _staggeredAnimations[3],
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _staggeredAnimations[3],
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.2, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _contentController,
                          curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
                        )),
                        child: const RegisterForm(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                _buildLoginLink(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AuthBloc authBloc) {
    return SingleChildScrollView(
      padding: context.responsivePadding,
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
                  child: const RegisterForm(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildLoginLink(context),
        ],
      ),
    );
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
                        FontAwesomeIcons.userPlus,
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
                        context.t.authCreateAccount,
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
                        context.t.authSignUpToContinue,
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

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(context.t.authAlreadyHaveAccount),
        TextButton(
          onPressed: () {
            context.router.pushNamed('/login');
          },
          child: Text(context.t.authLogin),
        ),
      ],
    );
  }
}