import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../grow_out_loud/components/gol_buttons.dart';
import '../grow_out_loud/components/gol_cards.dart';
import '../grow_out_loud/foundation/gol_colors.dart';
import '../grow_out_loud/foundation/gol_spacing.dart';
import 'grow_out_loud_gallery_screen.dart';

class DesignSystemHome extends StatelessWidget {
  const DesignSystemHome({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo/Icon
              Icon(
                Iconsax.designtools,
                size: 80,
                color: colors.interactivePrimary,
              ),
              const SizedBox(height: GOLSpacing.space6),

              // Title
              Text(
                'Grow Out Loud',
                style: textTheme.displayMedium?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: GOLSpacing.space2),

              // Subtitle
              Text(
                'Flutter Design System',
                style: textTheme.titleLarge?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: GOLSpacing.space8),

              // Description Card
              GOLCard(
                variant: GOLCardVariant.elevated,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A modern, production-ready design system',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: GOLSpacing.space3),
                    _FeatureItem(
                      icon: Iconsax.colorfilter,
                      text: 'Material 3 with light/dark themes',
                      colors: colors,
                      textTheme: textTheme,
                    ),
                    const SizedBox(height: GOLSpacing.space2),
                    _FeatureItem(
                      icon: Iconsax.layer,
                      text: '14+ pre-built components',
                      colors: colors,
                      textTheme: textTheme,
                    ),
                    const SizedBox(height: GOLSpacing.space2),
                    _FeatureItem(
                      icon: Iconsax.ruler,
                      text: '8pt grid system',
                      colors: colors,
                      textTheme: textTheme,
                    ),
                    const SizedBox(height: GOLSpacing.space2),
                    _FeatureItem(
                      icon: Iconsax.document_text,
                      text: 'Comprehensive documentation',
                      colors: colors,
                      textTheme: textTheme,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: GOLSpacing.space8),

              // CTA Button
              GOLButton(
                label: 'View Component Gallery',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GrowOutLoudGalleryScreen(),
                    ),
                  );
                },
                icon: const Icon(Iconsax.gallery, size: 20),
                fullWidth: true,
              ),
              const SizedBox(height: GOLSpacing.space3),

              // Secondary info
              Text(
                'Clone this repo and start building your app with Grow Out Loud components',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final GOLSemanticColors colors;
  final TextTheme textTheme;

  const _FeatureItem({
    required this.icon,
    required this.text,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colors.interactivePrimary,
        ),
        const SizedBox(width: GOLSpacing.space2),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
