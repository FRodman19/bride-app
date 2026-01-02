# Grow Out Loud Typography System

## Overview
Our typography system uses **Plus Jakarta Sans** as the primary typeface, with **JetBrains Mono** for code and data displays. The system provides clear visual hierarchy and maintains readability across all screen sizes.

## Font Family

### Primary: Plus Jakarta Sans
- Modern, geometric sans-serif
- Excellent readability at all sizes
- Professional yet approachable
- Variable weights: 400 (Regular), 500 (Medium), 600 (Semi-Bold), 700 (Bold)

### Monospace: JetBrains Mono
- Used for code snippets, data, and technical information
- Fixed-width characters for alignment
- Excellent for numbers and IDs

## Typography Scale

### Display Styles (Hero Text)

Use for landing pages, hero sections, and marketing materials.

#### Display Large
```dart
textTheme.displayLarge
```
- **Size:** 48px
- **Line Height:** 56px (1.167)
- **Weight:** Bold (700)
- **Letter Spacing:** -0.02em
- **Use:** Hero headlines, splash screens

#### Display Medium
```dart
textTheme.displayMedium
```
- **Size:** 40px
- **Line Height:** 48px (1.2)
- **Weight:** Bold (700)
- **Letter Spacing:** -0.02em
- **Use:** Feature headlines, section heroes

#### Display Small
```dart
textTheme.displaySmall
```
- **Size:** 32px
- **Line Height:** 40px (1.25)
- **Weight:** Bold (700)
- **Letter Spacing:** -0.01em
- **Use:** Page titles, modal titles

### Heading Styles (Content Hierarchy)

Use for organizing content sections and creating hierarchy.

#### Heading XL (Display Small)
```dart
textTheme.displaySmall
```
- **Size:** 32px
- **Line Height:** 40px
- **Weight:** Bold (700)
- **Use:** Main page headings

#### Heading Large
```dart
textTheme.headlineLarge
```
- **Size:** 24px
- **Line Height:** 32px (1.333)
- **Weight:** Semi-Bold (600)
- **Letter Spacing:** -0.01em
- **Use:** Section headings, card titles

#### Heading Medium
```dart
textTheme.headlineMedium
```
- **Size:** 20px
- **Line Height:** 28px (1.4)
- **Weight:** Semi-Bold (600)
- **Use:** Subsection headings, dialog titles

#### Heading Small
```dart
textTheme.headlineSmall
```
- **Size:** 16px
- **Line Height:** 24px (1.5)
- **Weight:** Semi-Bold (600)
- **Use:** Card headers, list headers, small sections

#### Heading XS (Title Large)
```dart
textTheme.titleLarge
```
- **Size:** 14px
- **Line Height:** 20px (1.429)
- **Weight:** Semi-Bold (600)
- **Letter Spacing:** 0.01em
- **Use:** Compact headings, table headers

### Body Text (Main Content)

Use for paragraphs, descriptions, and primary content.

#### Body Large
```dart
textTheme.bodyLarge
```
- **Size:** 18px
- **Line Height:** 28px (1.556)
- **Weight:** Regular (400)
- **Use:** Long-form content, articles, detailed descriptions

#### Body Medium (Default)
```dart
textTheme.bodyMedium
```
- **Size:** 16px
- **Line Height:** 24px (1.5)
- **Weight:** Regular (400)
- **Use:** Standard body text, descriptions, list content

#### Body Small
```dart
textTheme.bodySmall
```
- **Size:** 14px
- **Line Height:** 20px (1.429)
- **Weight:** Regular (400)
- **Use:** Secondary text, captions, helper text

### UI/Label Text (Interface Elements)

Use for buttons, tabs, inputs, and interactive elements.

#### Label Large
```dart
textTheme.labelLarge
```
- **Size:** 16px
- **Line Height:** 24px (1.5)
- **Weight:** Medium (500)
- **Use:** Large buttons, prominent links

#### Label Medium
```dart
textTheme.labelMedium
```
- **Size:** 14px
- **Line Height:** 20px (1.429)
- **Weight:** Medium (500)
- **Use:** Standard buttons, tabs, chips, form labels

