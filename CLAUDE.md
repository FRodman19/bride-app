# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Grow Out Loud** - A Flutter mobile application with an execution system focus. The app features a clean, modern design with both light and dark mode support.

## Implementation Plan

Before building any feature, ALWAYS read: `IMPLEMENTATION_PLAN.md`

This is the single source of truth for:
- What to build (screens, features)
- How to build it (edge cases, validation rules)
- What's already built (checkboxes)
- What NOT to do (BAD examples)

**DO NOT** create separate planning documents.
**DO NOT** build screens without wireframes.

### Key Reference Files:
| File | Purpose |
|------|---------|
| `IMPLEMENTATION_PLAN.md` | What to build, progress tracking |
| `performance-section-wireframe.md` | Screen designs & layouts (in parent dir) |
| `performance-architech.md` | Navigation flows & user journeys (in parent dir) |
| `CLAUDE.md` | Development guidelines & rules |

## ⚠️ CRITICAL: Design System First Approach

**ALWAYS use the Grow Out Loud (GOL) design system** when building any UI component or feature:

### Design System Location
- **Components**: `lib/grow_out_loud/components/`
- **Foundation**: `lib/grow_out_loud/foundation/`
- **Gallery/Reference**: `lib/screens/grow_out_loud_gallery_screen.dart` (Run in debug mode: `/design-system-v3`)

### Mandatory Rules
1. **NEVER create custom UI components** - Always use existing GOL components first
2. **NEVER use arbitrary spacing** - Use `GOLSpacing` constants (8pt grid system)
3. **NEVER use custom colors** - Use `GOLSemanticColors` from theme
4. **NEVER use arbitrary font sizes** - Use `textTheme` styles from `GOLTypography`
5. **NEVER use emojis** - Always use Iconsax icons (prefer outline variants by default)
6. **If a component doesn't exist** - Create it following GOL patterns and add it to the gallery

### UI Design Patterns (CRITICAL)

These patterns ensure consistency and professional appearance across all screens:

#### Card Layouts - Compact & Tight
**ALWAYS make cards compact by placing icons and text on the same horizontal line:**

```dart
// ✅ CORRECT - Horizontal layout (clean, compact)
Row(
  children: [
    Icon(Iconsax.code, size: 32, color: colors.interactivePrimary),
    const SizedBox(width: GOLSpacing.space3),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Title', style: textTheme.headlineSmall),
          Text('Subtitle', style: textTheme.bodySmall),
        ],
      ),
    ),
    Text('Value', style: textTheme.headlineMedium),
  ],
)

// ❌ WRONG - Vertical layout (too tall, wastes space)
Column(
  children: [
    Icon(Iconsax.code, size: 32),
    SizedBox(height: 8),
    Text('Title'),
    Text('Subtitle'),
  ],
)
```

#### Icon Usage Rules
1. **NEVER use emojis** - They look unprofessional and inconsistent
2. **ALWAYS use Iconsax icons** - Prefer outline variants by default
3. **Outline by default** - `Iconsax.code`, `Iconsax.global`, `Iconsax.microphone`
4. **Filled when needed** - Use filled variants only for specific design requirements
5. **Consistent sizing** - 32px for card icons, 16px for inline icons, 14px for labels

```dart
// ✅ CORRECT - Outline icons (default)
Icon(Iconsax.code, size: 32, color: colors.interactivePrimary)
Icon(Iconsax.global, size: 32, color: colors.interactivePrimary)

// ⚠️ USE SPARINGLY - Filled icons (only when specifically needed)
Icon(Iconsax.code_15, size: 32, color: colors.interactivePrimary)

// ❌ WRONG
Text('🐍', style: TextStyle(fontSize: 32))  // Never use emojis!
```

#### Quick Actions Pattern
**Full-width distribution with even spacing:**

```dart
// ✅ CORRECT - Fills width evenly
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    _QuickActionItem(icon: Iconsax.folder_add, label: 'New\nProject'),
    _QuickActionItem(icon: Iconsax.book, label: 'New\nSkill'),
    _QuickActionItem(icon: Iconsax.document, label: 'New\nContent'),
    _QuickActionItem(icon: Iconsax.chart, label: 'Daily\nEntry'),
    _QuickActionItem(icon: Iconsax.cpu, label: 'Open\nAssist'),
  ],
)

// ❌ WRONG - Horizontal scroll with empty space on right
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(children: [...]),  // Creates empty space
)
```

