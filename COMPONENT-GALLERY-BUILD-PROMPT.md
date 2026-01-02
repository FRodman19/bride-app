# COMPONENT GALLERY BUILD PROMPT
## For AI Developer Assistant (Claude Code / AI Tool)

---

## TASK OVERVIEW

You are tasked with building a **Design System Component Gallery** for the "Grow Out Loud" Flutter mobile application. This is a comprehensive showcase page that displays all design tokens, components, and usage guidelines defined in the attached design system document.

---

## ATTACHED DOCUMENT

**File:** `01-APP-DESIGN-SYSTEM.md`

This document contains:
- Complete color system (all color tokens with hex codes)
- Typography scale (DM Serif Display + Lora)
- Spacing system (8-point grid)
- Icon system (Iconsax)
- All component specifications with states
- Flutter code snippets
- Usage guidelines

**CRITICAL:** Follow this document exactly. Do not deviate from specified colors, sizes, spacing, or component designs.

---

## DESIGN CONSTRAINTS (MUST FOLLOW)

### NO Gradients
- Do not use gradient backgrounds anywhere
- Do not use gradient overlays
- Do not use gradient borders
- Use solid colors only (as specified in design system)

### NO Emojis
- Do not use emoji characters anywhere in the UI
- Do not use emoji in labels, titles, or descriptions
- Use text labels and Iconsax icons only

### Strict Adherence
- Use ONLY colors defined in AppColors class
- Use ONLY text styles defined in TextStyles class
- Use ONLY spacing values defined in AppSpacing class
- Follow exact specifications for all components

---

## WHERE TO BUILD

### Route Access
```
Route: /design-system
Access: Development mode only (kDebugMode)
```

### File Structure
```
lib/
├─ main.dart (add route here)
├─ design_system/
│   ├─ design_system_gallery.dart (main page)
│   ├─ sections/
│   │   ├─ colors_section.dart
│   │   ├─ typography_section.dart
│   │   ├─ spacing_section.dart
│   │   ├─ icons_section.dart
│   │   ├─ buttons_section.dart
│   │   ├─ cards_section.dart
│   │   ├─ forms_section.dart
│   │   ├─ navigation_section.dart
│   │   ├─ overlays_section.dart
│   │   └─ feedback_section.dart
│   └─ widgets/
│       ├─ color_swatch.dart
│       ├─ component_showcase.dart
│       ├─ code_snippet.dart
│       └─ section_header.dart
└─ theme/
    ├─ colors.dart (create from design system)
    ├─ text_styles.dart (create from design system)
    ├─ spacing.dart (create from design system)
    └─ app_theme.dart (create from design system)
```

### Route Registration (main.dart)
```dart
MaterialApp(
  routes: {
    '/': (context) => HomePage(),
    if (kDebugMode) '/design-system': (context) => DesignSystemGallery(),
  },
)
```

### How to Access
During development, navigate to the design system gallery via:
- Button in Settings page (temporary access)
- Direct navigation: Navigator.pushNamed(context, '/design-system')
- OR: Hidden Easter egg (tap app logo 7 times)

---

## WHAT TO BUILD (Section by Section)

### 1. Gallery Main Page
```
DesignSystemGallery (design_system_gallery.dart)
├─ AppBar
│   └─ Title: "Design System Gallery"
│       Back button
├─ Body (Scrollable)
│   ├─ Introduction Section
│   │   ├─ App name: "Grow Out Loud"
│   │   ├─ Version: "1.0"
│   │   └─ Brief description
│   ├─ Navigation Chips (Filter sections)
│   │   ├─ All, Foundation, Components, Patterns
│   └─ Section List
│       ├─ Colors Section
│       ├─ Typography Section
│       ├─ Spacing Section
│       ├─ Icons Section
│       ├─ Buttons Section
│       ├─ Cards Section
│       ├─ Forms Section
│       ├─ Navigation Section
│       ├─ Overlays Section
│       └─ Feedback Section
```

---

### 2. Colors Section

**Display ALL color swatches from design system:**

**2.1 Brand Purple Palette**
- Purple 50 through Purple 950 (11 swatches)
- Display as horizontal scrollable row
- Each swatch: 80x80dp, rounded corners (8px)
- Below swatch: Color name + hex code

**2.2 Neutral Palette (Dark Mode)**
- Neutral 0 through Neutral 900 (10 swatches)
- Highlight: Neutral 100 (primary dark background) with star or indicator

**2.3 Neutral Palette (Light Mode)**
- Neutral 950 through Neutral 1000
- Highlight: Neutral 950 (primary light background)

**2.4 Semantic Colors**
- Success: 50, 500, 600, 900
- Error: 50, 500, 600, 900
- Warning: 50, 500, 600, 900
- Info: 50, 500, 600, 900

