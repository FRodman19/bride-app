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

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  String? _emailError;
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    setState(() {
      _emailError = Validators.email(_emailController.text);
    });

    if (_emailError != null) {
      return;
    }

    setState(() => _isLoading = true);

    final result = await ref.read(authProvider.notifier).resetPassword(
          _emailController.text.trim(),
        );

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result.success) {
          _emailSent = true;
        } else if (result.error != null) {
          _emailError = result.error;
        }
      });
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
        child: Padding(
          padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: GOLSpacing.space4),

              // Header
              Text(
                'Reset password',
                style: textTheme.displaySmall?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: GOLSpacing.space2),
              Text(
                _emailSent
                    ? 'Check your email for a password reset link'
                    : 'Enter your email and we\'ll send you a reset link',
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),

              const SizedBox(height: GOLSpacing.space7),

              if (_emailSent) ...[
                // Success state
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
                        child: Text(
                          'Password reset email sent to ${_emailController.text}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.stateSuccess,
                          ),
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
                // Email input
                AuthTextField(
                  label: 'Email',
                  hintText: 'Enter your email',
                  controller: _emailController,
                  errorText: _emailError,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleResetPassword(),
                  prefixIcon: Icon(
                    Iconsax.sms,
                    color: colors.textTertiary,
                  ),
                ),

                const SizedBox(height: GOLSpacing.space6),

                GOLButton(
                  label: 'Send Reset Link',
                  onPressed: _isLoading ? null : _handleResetPassword,
                  isLoading: _isLoading,
                  fullWidth: true,
                  size: GOLButtonSize.large,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
