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

/// Simple sign-in screen with all fields visible immediately and centered.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isGoogleLoading = false;
  bool _isSignInLoading = false;

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handle Google sign-in
  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);

    final result = await ref.read(authProvider.notifier).signInWithGoogle();

    if (mounted) {
      setState(() => _isGoogleLoading = false);

      if (!result.success && result.error != null) {
        showGOLToast(
          context,
          result.error!,
          variant: GOLToastVariant.error,
        );
      }
    }
  }

  /// Handle email/password sign-in
  Future<void> _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _emailError = Validators.email(email);
      _passwordError = Validators.password(password);
    });

    if (_emailError != null || _passwordError != null) {
      return;
    }

    setState(() => _isSignInLoading = true);

    final result = await ref.read(authProvider.notifier).signIn(
      email: email,
      password: password,
    );

    if (mounted) {
      setState(() => _isSignInLoading = false);

      if (!result.success && result.error != null) {
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
                  'Welcome Back',
                  style: textTheme.displaySmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: GOLSpacing.space2),
                Text(
                  'Sign in to continue',
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
                  hintText: l10n.enterYourPassword,
                  controller: _passwordController,
                  errorText: _passwordError,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) {
                    if (_passwordError != null) {
                      setState(() => _passwordError = null);
                    }
                  },
                  onSubmitted: (_) => _handleSignIn(),
                  prefixIcon: Icon(
                    Iconsax.lock,
                    color: colors.textTertiary,
                  ),
                ),

                const SizedBox(height: GOLSpacing.space3),

                // Forgot password link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(Routes.forgotPassword),
                    child: Text(
                      l10n.forgotPassword,
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.interactivePrimary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: GOLSpacing.space5),

                // Sign In button
                GOLButton(
                  label: 'Sign In',
                  onPressed: _isSignInLoading ? null : _handleSignIn,
                  isLoading: _isSignInLoading,
                  fullWidth: true,
                  size: GOLButtonSize.large,
                ),

                const SizedBox(height: GOLSpacing.space5),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(Routes.signUp),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Sign Up',
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
