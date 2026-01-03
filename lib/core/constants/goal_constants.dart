import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Goal type configuration for tracker goal chips.
class GoalConstants {
  GoalConstants._();

  /// All available goal types
  static const List<GoalInfo> goalTypes = [
    GoalInfo(
      id: 'product_launch',
      label: 'Product Launch',
      icon: Iconsax.box,
    ),
    GoalInfo(
      id: 'lead_generation',
      label: 'Lead Generation',
      icon: Iconsax.people,
    ),
    GoalInfo(
      id: 'brand_awareness',
      label: 'Brand Awareness',
      icon: Iconsax.eye,
    ),
    GoalInfo(
      id: 'sales',
      label: 'Sales',
      icon: Iconsax.shopping_cart,
    ),
    GoalInfo(
      id: 'engagement',
      label: 'Engagement',
      icon: Iconsax.heart,
    ),
    GoalInfo(
      id: 'traffic',
      label: 'Traffic',
      icon: Iconsax.global,
    ),
    GoalInfo(
      id: 'app_installs',
      label: 'App Installs',
      icon: Iconsax.mobile,
    ),
    GoalInfo(
      id: 'video_views',
      label: 'Video Views',
      icon: Iconsax.video_play,
    ),
  ];

  /// Get goal info by ID
  static GoalInfo? getGoal(String id) {
    try {
      return goalTypes.firstWhere((g) => g.id == id.toLowerCase());
    } catch (_) {
      return null;
    }
  }
}

/// Information about a goal type
class GoalInfo {
  final String id;
  final String label;
  final IconData icon;

  const GoalInfo({
    required this.id,
    required this.label,
    required this.icon,
  });
}