**Component Widget:**
```dart
ColorSwatch(
  color: AppColors.purple600,
  name: 'Purple 600',
  hexCode: '#8B5CF6',
  isPrimary: true, // Shows indicator
)
```

---

### 3. Typography Section

**Display ALL text styles with live examples:**

**3.1 Display Styles**
```
Display Large
  → Live text: "The quick brown fox"
  → Specs below: 40sp / 48sp line / DM Serif Display Bold

Display Medium
  → Live text: "The quick brown fox"
  → Specs: 32sp / 40sp line / DM Serif Display Bold

Display Small
  → Live text: "The quick brown fox"
  → Specs: 28sp / 36sp line / DM Serif Display Medium
```

**3.2 Headline Styles**
```
Headline Large → 24sp / Lora Bold
Headline Medium → 20sp / Lora SemiBold
Headline Small → 18sp / Lora SemiBold
```

**3.3 Body Styles**
```
Body Large → 16sp / Lora Regular (mark as DEFAULT)
Body Medium → 14sp / Lora Regular
Body Small → 12sp / Lora Regular
```

**3.4 Label Styles**
```
Label Large → 16sp / System Medium
Label Medium → 14sp / System Medium
Label Small → 12sp / System Medium
```

**Layout:**
- Each style: Full-width card
- Live text preview at actual size
- Specs below in smaller text
- Responsive: text should scale with system font size

---

### 4. Spacing Section

**Visual representation of spacing scale:**

**4.1 Spacing Scale**
```
Display spacing increments visually:
4px  ▮ (0.5 unit)
8px  ▮▮ (1 unit) ← BASE
16px ▮▮▮▮ (2 units) ← MOST COMMON
24px ▮▮▮▮▮▮ (3 units)
32px ▮▮▮▮▮▮▮▮ (4 units)
40px ▮▮▮▮▮▮▮▮▮▮ (5 units)
48px ▮▮▮▮▮▮▮▮▮▮▮▮ (6 units)
```

Use colored boxes to represent each spacing value.

**4.2 Token Types**
```
Inset (Padding):
  insetXs: 4px, insetSm: 8px, insetMd: 16px (most common), insetLg: 24px

Stack (Vertical):
  stackXs: 8px, stackSm: 12px, stackMd: 16px (most common), stackLg: 24px

Inline (Horizontal):
  inlineXs: 4px, inlineSm: 8px (most common), inlineMd: 16px
```

**4.3 Usage Examples**
Show 2-3 real component examples with spacing annotated.

---

### 5. Icons Section

**Display icon system:**

**5.1 Icon Sizes**
```
Show same icon (e.g., iconsax/home) at all sizes:
16dp, 20dp, 24dp (DEFAULT), 32dp, 40dp, 48dp, 64dp

Each with label below showing size
```

**5.2 Icon Colors (Dark Mode)**
```
Show same icon in each color:
- Primary (Neutral 700)
- Secondary (Neutral 500)
- Active (Purple 600)
- Success (Success 500)
- Error (Error 500)
```

**5.3 Common Icons Grid**
```
Display 20-30 common icons from Iconsax:
- home-2
- folder-2
- teacher
- document-text
- message-programming
- chart-square
- add-circle
- edit-2
- trash
- save-2
- share
- search-normal
- filter
- etc.

Grid: 4 columns, icon + name below each
```

**Note:** Use actual Iconsax icon package or placeholder icons with labels.

---

### 6. Buttons Section

**Display ALL button types with ALL states:**

**6.1 Primary Button**
```
States to show (each as actual button):
├─ Default (Purple 600 background, white text)
├─ Pressed (Purple 700, slightly smaller)
├─ Disabled (Neutral 300, Neutral 500 text, grayed out)
└─ Loading (Purple 600, white spinner in center)

Specs below:
- Height: 48dp
- Padding: 12dp vertical, 24dp horizontal
- Border Radius: 12px
- Text: Label Large (16sp, Medium 500)

Interactive Demo:
- Button that user can tap to see press animation
- Toggle switches to enable/disable loading/disabled states
```

**6.2 Secondary Button**
```
States:
├─ Default (Transparent, 2px purple border)
├─ Pressed (Light purple fill)
├─ Disabled (Gray border, gray text)
```

**6.3 Tertiary/Text Button**
```
States:
├─ Default (Purple text, no background)
├─ Pressed (Light purple background)
├─ Disabled (Gray text)
```

**6.4 FAB (Floating Action Button)**
```
Show both:
├─ Regular FAB (56x56dp, purple, white icon)
└─ Mini FAB (40x40dp)
```

**6.5 Icon Button**
```
Show icon button (48x48dp touch target, 24dp icon)
States: Default, Pressed, Active
```

**6.6 Destructive Button**
```
Show delete button (Error 500 background)
States: Default, Pressed, Disabled
```