#### Label Small
```dart
textTheme.labelSmall
```
- **Size:** 12px
- **Line Height:** 16px (1.333)
- **Weight:** Medium (500)
- **Use:** Small buttons, badges, compact UI elements

### Specialized Styles

#### Caption
```dart
GOLTypography.caption(color)
```
- **Size:** 12px
- **Line Height:** 16px (1.333)
- **Weight:** Regular (400)
- **Use:** Image captions, metadata, timestamps

#### Overline
```dart
GOLTypography.overline(color)
```
- **Size:** 11px
- **Line Height:** 16px (1.455)
- **Weight:** Semi-Bold (600)
- **Letter Spacing:** 0.06em (wide)
- **Use:** Section labels, categories (ALL CAPS)
- **Example:** "SECTION LABEL", "CATEGORY"

#### Micro
```dart
GOLTypography.micro(color)
```
- **Size:** 10px
- **Line Height:** 12px (1.2)
- **Weight:** Medium (500)
- **Use:** Tiny labels, badges, ultra-compact text

#### Mono (Code/Data)
```dart
GOLTypography.mono(size: 14, weight: FontWeight.w500, color: color)
```
- **Font:** JetBrains Mono
- **Size:** Variable (commonly 12-16px)
- **Line Height:** Calculated (size + 4) / size
- **Use:** Code snippets, IDs, formatted numbers, data

## Visual Hierarchy Guidelines

### Establishing Hierarchy

1. **Size Contrast:** Use at least 2 steps difference for clear hierarchy
   - Heading (24px) → Body (16px) ✓
   - Heading (20px) → Body (18px) ✗ (too close)

2. **Weight Contrast:** Pair different weights for emphasis
   - Heading (Semi-Bold 600) + Body (Regular 400) ✓
   - Title (Medium 500) + Caption (Regular 400) ✓

3. **Color Contrast:** Use semantic colors for importance
   - Primary: `colors.textPrimary` - Main content
   - Secondary: `colors.textSecondary` - Supporting info
   - Tertiary: `colors.textTertiary` - De-emphasized
   - Accent: `colors.textAccent` - Interactive elements

### Common Patterns

#### Card with Hierarchy
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Title
    Text('Project Name', style: textTheme.headlineSmall),
    SizedBox(height: GOLSpacing.space1), // 4px

    // Metadata
    Text('Updated 2 hours ago', style: textTheme.bodySmall?.copyWith(
      color: colors.textSecondary,
    )),
    SizedBox(height: GOLSpacing.space3), // 12px

    // Description
    Text('Main description text goes here...', style: textTheme.bodyMedium),
  ],
)
```

#### Page Header
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Overline/Category
    Text('DASHBOARD', style: GOLTypography.overline(colors.textTertiary)),
    SizedBox(height: GOLSpacing.space2), // 8px

    // Main heading
    Text('Analytics Overview', style: textTheme.displaySmall),
    SizedBox(height: GOLSpacing.space2), // 8px

    // Subtitle
    Text(
      'Track your performance metrics',
      style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
    ),
  ],
)
```

#### Form Field
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Label
    Text('Email Address', style: textTheme.labelMedium),
    SizedBox(height: GOLSpacing.space2), // 8px

    // Input field
    TextField(...),
    SizedBox(height: GOLSpacing.space1), // 4px

    // Helper text
    Text(
      'We\'ll never share your email',
      style: textTheme.bodySmall?.copyWith(color: colors.textTertiary),
    ),
  ],
)
```

## Text Spacing Guidelines

### Vertical Spacing Between Text Elements

Following the 8pt grid system:

| Gap Between | Spacing | Pixels | Use Case |
|-------------|---------|--------|----------|
| Heading → Subheading | `space1` | 4px | Tight hierarchy |
| Heading → Body | `space2` | 8px | Standard hierarchy |
| Body → Body (same paragraph) | Natural line-height | - | Let text breathe |
| Paragraph → Paragraph | `space4` | 16px | Paragraph breaks |
| Section → Section | `space6-space7` | 24-32px | Major breaks |

### Text Line Heights

Line heights are calculated for optimal readability:

- **Display/Large text:** 1.2 ratio (tighter, more impact)
- **Headings:** 1.33-1.4 ratio (balanced)
- **Body text:** 1.4-1.5 ratio (comfortable reading)
- **Small text:** 1.3-1.4 ratio (prevent cramping)

### Maximum Line Width

For optimal readability:
- **Body text:** 60-75 characters per line (optimal)
- **Maximum:** 80-90 characters
- **Minimum:** 45 characters

```dart
Container(
  constraints: BoxConstraints(maxWidth: 640), // ~75 chars at 16px
  child: Text('Long form content...', style: textTheme.bodyMedium),
)
```

## Color Application

### Text Color Hierarchy

```dart
// Primary - Most important content
color: colors.textPrimary

