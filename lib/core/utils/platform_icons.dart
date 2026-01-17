import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

/// Utility for getting platform-specific icons.
///
/// Phase 7.5: Expanded to 7 platforms with branded SVG icons
/// All platforms now use actual brand SVG icons with original colors
class PlatformIcons {
  PlatformIcons._();

  /// Returns a widget for the platform icon.
  ///
  /// All 7 platforms use branded SVG icons with original colors.
  /// No color overrides - keeps professional brand appearance.
  ///
  /// Supported platforms: Facebook, TikTok, Google Ads, LinkedIn, X, Reddit, YouTube
  static Widget getIcon(
    String platform, {
    double size = 24,
    Color? color,
    bool preserveBrandColor = true,
  }) {
    final platformLower = platform.toLowerCase();

    switch (platformLower) {
      case 'facebook':
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/icons/facebook.svg',
            fit: BoxFit.contain,
          ),
        );
      case 'tiktok':
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/icons/tiktok.svg',
            fit: BoxFit.contain,
          ),
        );
      case 'google-ads':
      case 'google ads':
      case 'googleads':
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/icons/google-ads.svg',
            fit: BoxFit.contain,
          ),
        );
      case 'linkedin':
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/icons/linkedin.svg',
            fit: BoxFit.contain,
          ),
        );
      case 'x':
      case 'twitter':
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/icons/x.svg',
            fit: BoxFit.contain,
          ),
        );
      case 'reddit':
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/icons/reddit.svg',
            fit: BoxFit.contain,
          ),
        );
      case 'youtube':
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.asset(
            'assets/icons/youtube.svg',
            fit: BoxFit.contain,
          ),
        );
      default:
        // Fallback to Iconsax for unknown platforms
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
    return platformLower == 'facebook' ||
        platformLower == 'tiktok' ||
        platformLower == 'google-ads' ||
        platformLower == 'google ads' ||
        platformLower == 'googleads' ||
        platformLower == 'linkedin' ||
        platformLower == 'x' ||
        platformLower == 'twitter' ||
        platformLower == 'reddit' ||
        platformLower == 'youtube';
  }

  /// Get asset path for platforms with SVG icons.
  static String? getSvgAssetPath(String platform) {
    final platformLower = platform.toLowerCase();
    switch (platformLower) {
      case 'facebook':
        return 'assets/icons/facebook.svg';
      case 'tiktok':
        return 'assets/icons/tiktok.svg';
      case 'google-ads':
      case 'google ads':
      case 'googleads':
        return 'assets/icons/google-ads.svg';
      case 'linkedin':
        return 'assets/icons/linkedin.svg';
      case 'x':
      case 'twitter':
        return 'assets/icons/x.svg';
      case 'reddit':
        return 'assets/icons/reddit.svg';
      case 'youtube':
        return 'assets/icons/youtube.svg';
      default:
        return null;
    }
  }
}
