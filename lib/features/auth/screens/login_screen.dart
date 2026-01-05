import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../grow_out_loud/components/gol_buttons.dart';
import '../../../providers/auth_provider.dart';
import '../../../routing/routes.dart';
import '../../../core/utils/validators.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Clear previous errors and validate
    setState(() {
      _emailError = Validators.email(_emailController.text);
      _passwordError = Validators.password(_passwordController.text);
    });

    if (_emailError != null || _passwordError != null) {
      return;
    }

    setState(() => _isLoading = true);

    final result = await ref.read(authProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (mounted) {
      setState(() => _isLoading = false);

      if (!result.success && result.error != null) {
        setState(() {
          _passwordError = result.error;
        });
      }
      // If success, the router will automatically redirect to dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: GOLSpacing.space7),

                // Header
                Text(
                  l10n.welcomeBack,
                  style: textTheme.displaySmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: GOLSpacing.space2),
                Text(
                  l10n.signInToContinue,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),

                const SizedBox(height: GOLSpacing.space7),

                // Email field
                AuthTextField(
                  label: l10n.email,
                  hintText: l10n.enterYourEmail,
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
                  label: l10n.password,
                  hintText: l10n.enterYourPassword,
                  controller: _passwordController,
                  errorText: _passwordError,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(),
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

                const SizedBox(height: GOLSpacing.space6),

                // Login button
                GOLButton(
                  label: l10n.signIn,
                  onPressed: _isLoading ? null : _handleLogin,
                  isLoading: _isLoading,
                  fullWidth: true,
                  size: GOLButtonSize.large,
                ),

                const SizedBox(height: GOLSpacing.space6),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.dontHaveAccount,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(Routes.signUp),
                      child: Text(
                        l10n.signUp,
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
