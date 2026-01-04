import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

/// Utility for getting platform-specific icons.
///
/// Uses actual brand SVG icons for TikTok and Facebook with original brand colors,
/// falls back to Iconsax icons for other platforms.
class PlatformIcons {
  PlatformIcons._();

  /// Returns a widget for the platform icon.
  ///
  /// For TikTok and Facebook, uses the actual brand SVG icons with their
  /// original brand colors (no color override).
  /// For other platforms, uses Iconsax icons with the specified color.
  ///
  /// [preserveBrandColor] - If true (default for brand icons), keeps original colors.
  /// Set to false to force color override on brand icons.
  static Widget getIcon(
    String platform, {
    double size = 24,
    Color? color,
    bool preserveBrandColor = true,
  }) {
    final platformLower = platform.toLowerCase();

    switch (platformLower) {
      case 'tiktok':
        // TikTok: Always use original brand colors (black/cyan/magenta)
        // Wrap in SizedBox to force exact size since SVG has large viewBox
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/icons/tiktok.svg',
            fit: BoxFit.contain,
          ),
        );
      case 'facebook':
        // Facebook: Always use original brand blue color
        // Wrap in SizedBox to force exact size since SVG has large viewBox
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/icons/facebook.svg',
            fit: BoxFit.contain,
          ),
        );
      default:
        return Icon(
          _getIconData(platformLower),
          size: size,
          color: color,
        );
    }
  }

  /// Returns an IconData for platforms without SVG assets.
  static IconData _getIconData(String platform) {
    switch (platform) {
      case 'instagram':
        return Iconsax.instagram;
      case 'youtube':
        return Iconsax.video_play;
      case 'twitter':
      case 'x':
        return Iconsax.message;
      case 'linkedin':
        return Iconsax.briefcase;
      case 'pinterest':
        return Iconsax.image;
      case 'snapchat':
        return Iconsax.camera;
      case 'whatsapp':
        return Iconsax.message_text;
      case 'telegram':
        return Iconsax.send_2;
      default:
        return Iconsax.global;
    }
  }

  /// Check if platform has a custom SVG icon.
  static bool hasSvgIcon(String platform) {
    final platformLower = platform.toLowerCase();
    return platformLower == 'tiktok' || platformLower == 'facebook';
  }

  /// Get asset path for platforms with SVG icons.
  static String? getSvgAssetPath(String platform) {
    final platformLower = platform.toLowerCase();
    switch (platformLower) {
      case 'tiktok':
        return 'assets/icons/tiktok.svg';
      case 'facebook':
        return 'assets/icons/facebook.svg';
      default:
        return null;
    }
  }
}