#### Metric/Overview Cards
**Number and subtitle on same horizontal line:**

```dart
// ✅ CORRECT - Horizontal alignment (clean)
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      children: [
        Icon(icon, size: 20),
        SizedBox(width: GOLSpacing.space2),
        Text('TITLE', style: textTheme.labelSmall),
      ],
    ),
    SizedBox(height: GOLSpacing.space2),
    Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('94%', style: textTheme.displaySmall),
        SizedBox(width: GOLSpacing.space2),
        Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Text('Weekly score', style: textTheme.bodySmall),
        ),
      ],
    ),
  ],
)

// ❌ WRONG - Vertical stack (too tall)
Column(
  children: [
    Icon(icon),
    Text('TITLE'),
    Text('94%'),  // Number alone
    Text('Weekly score'),  // Subtitle below
  ],
)
```

#### Combined Metric Cards
**Use single card with dividers instead of multiple cards:**

```dart
// ✅ CORRECT - Single compact card with vertical dividers
GOLCard(
  variant: GOLCardVariant.elevated,
  child: IntrinsicHeight(
    child: Row(
      children: [
        Expanded(child: _MetricSection(title: 'NET PROFIT', value: '\$8,240')),
        Container(width: 1, color: colors.borderDefault, margin: EdgeInsets.symmetric(horizontal: GOLSpacing.space3)),
        Expanded(child: _MetricSection(title: 'REVENUE', value: '\$12,400')),
        Container(width: 1, color: colors.borderDefault, margin: EdgeInsets.symmetric(horizontal: GOLSpacing.space3)),
        Expanded(child: _MetricSection(title: 'SPEND', value: '\$4,159')),
      ],
    ),
  ),
)

// ❌ WRONG - Separate cards (too tall, wastes space)
Row(
  children: [
    Expanded(child: GOLCard(child: _MetricSection(...))),
    SizedBox(width: 8),
    Expanded(child: GOLCard(child: _MetricSection(...))),
  ],
)
```

#### Navigation Behavior
**Simple, clean interactions - NO fancy animations:**

```dart
// ✅ CORRECT
BottomNavigationBar(
  enableFeedback: false,  // Disable pop animation
  onTap: _onItemTapped,
  // ...
)

// ❌ WRONG
BottomNavigationBar(
  enableFeedback: true,  // Creates distracting pop animation
  // ...
)
```

#### Overflow Prevention
**Use FittedBox and Flexible for dynamic content:**

```dart
// ✅ CORRECT - Scales down if needed
FittedBox(
  fit: BoxFit.scaleDown,
  alignment: Alignment.centerLeft,
  child: Text('\$8,240', style: textTheme.headlineMedium),
)

// ✅ CORRECT - Wraps text labels
Flexible(
  child: Text('REVENUE', style: textTheme.labelSmall),
)

// ❌ WRONG - Can overflow on small screens
Text('\$8,240.50', style: textTheme.displayLarge)  // No flex/fitted
```

See: `lib/grow_out_loud/foundation/DESIGN_PATTERNS.md` for detailed examples

### Quick Reference
```dart
// ✅ CORRECT - Use design system
GOLButton(label: 'Save', onPressed: () {})
SizedBox(height: GOLSpacing.space4)  // 16px, follows 8pt grid
Text('Title', style: Theme.of(context).textTheme.headlineSmall)
color: colors.textPrimary

// ❌ WRONG - Custom implementation
ElevatedButton(child: Text('Save'), onPressed: () {})
SizedBox(height: 15)  // Arbitrary spacing breaks grid
Text('Title', style: TextStyle(fontSize: 17))  // Arbitrary size
color: Color(0xFF123456)  // Hardcoded color
```

### Available Components
- Buttons: `GOLButton` (primary, secondary, tertiary, destructive)
- Cards: `GOLCard` (standard, elevated)
- Inputs: `GOLTextField`, `GOLSearchField`, `GOLDropdown`
- Lists: `GOLListItem`, `GOLCheckboxTile`, `GOLRadioTile`, `GOLSwitchTile`
- Progress: `GOLLinearProgress`, `GOLCircularProgress`, `GOLGridLoader`
- Navigation: `GOLAppBar`, `GOLTabBar`, `GOLBottomNav`
- Feedback: `GOLChip`, `GOLBadge`, `GOLDivider`, `GOLSkeleton`
- Overlays: `showGOLDialog`, `showGOLBottomSheet`, `showGOLToast`

