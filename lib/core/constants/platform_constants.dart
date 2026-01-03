/// Platform configuration for the Performance Tracker app.
///
/// Initial version: Facebook and TikTok only (hardcoded)
/// Custom platforms will be added in a future version.
///
/// Uses existing SVG assets from assets/icons/ directory.
/// Colors should come from GOLSemanticColors, not hardcoded here.
class PlatformConstants {
  PlatformConstants._();

  /// All available advertising platforms
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
