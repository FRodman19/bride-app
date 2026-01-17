import 'package:flutter/material.dart';

/// Performance-optimized scroll physics for smooth 120Hz scrolling
///
/// **Why ClampingScrollPhysics?**
/// BouncingScrollPhysics has a confirmed Flutter bug (#142441) causing scroll lag
/// on 120Hz displays. ClampingScrollPhysics provides better performance on high
/// refresh rate devices (90Hz, 120Hz, 144Hz).
///
/// **Usage:**
/// ```dart
/// ListView.builder(
///   physics: const SmoothScrollPhysics(),
///   cacheExtent: ScrollPerformance.cacheExtent, // Pre-render offscreen items
///   itemBuilder: (context, index) => RepaintBoundary(
///     child: YourComplexWidget(items[index]),
///   ),
/// )
/// ```
///
/// **For fixed-height lists (optimal performance):**
/// ```dart
/// ListView.builder(
///   physics: const SmoothScrollPhysics(),
///   cacheExtent: ScrollPerformance.cacheExtent,
///   itemExtent: 80.0, // Fixed height - skips layout passes!
///   itemBuilder: (context, index) => YourWidget(items[index]),
/// )
/// ```
class SmoothScrollPhysics extends ClampingScrollPhysics {
  const SmoothScrollPhysics({super.parent});

  @override
  SmoothScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SmoothScrollPhysics(parent: buildParent(ancestor));
  }

  /// Lower velocity threshold for more responsive fling gestures
  /// Default: 50px/s (vs. 200px/s for default physics)
  @override
  double get minFlingVelocity => 50.0;

  /// Smaller drag threshold for immediate touch response
  /// Default: 3.5px (vs. 8px for default physics)
  @override
  double get dragStartDistanceMotionThreshold => 3.5;

  /// Minimum distance to trigger fling animation
  @override
  double get minFlingDistance => 50.0;
}

/// Performance optimization constants for 120Hz displays
///
/// **120Hz Display Requirements:**
/// - Target: 8.33ms per frame (vs. 16.66ms for 60Hz)
/// - Pre-render offscreen items to prevent jank
/// - Use RepaintBoundary on complex/animated items
/// - Specify itemExtent for fixed-height lists
///
/// **Best Practices:**
/// 1. Use ListView.builder (lazy loading)
/// 2. Apply cacheExtent (400-800px recommended)
/// 3. Add RepaintBoundary for complex cards
/// 4. Use const constructors where possible
/// 5. Set itemExtent if items have fixed height
class ScrollPerformance {
  ScrollPerformance._();

  /// Cache extent for pre-rendering offscreen items
  ///
  /// **Recommended values:**
  /// - 400px: Standard lists (2-3 screens of content)
  /// - 600px: Complex items with images
  /// - 800px: Very smooth scrolling (higher memory usage)
  ///
  /// Higher values = smoother scrolling but more memory usage
  static const double cacheExtent = 600.0;

  /// Larger cache for image-heavy lists
  static const double cacheExtentLarge = 800.0;

  /// Standard cache for simple lists
  static const double cacheExtentStandard = 400.0;

  /// Item height for fixed-height lists (IMPORTANT for performance!)
  ///
  /// Setting itemExtent allows Flutter to skip per-child layout passes,
  /// dramatically improving scroll performance.
  ///
  /// **Example:**
  /// ```dart
  /// ListView.builder(
  ///   itemExtent: 80.0, // All items are 80px tall
  ///   itemBuilder: (context, index) => FixedHeightCard(),
  /// )
  /// ```
  ///
  /// Set to specific height for your use case, or null for variable heights.
  static const double? itemExtent = null;

  /// Wrap complex list items in RepaintBoundary to isolate repaints
  ///
  /// **When to use RepaintBoundary:**
  /// - Items with animations (Lottie, AnimatedBuilder)
  /// - Items with images (Image.network, CachedNetworkImage)
  /// - Items that update independently (StreamBuilder, setState)
  /// - Complex card layouts with many widgets
  ///
  /// **When NOT to use:**
  /// - Simple text-only items
  /// - Already optimized with const constructors
  /// - Every single item (can hurt performance)
  ///
  /// **Usage:**
  /// ```dart
  /// ListView.builder(
  ///   itemBuilder: (context, index) => RepaintBoundary(
  ///     child: ComplexTrackerCard(trackers[index]),
  ///   ),
  /// )
  /// ```
  static const bool useRepaintBoundaryForComplexItems = true;
}