**Component Widget Example:**
```dart
ButtonShowcase(
  buttonType: 'Primary',
  states: [
    ButtonState(
      name: 'Default',
      widget: PrimaryButton(label: 'Default State', onPressed: () {}),
    ),
    ButtonState(
      name: 'Pressed',
      widget: PrimaryButton(label: 'Pressed State', onPressed: () {}),
      // Apply pressed styling
    ),
    // ... more states
  ],
  specs: {
    'Height': '48dp',
    'Padding': '12dp vertical, 24dp horizontal',
    'Border Radius': '12px',
    // ... more specs
  },
  codeSnippet: '''
PrimaryButton(
  label: 'Create Project',
  onPressed: () {},
)
  ''',
)
```

---

### 7. Cards Section

**Display ALL card variations:**

**7.1 Standard Card**
```
Show card with:
├─ Sample content (title, body text, actions)
├─ Specs below
├─ States: Default, Hover (if web), Pressed
```

**7.2 Elevated Card**
```
Higher elevation (8dp vs 2dp)
More prominent shadow
```

**7.3 Image Card**
```
Card with:
├─ Image at top (16:9 aspect ratio)
└─ Content below (title + description)
```

**Each card includes:**
- Padding: 16dp
- Border Radius: 12px
- Elevation values
- Color specs (dark/light mode)

---

### 8. Forms Section

**Display ALL form inputs with ALL states:**

**8.1 Text Input Field**
```
States (show 4 separate fields):
├─ Default (gray border, empty)
├─ Focused (purple border, label floating above)
├─ Filled (content inside, label above)
├─ Error (red border, error message below with icon)
└─ Disabled (gray background, cursor not-allowed)

Below each: Height (56dp), padding, border specs
```

**8.2 Dropdown/Select**
```
Show closed and open states
Dropdown menu overlay example
```

**8.3 Checkbox**
```
Show side by side:
├─ Unchecked (empty box)
├─ Checked (purple, white checkmark)
├─ Indeterminate (purple, white dash)
└─ Disabled (gray)
```

**8.4 Radio Button**
```
Show radio group (2-3 options):
├─ Unselected (empty circle)
├─ Selected (purple filled center)
```

**8.5 Switch/Toggle**
```
Show side by side:
├─ Off (gray track, thumb on left)
├─ On (purple track, thumb on right)
Animation: Include animation spec (200ms slide)
```

**8.6 Date Picker**
```
Show text field with calendar icon
Mock date picker modal below
```

**8.7 Search Field**
```
Pill-shaped field (24dp radius)
Search icon left, clear icon right
```

---

### 9. Navigation Section

**Display ALL navigation components:**

**9.1 Bottom Navigation Bar**
```
Show bottom nav with 3-5 items:
├─ Inactive items (gray icons, gray labels)
├─ Active item (purple icon in bold variant, purple label)

Show both:
- Core App version (5 tabs: Home, Projects, Skills, Content, AI)
- Tracker App version (3 tabs: Dashboard, Trackers, Settings)

Specs:
- Height: 56dp
- Background: Neutral 100 (95% opacity)
- Icon size: 24dp
- Label size: 12sp
```

**9.2 Top App Bar**
```
Show app bar with:
├─ Leading: Back button (<)
├─ Center: Page title
└─ Trailing: Action icons (search, more)

Height: 56dp
```

**9.3 Tab Bar**
```
Show tab bar with 3-4 tabs:
├─ Inactive tabs (gray text)
├─ Active tab (purple text, 3dp underline)

Show indicator animation (sliding line)
```

---

### 10. Overlays Section

**Display ALL overlay types:**

**10.1 Modal/Dialog**
```
Show modal example with:
├─ Dark overlay background (50% black)
├─ Modal container (rounded 16dp, elevated)
├─ Header (title + close X)
├─ Content area
└─ Footer (Cancel + Primary button)

Specs:
- Max width: 400dp
- Padding: 24dp
- Elevation: 24dp
```

**10.2 Bottom Sheet**
```
Show bottom sheet with:
├─ Drag handle (32x4dp gray pill at top)
├─ Content area
└─ Rounded top corners (16dp)

Note: Slides up from bottom
```

**10.3 Toast/Snackbar**
```
Show 3 variations:
├─ Success (green bg, checkmark icon)
├─ Error (red bg, error icon)
└─ Info (neutral bg, info icon)

Each:
- Rounded 8dp
- Icon + text + optional action
- Position: Top center or bottom
```

---

### 11. Feedback Section

**Display ALL feedback states:**

**11.1 Loading States**
```
Show 3 types:
├─ Spinner (circular progress, 20dp/40dp sizes)
├─ Skeleton Screen (shimmer effect on gray rectangles)
└─ Progress Bar (4dp height, purple fill)
```

