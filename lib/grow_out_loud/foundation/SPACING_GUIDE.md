# Grow Out Loud Spacing System

## Overview
Our spacing system follows an **8pt grid** for consistency and visual harmony. For very small spacing, we use **4pt** (half of 8pt).

## Grid System Rules

### 8pt Grid
- All spacing should be multiples of **8px**: 8, 16, 24, 32, 40, 48, 56, 64, 80...
- This ensures visual consistency and makes components align properly

### 4pt Exception
- For very small spacing, use **4px** (half of 8pt)
- Use sparingly for tight internal component spacing only
- Examples: icon gaps, small button padding

## Base Spacing Scale

```dart
GOLSpacing.space0  = 0    // No space
GOLSpacing.space1  = 4    // 4pt - Very small (exception to 8pt rule)
GOLSpacing.space2  = 8    // 8pt
GOLSpacing.space3  = 12   // 12pt - Use with caution (prefer 8 or 16)
GOLSpacing.space4  = 16   // 16pt
GOLSpacing.space5  = 20   // 20pt - Use with caution (prefer 16 or 24)
GOLSpacing.space6  = 24   // 24pt
GOLSpacing.space7  = 32   // 32pt
GOLSpacing.space8  = 40   // 40pt
GOLSpacing.space9  = 48   // 48pt
GOLSpacing.space10 = 56   // 56pt
GOLSpacing.space11 = 64   // 64pt
GOLSpacing.space12 = 80   // 80pt
```

**Recommended:** Prefer pure 8pt multiples (space2, space4, space6, space7, space9, space10, space11, space12)

## Usage Guidelines

### 1. Screen Layout Spacing

#### Horizontal Screen Padding
```dart
// Mobile (default)
GOLSpacing.screenPaddingHorizontal = 16  // 2 × 8pt

// Tablet
GOLSpacing.screenPaddingHorizontalTablet = 24  // 3 × 8pt
```

**When to use:**
- Left and right margins for all screen content
- Ensures content doesn't touch screen edges

#### Vertical Screen Padding
```dart
// Top padding with AppBar
GOLSpacing.screenPaddingTopWithAppBar = 56  // 7 × 8pt

// Top padding without AppBar
GOLSpacing.screenPaddingTopNoAppBar = 16  // 2 × 8pt

// Bottom padding with bottom navigation
GOLSpacing.screenPaddingBottomWithNav = 88  // 11 × 8pt

// Bottom padding without navigation
GOLSpacing.screenPaddingBottomNoNav = 32  // 4 × 8pt
```

### 2. Component Internal Spacing (Insets)

Use for padding **inside** components:

```dart
GOLSpacing.insetXs = 4   // Extra small - tight padding
GOLSpacing.insetSm = 8   // Small padding
GOLSpacing.insetMd = 16  // Medium padding (default)
GOLSpacing.insetLg = 24  // Large padding
```

**Examples:**
- `insetXs (4)`: Icon containers, badges
- `insetSm (8)`: List item vertical padding
- `insetMd (16)`: Card padding, input fields
- `insetLg (24)`: Modal dialogs, large cards

### 3. Stacking Spacing (Vertical)

Use for vertical gaps **between** components:

```dart
GOLSpacing.stackXs = 8   // Tight vertical spacing
GOLSpacing.stackSm = 12  // Small vertical spacing
GOLSpacing.stackMd = 16  // Medium vertical spacing (default)
GOLSpacing.stackLg = 24  // Large vertical spacing
GOLSpacing.stackXl = 32  // Extra large vertical spacing
```

**When to use:**
- `stackXs (8)`: Between tightly related items (form labels and inputs)
- `stackSm (12)`: Between related components in a group
- `stackMd (16)`: Default spacing between components
- `stackLg (24)`: Between distinct component groups
- `stackXl (32)`: Between major sections

### 4. Inline Spacing (Horizontal)

Use for horizontal gaps **between** components:

```dart
GOLSpacing.inlineXs = 4   // Tight horizontal spacing
GOLSpacing.inlineSm = 8   // Small horizontal spacing
GOLSpacing.inlineMd = 16  // Medium horizontal spacing
GOLSpacing.inlineLg = 24  // Large horizontal spacing
```

**When to use:**
- `inlineXs (4)`: Icon and text in button, chip items
- `inlineSm (8)`: Breadcrumb separators, tag spacing
- `inlineMd (16)`: Form fields side-by-side
- `inlineLg (24)`: Wide column gaps

