import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../grow_out_loud/components/gol_buttons.dart';
import '../../../grow_out_loud/components/gol_overlays.dart';
import '../../../providers/auth_provider.dart';
import '../../../routing/routes.dart';
import '../../../core/utils/validators.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../widgets/auth_text_field.dart';

/// Simple sign-up screen with all fields visible immediately and centered.
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isGoogleLoading = false;
  bool _isSignUpLoading = false;

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Handle Google sign-in (also handles sign-up automatically)
  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);

    final result = await ref.read(authProvider.notifier).signInWithGoogle();

    if (mounted) {
      setState(() => _isGoogleLoading = false);

      if (result.success) {
        // Show welcome message for all users
        final message = result.isNewUser
            ? 'Welcome to Rhydle! 👋'
            : 'Welcome back! 😊';

        showGOLToast(
          context,
          message,
          variant: GOLToastVariant.info,
        );
        // Router will automatically redirect to dashboard
      } else if (result.error != null) {
        showGOLToast(
          context,
          result.error!,
          variant: GOLToastVariant.error,
        );
      }
    }
  }

  /// Handle email/password sign-up
  Future<void> _handleSignUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _emailError = Validators.email(email);
      _passwordError = Validators.password(password);
      _confirmPasswordError = Validators.confirmPassword(
        confirmPassword,
        password,
      );
    });

    if (_emailError != null ||
        _passwordError != null ||
        _confirmPasswordError != null) {
      return;
    }

    setState(() => _isSignUpLoading = true);

    final result = await ref.read(authProvider.notifier).signUp(
      email: email,
      password: password,
    );

    if (mounted) {
      setState(() => _isSignUpLoading = false);

      if (result.success) {
        if (result.requiresEmailConfirmation) {
          showGOLToast(
            context,
            'Check your email to confirm your account',
            variant: GOLToastVariant.success,
          );
          // Navigate back to sign in
          context.go(Routes.auth);
        } else {
          // Show welcome message for new users
          showGOLToast(
            context,
            'Welcome to Rhydle! 👋',
            variant: GOLToastVariant.info,
          );
          // Router will automatically redirect to dashboard
        }
      } else if (result.error != null) {
        showGOLToast(
          context,
          result.error!,
          variant: GOLToastVariant.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  'Create Account',
                  style: textTheme.displaySmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: GOLSpacing.space2),
                Text(
                  'Sign up to get started',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: GOLSpacing.space7),

                // Google Sign-In Button
                GOLButton(
                  label: 'Continue with Google',
                  onPressed: _isGoogleLoading ? null : _handleGoogleSignIn,
                  isLoading: _isGoogleLoading,
                  fullWidth: true,
                  size: GOLButtonSize.large,
                  variant: GOLButtonVariant.secondary,
                ),

                const SizedBox(height: GOLSpacing.space5),

                // Divider with "OR"
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: colors.borderDefault,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: GOLSpacing.space3,
                      ),
                      child: Text(
                        'OR',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: colors.borderDefault,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: GOLSpacing.space5),

                // Email field
                AuthTextField(
                  label: l10n.email,
                  hintText: l10n.enterYourEmail,
                  controller: _emailController,
                  errorText: _emailError,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) {
                    if (_emailError != null) {
                      setState(() => _emailError = null);
                    }
                  },
                  prefixIcon: Icon(
                    Iconsax.sms,
                    color: colors.textTertiary,
                  ),
                ),

                const SizedBox(height: GOLSpacing.space4),

                // Password field
                AuthTextField(
                  label: l10n.password,
                  hintText: l10n.createPasswordHint,
                  controller: _passwordController,
                  errorText: _passwordError,
                  isPassword: true,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) {
                    if (_passwordError != null) {
                      setState(() => _passwordError = null);
                    }
                  },
                  prefixIcon: Icon(
                    Iconsax.lock,
                    color: colors.textTertiary,
                  ),
                ),

                const SizedBox(height: GOLSpacing.space4),

                // Confirm Password field
                AuthTextField(
                  label: l10n.confirmPassword,
                  hintText: l10n.reEnterPassword,
                  controller: _confirmPasswordController,
                  errorText: _confirmPasswordError,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) {
                    if (_confirmPasswordError != null) {
                      setState(() => _confirmPasswordError = null);
                    }
                  },
                  onSubmitted: (_) => _handleSignUp(),
                  prefixIcon: Icon(
                    Iconsax.lock,
                    color: colors.textTertiary,
                  ),
                ),

                const SizedBox(height: GOLSpacing.space6),

                // Sign Up button
                GOLButton(
                  label: l10n.createAccount,
                  onPressed: _isSignUpLoading ? null : _handleSignUp,
                  isLoading: _isSignUpLoading,
                  fullWidth: true,
                  size: GOLButtonSize.large,
                ),

                const SizedBox(height: GOLSpacing.space5),

                // Sign in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(Routes.auth),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Sign In',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.interactivePrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