**11.2 Success States**
```
Show success checkmark animation
- Large green checkmark (64dp)
- Scale + rotate animation
- Bouncy spring physics
```

**11.3 Error States**
```
Show error display:
- Red error icon
- Error message text
- Recovery action button
```

**11.4 Empty States**
```
Show empty state example:
├─ Large icon (64dp, gray)
├─ Title (Headline Medium)
├─ Description (Body Large)
└─ CTA button ("Create First Project")

Center-aligned, generous padding
```

---

## ADDITIONAL FEATURES TO IMPLEMENT

### Code Snippet Copy

For each component, include code snippet with copy button:

```dart
class CodeSnippet extends StatelessWidget {
  final String code;
  
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutral900, // Dark code background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('CODE', style: TextStyles.labelSmall.copyWith(
                color: AppColors.white,
              )),
              IconButton(
                icon: Icon(Icons.copy, size: 16, color: AppColors.purple600),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  // Show "Copied!" toast
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          SelectableText(
            code,
            style: TextStyle(
              fontFamily: 'monospace',
              color: AppColors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
```

### Dark/Light Mode Toggle

Add toggle at top of gallery to switch themes instantly:
```dart
Switch(
  value: isDarkMode,
  onChanged: (value) {
    // Toggle theme
    setState(() => isDarkMode = value);
  },
)
```

### Search/Filter

Add search bar at top to filter components:
```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Search components...',
    prefixIcon: Icon(Icons.search),
  ),
  onChanged: (query) {
    // Filter sections based on query
  },
)
```

---

## SUCCESS CRITERIA

Your implementation is complete when:

- [ ] Gallery accessible via /design-system route in dev mode
- [ ] All 11 sections implemented and visible
- [ ] Colors section: ALL color swatches displayed with hex codes
- [ ] Typography section: ALL text styles shown at actual size with specs
- [ ] Spacing section: Visual scale displayed with annotations
- [ ] Icons section: Multiple sizes, colors, and 20+ common icons shown
- [ ] Buttons section: ALL 6 button types with ALL states (default, pressed, disabled, loading)
- [ ] Cards section: Standard, elevated, and image cards displayed
- [ ] Forms section: ALL 7 input types with ALL states (default, focus, error, disabled)
- [ ] Navigation section: Bottom nav, app bar, and tab bar displayed
- [ ] Overlays section: Modals, bottom sheets, and toasts displayed
- [ ] Feedback section: Loading, success, error, and empty states shown
- [ ] Code snippets: Every component has copy-able code example
- [ ] Dark/Light toggle: Works instantly, all components adapt
- [ ] No gradients used anywhere
- [ ] No emojis used anywhere
- [ ] Interactive demos: Buttons can be tapped, state toggles work
- [ ] Scrolling works smoothly
- [ ] All specs match design system document exactly

---

## CRITICAL REMINDERS

1. **NO GRADIENTS** - Use solid colors only (as specified in design system)
2. **NO EMOJIS** - Text labels and Iconsax icons only
3. **EXACT SPECS** - Follow design system document precisely (colors, sizes, spacing)
4. **ALL STATES** - Every interactive component must show default, pressed, disabled, loading
5. **CODE SNIPPETS** - Every component needs copy-able Flutter code
6. **BOTH THEMES** - Dark and light mode must both work perfectly

---

## DELIVERABLES

When you complete this task, provide:

1. Complete file structure (all .dart files created)
2. Route registered in main.dart
3. All theme files created (colors.dart, text_styles.dart, spacing.dart, app_theme.dart)
4. All 11 sections implemented
5. Instructions for how to access the gallery during development
6. Screenshot or description of completed gallery

---

## DEPENDENCIES TO ADD

Ensure these packages are in pubspec.yaml:

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0  # For DM Serif Display + Lora
  iconsax: ^0.0.8       # For Iconsax icons
```

---

## DEVELOPMENT TIPS

- Build incrementally: Start with Colors, then Typography, then move to components
- Test dark/light mode toggle frequently
- Use actual Iconsax icons (not placeholders)
- Make sure all colors come from AppColors class (no hardcoded hex values)
- Use AppSpacing constants for all spacing (no magic numbers)
- Test on both iOS and Android simulators
- Ensure 60fps performance (no lag when scrolling)

---

## QUESTIONS?

If anything is unclear in the design system document:
1. Default to Material Design 3 standards
2. Prioritize consistency over creativity
3. Ask for clarification before proceeding

---

**Ready to build? Let's create a world-class component gallery!**

---

**Document Version:** 1.0  
**Last Updated:** December 28, 2024  
**Target Completion:** 4 weeks (Week 1: Foundation, Week 2: Components Part 1, Week 3: Components Part 2, Week 4: Polish)
