/// Platform configuration for the Performance Tracker app.
///
/// Phase 7.5: Expanded to 7 platforms with branded SVG icons
///
/// Uses existing SVG assets from assets/icons/ directory.
/// Colors should come from GOLSemanticColors, not hardcoded here.
class PlatformConstants {
  PlatformConstants._();

  /// All available advertising platforms (7 total)
  static const List<PlatformInfo> platforms = [
    PlatformInfo(
      id: 'facebook',
      name: 'Facebook',
      svgAssetPath: 'assets/icons/facebook.svg',
    ),
    PlatformInfo(
      id: 'tiktok',
      name: 'TikTok',
      svgAssetPath: 'assets/icons/tiktok.svg',
    ),
    PlatformInfo(
      id: 'google-ads',
      name: 'Google Ads',
      svgAssetPath: 'assets/icons/google-ads.svg',
    ),
    PlatformInfo(
      id: 'linkedin',
      name: 'LinkedIn',
      svgAssetPath: 'assets/icons/linkedin.svg',
    ),
    PlatformInfo(
      id: 'x',
      name: 'X',
      svgAssetPath: 'assets/icons/x.svg',
    ),
    PlatformInfo(
      id: 'reddit',
      name: 'Reddit',
      svgAssetPath: 'assets/icons/reddit.svg',
    ),
    PlatformInfo(
      id: 'youtube',
      name: 'YouTube',
      svgAssetPath: 'assets/icons/youtube.svg',
    ),
  ];

  /// Get platform by ID
  static PlatformInfo? getPlatform(String id) {
    try {
      return platforms.firstWhere((p) => p.id == id.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  /// Default platforms for new trackers
  static List<String> get defaultPlatformIds => ['facebook', 'tiktok'];
}

/// Information about an advertising platform
class PlatformInfo {
  final String id;
  final String name;
  final String svgAssetPath;

  const PlatformInfo({
    required this.id,
    required this.name,
    required this.svgAssetPath,
  });
}