### 5. Specific Component Spacing

#### Buttons
```dart
// Horizontal padding
buttonPaddingHorizontalSm = 12  // Small buttons
buttonPaddingHorizontalMd = 16  // Medium buttons
buttonPaddingHorizontalLg = 24  // Large buttons

// Vertical padding (maintains 8pt/4pt grid)
buttonPaddingVerticalSm = 4   // Small buttons
buttonPaddingVerticalMd = 8   // Medium buttons
buttonPaddingVerticalLg = 12  // Large buttons
```

#### Cards
```dart
cardPadding = 16              // Default card padding
cardPaddingComfortable = 20   // Slightly more comfortable
cardPaddingSpacious = 24      // Spacious card padding
cardContentGap = 12           // Gap between card content items
```

#### Input Fields
```dart
inputPaddingHorizontal = 16  // Left/right padding
inputPaddingVertical = 14    // Top/bottom padding
inputLabelGap = 8            // Space between label and input
inputHelperGap = 4           // Space between input and helper text
```

#### List Items
```dart
listItemPaddingHorizontal = 16  // Left/right padding
listItemPaddingVertical = 12    // Top/bottom padding
```

#### Modals
```dart
modalPadding = 24        // Padding inside modal
modalContentGap = 16     // Gap between modal content sections
```

### 6. Spacing Between Components

```dart
betweenFormFields = 16          // Between form inputs
betweenButtonsHorizontal = 12   // Between buttons in a row
betweenButtonsVertical = 8      // Between stacked buttons
betweenCards = 16               // Between card components
betweenSections = 32            // Between major page sections
betweenListGroups = 24          // Between grouped lists
```

## Common Patterns

### Example: Form Layout
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    // Form field
    TextField(...),
    SizedBox(height: GOLSpacing.betweenFormFields), // 16px

    // Another form field
    TextField(...),
    SizedBox(height: GOLSpacing.stackLg), // 24px - larger gap before actions

    // Action buttons
    Row(
      children: [
        GOLButton(...),
        SizedBox(width: GOLSpacing.betweenButtonsHorizontal), // 12px
        GOLButton(...),
      ],
    ),
  ],
)
```

### Example: Screen Layout
```dart
Padding(
  padding: EdgeInsets.symmetric(
    horizontal: GOLSpacing.screenPaddingHorizontal, // 16px
  ),
  child: Column(
    children: [
      SizedBox(height: GOLSpacing.screenPaddingTopNoAppBar), // 16px

      // Section 1
      SectionWidget(...),
      SizedBox(height: GOLSpacing.betweenSections), // 32px

      // Section 2
      AnotherSectionWidget(...),
      SizedBox(height: GOLSpacing.screenPaddingBottomNoNav), // 32px
    ],
  ),
)
```

### Example: Card with Content
```dart
GOLCard(
  child: Padding(
    padding: EdgeInsets.all(GOLSpacing.cardPadding), // 16px
    child: Column(
      children: [
        Text('Title'),
        SizedBox(height: GOLSpacing.cardContentGap), // 12px
        Text('Content'),
        SizedBox(height: GOLSpacing.cardContentGap), // 12px
        GOLButton(...),
      ],
    ),
  ),
)
```

## Do's and Don'ts

### ✅ Do
- Use multiples of 8px for most spacing
- Use 4px for very small, tight spacing
- Use semantic spacing constants (stackMd, insetLg, etc.)
- Be consistent across similar components

### ❌ Don't
- Use arbitrary spacing values (5px, 13px, 27px)
- Use odd numbers except in specific 4pt cases
- Mix different spacing values for the same purpose
- Override component spacing without good reason

## Quick Reference

| Size | 8pt Multiple | Pixels | Use Case |
|------|--------------|--------|----------|
| XXS  | 0.5×         | 4px    | Very tight spacing, icon gaps |
| XS   | 1×           | 8px    | Tight spacing |
| SM   | 1.5×         | 12px   | Small spacing (use with caution) |
| MD   | 2×           | 16px   | Default spacing |
| LG   | 3×           | 24px   | Large spacing |
| XL   | 4×           | 32px   | Section spacing |
| 2XL  | 5×           | 40px   | Major spacing |
| 3XL  | 6×           | 48px   | Extra major spacing |

---

**Remember:** Consistency creates visual harmony. When in doubt, use multiples of 8!