// Secondary - Supporting information
color: colors.textSecondary

// Tertiary - De-emphasized content
color: colors.textTertiary

// Accent - Interactive elements, links
color: colors.textAccent

// Inverse - Text on dark backgrounds
color: colors.textInverse

// Disabled - Inactive elements
color: colors.textDisabled
```

### Common Color Combinations

```dart
// Card title + description
Text('Title', style: textTheme.headlineSmall) // textPrimary
Text('Description', style: textTheme.bodySmall?.copyWith(
  color: colors.textSecondary,
))

// Button label
Text('Click here', style: textTheme.labelMedium?.copyWith(
  color: colors.textInverse, // on colored button
))

// Form label + input
Text('Label', style: textTheme.labelMedium) // textPrimary
TextField(...) // textPrimary input, textTertiary hint

// Link/action
Text('Learn more', style: textTheme.bodyMedium?.copyWith(
  color: colors.textAccent,
  decoration: TextDecoration.underline,
))
```

## Do's and Don'ts

### ✅ Do

- Use semantic text styles (headlineSmall, bodyMedium, etc.)
- Maintain consistent hierarchy across similar components
- Use appropriate line heights for readability
- Apply color hierarchy (primary, secondary, tertiary)
- Test readability on both light and dark backgrounds
- Use 8pt spacing between text elements

### ❌ Don't

- Use arbitrary font sizes (use the defined scale)
- Mix too many font sizes on one screen (3-4 max)
- Use small text (< 12px) for essential information
- Ignore color contrast ratios (maintain WCAG AA)
- Override letter spacing without reason
- Use multiple font families (stick to Plus Jakarta Sans + JetBrains Mono)

## Accessibility

### Minimum Sizes

- **Body text:** 16px minimum for main content
- **Secondary text:** 14px minimum
- **Small text:** 12px minimum (use sparingly)
- **Never go below:** 10px (only for non-essential micro text)

### Contrast Ratios (WCAG AA)

- **Normal text (< 18px):** 4.5:1 minimum
- **Large text (≥ 18px):** 3:1 minimum
- **Bold text (≥ 14px bold):** 3:1 minimum

### Color Independence

- Never rely on color alone to convey information
- Use icons, labels, or text alongside color indicators
- Ensure sufficient contrast in both light and dark modes

## Quick Reference Table

| Style | Size | Weight | Line Height | Use Case |
|-------|------|--------|-------------|----------|
| Display L | 48px | 700 | 56px | Heroes |
| Display M | 40px | 700 | 48px | Features |
| Display S | 32px | 700 | 40px | Pages |
| Headline L | 24px | 600 | 32px | Sections |
| Headline M | 20px | 600 | 28px | Subsections |
| Headline S | 16px | 600 | 24px | Cards |
| Body L | 18px | 400 | 28px | Long form |
| **Body M** | **16px** | **400** | **24px** | **Default** |
| Body S | 14px | 400 | 20px | Secondary |
| Label L | 16px | 500 | 24px | Large buttons |
| Label M | 14px | 500 | 20px | Buttons/tabs |
| Label S | 12px | 500 | 16px | Small UI |
| Caption | 12px | 400 | 16px | Metadata |
| Overline | 11px | 600 | 16px | Categories |
| Micro | 10px | 500 | 12px | Tiny labels |

---

**Pro tip:** When in doubt, use `bodyMedium` for content and `headlineSmall` for titles. These two styles cover 80% of use cases!
