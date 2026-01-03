import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../grow_out_loud/components/gol_buttons.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/utils/validators.dart';
import '../widgets/auth_text_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _isLoading = false;
  bool _emailConfirmationSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    // Clear previous errors and validate
    setState(() {
      _emailError = Validators.email(_emailController.text);
      _passwordError = Validators.password(_passwordController.text);
      _confirmPasswordError = Validators.confirmPassword(
        _confirmPasswordController.text,
        _passwordController.text,
      );
    });

    if (_emailError != null ||
        _passwordError != null ||
        _confirmPasswordError != null) {
      return;
    }

    setState(() => _isLoading = true);

    final result = await ref.read(authProvider.notifier).signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (mounted) {
      setState(() => _isLoading = false);

      if (result.requiresEmailConfirmation) {
        // Show email confirmation message
        setState(() {
          _emailConfirmationSent = true;
        });
      } else if (!result.success && result.error != null) {
        setState(() {
          _emailError = result.error;
        });
      }
      // If success without email confirmation, router will redirect
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, color: colors.textPrimary),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: GOLSpacing.space4),

              // Header
              Text(
                'Create account',
                style: textTheme.displaySmall?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: GOLSpacing.space2),
              Text(
                _emailConfirmationSent
                    ? 'Almost there! Check your email to confirm.'
                    : 'Start tracking your campaign performance',
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),

              const SizedBox(height: GOLSpacing.space7),

              if (_emailConfirmationSent) ...[
                // Email confirmation sent state
                Container(
                  padding: const EdgeInsets.all(GOLSpacing.space4),
                  decoration: BoxDecoration(
                    color: GOLPrimitives.success50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.tick_circle,
                        color: colors.stateSuccess,
                      ),
                      const SizedBox(width: GOLSpacing.space3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Check your email',
                              style: textTheme.titleSmall?.copyWith(
                                color: colors.stateSuccess,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: GOLSpacing.space1),
                            Text(
                              'We sent a confirmation link to ${_emailController.text}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: GOLSpacing.space6),

                GOLButton(
                  label: 'Back to Sign In',
                  onPressed: () => context.pop(),
                  fullWidth: true,
                  size: GOLButtonSize.large,
                ),
              ] else ...[
                // Email field
                AuthTextField(
                  label: 'Email',
                  hintText: 'Enter your email',
                  controller: _emailController,
                  errorText: _emailError,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icon(
                    Iconsax.sms,
                    color: colors.textTertiary,
                  ),
                ),

                const SizedBox(height: GOLSpacing.space4),

                // Password field
                AuthTextField(
                  label: 'Password',
                  hintText: 'Create a password (min 6 characters)',
                  controller: _passwordController,
                  errorText: _passwordError,
                  isPassword: true,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icon(
                    Iconsax.lock,
                    color: colors.textTertiary,
                  ),
                ),

                const SizedBox(height: GOLSpacing.space4),

                // Confirm password field
                AuthTextField(
                  label: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  controller: _confirmPasswordController,
                  errorText: _confirmPasswordError,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleSignup(),
                  prefixIcon: Icon(
                    Iconsax.lock,
                    color: colors.textTertiary,
                  ),
                ),

                const SizedBox(height: GOLSpacing.space6),

                // Sign up button
                GOLButton(
                  label: 'Create Account',
                  onPressed: _isLoading ? null : _handleSignup,
                  isLoading: _isLoading,
                  fullWidth: true,
                  size: GOLButtonSize.large,
                ),

                const SizedBox(height: GOLSpacing.space6),

                // Login link
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
                      onPressed: () => context.pop(),
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
            ],
          ),
        ),
      ),
    );
  }
}