### 8-Point Grid System
All spacing MUST follow multiples of 8px (or 4px for very small spacing):
- `GOLSpacing.space1` = 4px (small exception)
- `GOLSpacing.space2` = 8px ✓
- `GOLSpacing.space4` = 16px ✓ (default)
- `GOLSpacing.space6` = 24px ✓
- `GOLSpacing.space7` = 32px ✓ (sections)

See: `lib/grow_out_loud/foundation/SPACING_GUIDE.md`

### Typography Scale
Use semantic text styles from theme:
- Headlines: `displayLarge/Medium/Small`, `headlineLarge/Medium/Small`
- Body: `bodyLarge/Medium/Small` (bodyMedium is default)
- UI: `labelLarge/Medium/Small` (for buttons, tabs)
- Special: `GOLTypography.caption/overline/micro/mono`

See: `lib/grow_out_loud/foundation/TYPOGRAPHY_GUIDE.md`

### When Building New Features
1. Check `grow_out_loud_gallery_screen.dart` for existing components
2. Use GOL components exclusively
3. If component missing: Create it in `components/` following existing patterns
4. Add new component to gallery with usage example
5. Maintain 8pt grid and typography scale

## Development Commands

### Running the App

```bash
# Run on connected device (physical or emulator)
flutter run

# Run on specific device
flutter run -d <device-id>

# Run with hot reload enabled (default in debug mode)
flutter run

# List available devices
flutter devices
```

### Building

```bash
# Build APK for Android
flutter build apk

# Build release APK
flutter build apk --release

# Build app bundle (for Play Store)
flutter build appbundle
```

### Testing & Code Quality

```bash
# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Format code
dart format lib/
```

### Dependencies

```bash
# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Check for outdated packages
flutter pub outdated
```

### Cleaning Build Artifacts

```bash
# Clean build files
flutter clean

# Clean and get dependencies
flutter clean && flutter pub get
```

## Architecture

### Navigation Flow

1. **SplashScreen** (entry point) → Displays app logo and tagline for 2 seconds
2. **WelcomeScreen** → First onboarding screen
3. **FeatureCarouselScreen** → Shows app features
4. **AuthChoiceScreen** → User chooses sign in or sign up
5. **CreateAccountScreen** → Account creation flow

### Theme System

- **Primary color**: Green (#22C55E) for light mode, Bright green (#4ADE80) for dark mode
- **Material 3** design system
- **Automatic theme switching** based on system preferences
- Custom color scheme defined in `main.dart`

### Code Organization

```
lib/
├── main.dart                    # App entry point, theme configuration
├── grow_out_loud/              # Design system (GOL)
│   ├── components/             # Reusable UI components
│   │   ├── gol_buttons.dart
│   │   ├── gol_cards.dart
│   │   ├── gol_inputs.dart
│   │   └── ... (all components)
│   └── foundation/             # Design tokens
│       ├── gol_colors.dart
│       ├── gol_spacing.dart
│       ├── gol_typography.dart
│       ├── gol_radius.dart
│       ├── gol_theme.dart
│       ├── SPACING_GUIDE.md
│       ├── TYPOGRAPHY_GUIDE.md
│       └── DESIGN_PATTERNS.md   # UI patterns (cards, layouts, icons)
└── screens/                    # Application screens
    ├── home_screen.dart
    ├── performance_screen.dart
    ├── content_screen.dart
    ├── assistant_screen.dart
    └── grow_out_loud_gallery_screen.dart  # Design system gallery
```

## Device Setup

### Physical Device Testing (Pixel 9 Pro XL)

The project is configured for testing on Pixel 9 Pro XL (Android 16, API 36).

```bash
# Enable wireless debugging (after USB pairing)
adb tcpip 5555
adb connect <PHONE_IP>:5555

# Verify wireless connection
flutter devices
```

### Hot Reload

- Press `r` in terminal for hot reload
- Press `R` for hot restart
- Changes apply automatically in debug mode when saving files

## Environment

- **Flutter**: 3.38.5 (stable)
- **Dart SDK**: ^3.10.4
- **Android SDK**: 36.1.0
- **Target Platform**: Android (primary), supports macOS and web

## Key Dependencies

- `cupertino_icons: ^1.0.8` - iOS-style icons
- `flutter_lints: ^6.0.0` - Recommended lints for code quality
