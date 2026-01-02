/// Spacing & Radius system for Grow Out Loud
/// Based on 8-point grid system
/// All spacing uses multiples of 8
/// DESIGN PRINCIPLE: Flat design - No shadows, 16px radius everywhere
class AppSpacing {
  // ========== BASE UNITS ==========
  static const double base = 8.0; // 1 unit = 8px ⭐ BASE UNIT
  static const double baseHalf = 4.0; // 0.5 unit (fine-tuning only)

  // ========== STANDARD PADDING (Horizontal & Vertical) ==========
  /// Standard horizontal padding - used throughout app
  static const double paddingHorizontal = 16.0; // ⭐ STANDARD HORIZONTAL

  /// Standard vertical padding - used for buttons, chips, etc.
  static const double paddingVertical = 8.0; // ⭐ STANDARD VERTICAL

  // ========== INSET SPACING (Padding inside elements) ==========
  static const double insetXs = 4.0; // Chip padding, small badges
  static const double insetSm = 8.0; // Button padding (vertical)
  static const double insetMd = 16.0; // Card padding, input padding ⭐ MOST COMMON
  static const double insetLg = 24.0; // Modal padding, large card padding
  static const double insetXl = 32.0; // Screen edge margins (top/bottom)
  static const double inset2xl = 40.0; // Hero section padding

  // ========== STACK SPACING (Vertical spacing between elements) ==========
  static const double stack2xs = 4.0; // Tight grouping (label + input)
  static const double stackXs = 8.0; // Related items (list items)
  static const double stackSm = 12.0; // Form fields
  static const double stackMd = 16.0; // Paragraph spacing ⭐ MOST COMMON
  static const double stackLg = 24.0; // Section spacing
  static const double stackXl = 32.0; // Major section breaks
  static const double stack2xl = 40.0; // Screen section spacing
  static const double stack3xl = 48.0; // Hero spacing

  // ========== INLINE SPACING (Horizontal spacing between elements) ==========
  static const double inline2xs = 4.0; // Icon + text (tight)
  static const double inlineXs = 8.0; // Chip gap, badge spacing ⭐ MOST COMMON
  static const double inlineSm = 12.0; // Button icon + text
  static const double inlineMd = 16.0; // Card columns, form columns
  static const double inlineLg = 24.0; // Large card spacing
  static const double inlineXl = 32.0; // Screen columns (tablet+)

  // ========== BORDER RADIUS SYSTEM ==========
  // DESIGN SYSTEM RULE: 16px radius on ALL components (buttons, cards, inputs, chips, modals)
  static const double radius = 16.0; // ⭐ UNIVERSAL RADIUS - Use for EVERYTHING

  // Legacy radius values (deprecated - use radius instead)
  static const double radiusXs = 4.0; // Deprecated
  static const double radiusSm = 8.0; // Deprecated
  static const double radiusMd = 12.0; // Deprecated
  static const double radiusLg = 16.0; // Use radius instead
  static const double radiusXl = 24.0; // Deprecated
  static const double radiusFull = 999.0; // For circles only

  // ========== COMPONENT SIZING ==========
  // Touch Targets
  static const double touchTargetMin = 48.0; // Minimum touch target
  static const double touchTargetRecommended = 56.0; // Recommended for primary actions
  static const double iconButtonSize = 48.0; // Icon-only button (48x48)
  static const double fabRegular = 56.0; // FAB regular (56x56)
  static const double fabMini = 40.0; // FAB mini (40x40)
  static const double listItemMinHeight = 56.0; // List item minimum height

  // Screen Margins
  static const double screenMarginHorizontal = 16.0; // Left/right edge margins (mobile)
  static const double screenMarginVertical = 24.0; // Top/bottom margins (safe area aware)
  static const double screenMarginTablet = 32.0; // Tablet edge margins
  static const double maxContentWidth = 840.0; // Max content width (tablet, centered)

  // Card Sizing (Flat Design - No elevation)
  static const double cardPadding = 16.0; // Card internal padding
  static const double cardMargin = 16.0; // Card external margin
  static const double cardBorderRadius = 16.0; // Card border radius ⭐ STANDARD 16PX
  static const double cardMinHeight = 64.0; // Card minimum height
  static const double cardElevation = 0.0; // NO ELEVATION - Flat design

  // Button Sizing (Multiple sizes available)
  // Small Button
  static const double buttonHeightSmall = 36.0; // Small button height
  static const double buttonPaddingVerticalSmall = 8.0; // Small button vertical padding
  static const double buttonPaddingHorizontalSmall = 16.0; // Small button horizontal padding

  // Medium Button (Default)
  static const double buttonHeight = 48.0; // Default button height
  static const double buttonPaddingVertical = 8.0; // Default vertical padding ⭐
  static const double buttonPaddingHorizontal = 16.0; // Default horizontal padding ⭐

  // Large Button
  static const double buttonHeightLarge = 56.0; // Large button height
  static const double buttonPaddingVerticalLarge = 16.0; // Large button vertical padding
  static const double buttonPaddingHorizontalLarge = 24.0; // Large button horizontal padding

  // Button shared properties
  static const double buttonBorderRadius = 16.0; // Button border radius ⭐ STANDARD 16PX
  static const double buttonIconGap = 8.0; // Icon + text gap in buttons
  static const double buttonElevation = 0.0; // NO ELEVATION - Flat design

  // Input Fields (Flat Design)
  static const double inputHeight = 48.0; // Input field height
  static const double inputPaddingHorizontal = 16.0; // Input horizontal padding
  static const double inputPaddingVertical = 12.0; // Input vertical padding
  static const double inputBorderRadius = 16.0; // Input border radius ⭐ STANDARD 16PX
  static const double inputBorderWidth = 1.0; // Input border width

  // Chips (Flat Design)
  static const double chipHeight = 32.0; // Chip height
  static const double chipPaddingHorizontal = 16.0; // Chip horizontal padding
  static const double chipPaddingVertical = 8.0; // Chip vertical padding
  static const double chipBorderRadius = 16.0; // Chip border radius ⭐ STANDARD 16PX

  // Modals & Dialogs (Flat Design)
  static const double modalPadding = 24.0; // Modal internal padding
  static const double modalBorderRadius = 16.0; // Modal border radius ⭐ STANDARD 16PX
  static const double modalElevation = 0.0; // NO ELEVATION - Flat design

  // Icon Sizes
  static const double icon16 = 16.0; // Small badges, inline text icons
  static const double icon20 = 20.0; // Small buttons, list item icons
  static const double icon24 = 24.0; // ⭐ DEFAULT UI ICON SIZE
  static const double icon32 = 32.0; // Large buttons, emphasized icons
  static const double icon40 = 40.0; // FAB icons, hero icons
  static const double icon48 = 48.0; // Empty states, onboarding
  static const double icon64 = 64.0; // Large empty states, splash screens

  // Grid System (Mobile)
  static const int gridColumns = 4; // 4 columns on mobile
  static const double gridGutter = 16.0; // Space between columns
  static const double gridMargin = 16.0; // Screen edge to content

  // Divider Sizing
  static const double dividerThickness = 1.0; // Divider thickness
  static const double dividerIndent = 16.0; // Divider indent from edges
}
