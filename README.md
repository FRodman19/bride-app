# Grow Out Loud - Flutter Design System

A modern, production-ready Flutter design system built with Material 3, featuring comprehensive components, theming, and documentation.

## What is This?

This is a **ready-to-clone design system starter template** for Flutter apps. It includes a complete set of UI components, design tokens, and patterns that you can use to build beautiful, consistent applications.

Perfect for:
- Starting new Flutter projects with a solid foundation
- Learning modern Flutter UI development
- Sharing with AI assistants (Claude, ChatGPT, etc.) to help build features
- Prototyping and MVP development

## Features

- **Material 3 Based** - Modern design language with full light/dark theme support
- **30+ Semantic Colors** - Carefully crafted color system with accessibility in mind
- **14 Pre-built Components** - Buttons, cards, inputs, progress indicators, and more
- **8pt Grid System** - Consistent spacing throughout your app
- **Typography Scale** - 13 text styles covering all use cases
- **Comprehensive Documentation** - Design patterns, spacing guides, and usage examples
- **Interactive Gallery** - See all components in action

## Quick Start

### 1. Clone this repository

```bash
git clone <your-repo-url>
cd my_first_app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the app

```bash
flutter run
```

You'll see the design system home screen with a button to explore the component gallery.

## Using the Design System

### View All Components

Run the app and tap **"View Component Gallery"** to see:
- All available components
- Color palettes (light & dark modes)
- Typography styles
- Spacing system
- Usage examples

### Start Building Your App

1. Keep the `lib/grow_out_loud/` folder (the design system)
2. Replace `lib/screens/design_system_home.dart` with your own screens
3. Use GOL components to build your UI

Example:

```dart
import 'grow_out_loud/components/gol_buttons.dart';
import 'grow_out_loud/components/gol_cards.dart';
import 'grow_out_loud/foundation/gol_colors.dart';

GOLButton(
  label: 'Get Started',
  onPressed: () {},
  icon: Icon(Icons.arrow_forward),
)
```

### Share with AI Assistants

You can share this entire repository with Claude, ChatGPT, or other AI coding assistants:

```
"Here's my Flutter project with the Grow Out Loud design system.
Please help me build [your feature] using the GOL components."
```

The AI will understand your design system and use the correct components, spacing, and colors.

## Design System Documentation

All design system documentation is in `lib/grow_out_loud/foundation/`:

- **DESIGN_PATTERNS.md** - UI patterns and best practices
- **SPACING_GUIDE.md** - 8pt grid system usage
- **TYPOGRAPHY_GUIDE.md** - Font specifications and hierarchy

For detailed usage guidelines, see **CLAUDE.md** in the root directory.

## Components Library

The design system includes:

### Layout & Structure
- `GOLCard` - Content containers with variants
- `GOLDivider` - Section separators
- `GOLAppBar` - Navigation headers

### Inputs
- `GOLButton` - Primary, secondary, tertiary, destructive variants
- `GOLTextField` - Text input fields
- `GOLSearchField` - Search input
- `GOLDropdown` - Selection dropdowns
- `GOLCheckboxTile`, `GOLRadioTile`, `GOLSwitchTile` - Form controls

### Feedback
- `GOLChip` - Compact selections
- `GOLBadge` - Status indicators
- `GOLLinearProgress`, `GOLCircularProgress` - Loading states
- `GOLSkeleton` - Content placeholders
- `GOLGridLoader` - Animated loading grid

### Navigation
- `GOLTabBar` - Tab navigation
- `GOLBottomNav` - Bottom navigation bar

### Overlays
- `showGOLDialog` - Modal dialogs
- `showGOLBottomSheet` - Bottom sheets
- `showGOLToast` - Toast notifications

## Theme Setup

The app already uses GOL themes by default. To customize:

```dart
import 'grow_out_loud/foundation/gol_theme.dart';

MaterialApp(
  theme: GOLThemeData.light(),
  darkTheme: GOLThemeData.dark(),
  themeMode: ThemeMode.system, // Auto-switches based on device
);
```

Access theme colors in your widgets:

```dart
final colors = Theme.of(context).extension<GOLSemanticColors>()!;

Container(
  color: colors.backgroundPrimary,
  child: Text(
    'Hello',
    style: textTheme.headlineSmall?.copyWith(
      color: colors.textPrimary,
    ),
  ),
)
```

## Project Structure

```
lib/
├── grow_out_loud/              # Design system (don't modify)
│   ├── foundation/             # Design tokens
│   │   ├── gol_colors.dart
│   │   ├── gol_typography.dart
│   │   ├── gol_spacing.dart
│   │   ├── gol_radius.dart
│   │   ├── gol_shadows.dart
│   │   ├── gol_theme.dart
│   │   ├── DESIGN_PATTERNS.md
│   │   ├── SPACING_GUIDE.md
│   │   └── TYPOGRAPHY_GUIDE.md
│   └── components/             # UI components
│       ├── gol_buttons.dart
│       ├── gol_cards.dart
│       ├── gol_inputs.dart
│       └── ... (11 more)
├── screens/                    # Your app screens
│   ├── design_system_home.dart # Replace with your home
│   └── grow_out_loud_gallery_screen.dart # Component showcase
└── main.dart                   # App entry point
```

## Dependencies

The design system uses:

- `google_fonts` - Plus Jakarta Sans and JetBrains Mono
- `iconsax` - Beautiful outline and filled icons
- `flutter_svg` - SVG support for custom graphics
- `flutter_spinkit` - Animated loading indicators
- `flutter_animate` - Smooth animations

## For Future Projects

1. **Duplicate this folder** - Keep a clean copy for starting new projects
2. **Clone and modify** - Each project gets its own copy
3. **Update the design system** - Make improvements and republish

## Contributing

This is a personal design system. Feel free to fork and customize for your own projects!

## License

MIT License - Use freely in your projects

---

**Need Help?** Check out:
- The interactive gallery (run the app)
- CLAUDE.md for AI integration tips
- Design pattern docs in `lib/grow_out_loud/foundation/`

**Happy building!** 🚀
