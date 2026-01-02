# Design Patterns Guide

This guide documents the proven UI patterns used throughout the Grow Out Loud app. Following these patterns ensures consistency, professional appearance, and maintainability.

## Core Principles

1. **Compact & Tight** - Cards should be as short as possible while remaining readable
2. **Horizontal Alignment** - Icons and text on the same line, not stacked vertically
3. **No Emojis** - Always use Iconsax icons (prefer outline variants by default)
4. **Even Distribution** - UI elements should fill available space naturally
5. **Simple Interactions** - No fancy animations or distracting feedback

---

## Pattern Catalog

### 1. Card with Icon, Title, and Value

**Use this pattern for:** Skills, Projects, any entity with progress/status

```dart
GOLCard(
  variant: GOLCardVariant.elevated,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Icon and content on SAME horizontal line
      Row(
        children: [
          Icon(Iconsax.code, size: 32, color: colors.interactivePrimary),
          const SizedBox(width: GOLSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Python for Data Science',
                  style: textTheme.headlineSmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: GOLSpacing.space1),
                Row(
                  children: [
                    Icon(Iconsax.flag, size: 14, color: colors.textTertiary),
                    const SizedBox(width: GOLSpacing.space1),
                    Text(
                      'Pandas Library Basics',
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '65%',
            style: textTheme.headlineMedium?.copyWith(
              color: colors.interactivePrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      const SizedBox(height: GOLSpacing.space4),
      GOLLinearProgress(value: 0.65),
      // Additional info...
    ],
  ),
)
```

**Why this works:**
- Icon + text + value all visible at once
- Card height is minimized
- Clean, professional appearance

---

### 2. Quick Action Grid

**Use this pattern for:** Action buttons on dashboard/home screen

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,  // CRITICAL: Even distribution
  children: [
    _QuickActionItem(
      icon: Iconsax.folder_add,
      label: 'New\nProject',
      colors: colors,
      textTheme: textTheme,
    ),
    _QuickActionItem(
      icon: Iconsax.book,
      label: 'New\nSkill',
      colors: colors,
      textTheme: textTheme,
    ),
    _QuickActionItem(
      icon: Iconsax.document,
      label: 'New\nContent',
      colors: colors,
      textTheme: textTheme,
    ),
    _QuickActionItem(
      icon: Iconsax.chart,
      label: 'Daily\nEntry',
      colors: colors,
      textTheme: textTheme,
    ),
    _QuickActionItem(
      icon: Iconsax.cpu,
      label: 'Open\nAssist',
      colors: colors,
      textTheme: textTheme,
    ),
  ],
)
```

**Quick Action Item Widget:**
```dart
class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final GOLSemanticColors colors;
  final TextTheme textTheme;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: colors.surfaceRaised,
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.borderDefault,
              width: 1.5,
            ),
          ),
          child: Icon(icon, size: 28, color: colors.interactivePrimary),
        ),
        const SizedBox(height: GOLSpacing.space2),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colors.textSecondary,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
```

**Why this works:**
- No empty space on the right
- Actions are evenly distributed
- Touch targets are appropriately sized

---

### 3. Metric Overview Cards

**Use this pattern for:** Dashboard metrics, stats, KPIs

```dart
Row(
  children: [
    Expanded(
      child: GOLCard(
        variant: highlight ? GOLCardVariant.elevated : GOLCardVariant.standard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + Title on same line
            Row(
              children: [
                Icon(Iconsax.folder, size: 20, color: colors.textSecondary),
                const SizedBox(width: GOLSpacing.space2),
                Text(
                  'PROJECTS',
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.textTertiary,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: GOLSpacing.space2),
            // Value + Subtitle on same horizontal line
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '3',
                  style: textTheme.displaySmall?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: GOLSpacing.space2),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Active ventures',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    const SizedBox(width: GOLSpacing.space3),
    Expanded(
      child: GOLCard(/* Next metric */),
    ),
  ],
)
```

**Why this works:**
- Number and description visible together
- Horizontal alignment is cleaner than vertical stack
- Cards are shorter and more scannable

---

### 4. Combined Metrics Card

**Use this pattern for:** Financial metrics, performance stats with multiple values

```dart
GOLCard(
  variant: GOLCardVariant.elevated,
  child: IntrinsicHeight(  // CRITICAL: Ensures even height for dividers
    child: Row(
      children: [
        // First metric
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Iconsax.chart_21, size: 14, color: colors.textTertiary),
                  const SizedBox(width: GOLSpacing.space1),
                  Flexible(
                    child: Text(
                      'NET PROFIT',
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: GOLSpacing.space2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '\$8,240',
                  style: textTheme.headlineMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Vertical divider
        Container(
          width: 1,
          color: colors.borderDefault,
          margin: const EdgeInsets.symmetric(horizontal: GOLSpacing.space3),
        ),

        // Second metric
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Iconsax.wallet_3, size: 14, color: colors.textTertiary),
                  const SizedBox(width: GOLSpacing.space1),
                  Flexible(
                    child: Text('REVENUE', style: textTheme.labelSmall),
                  ),
                ],
              ),
              const SizedBox(height: GOLSpacing.space2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text('\$12,400', style: textTheme.headlineMedium),
              ),
            ],
          ),
        ),

        // Divider and third metric...
      ],
    ),
  ),
)
```

**Why this works:**
- Single compact card instead of 3 separate cards
- Visual grouping with dividers
- FittedBox prevents overflow on small screens
- Flexible ensures text wraps if needed

---

### 5. Content/Pipeline Cards

**Use this pattern for:** Content items, tasks, workflow stages

```dart
GOLCard(
  variant: GOLCardVariant.standard,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          // Platform icon + name
          Icon(Iconsax.video, size: 16, color: colors.interactivePrimary),
          const SizedBox(width: GOLSpacing.space2),
          Text(
            'YouTube',
            style: textTheme.labelMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: GOLSpacing.space2),
          Text('•', style: textTheme.bodySmall),
          const SizedBox(width: GOLSpacing.space2),
          Text(
            'Coding Skill',
            style: textTheme.labelSmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
      const SizedBox(height: GOLSpacing.space2),
      Text(
        'AI Automation Video',
        style: textTheme.bodyLarge?.copyWith(
          color: colors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: GOLSpacing.space3),
      // Progress bar if applicable
      Row(
        children: [
          Expanded(child: GOLLinearProgress(value: 0.70)),
          const SizedBox(width: GOLSpacing.space2),
          Text('70%', style: textTheme.labelSmall),
        ],
      ),
      const SizedBox(height: GOLSpacing.space3),
      // Action with icon
      Row(
        children: [
          Icon(Iconsax.scissor, size: 16, color: colors.interactivePrimary),
          const SizedBox(width: GOLSpacing.space2),
          Text(
            'Cut A-Roll',
            style: textTheme.labelMedium?.copyWith(
              color: colors.interactivePrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ],
  ),
)
```

**Why this works:**
- Icons reinforce meaning without emojis
- Progress clearly visible
- Action is prominent and clickable
- All info scannable at a glance

---

## Icon Selection Guide

### Outline vs Filled

**Prefer outline icons by default** for a clean, consistent look:

| Category | Outline (Default) | Filled (Use Sparingly) |
|----------|-------------------|------------------------|
| Code | `Iconsax.code` ✓ | `Iconsax.code_15` |
| Speaking | `Iconsax.microphone` ✓ | `Iconsax.microphone_25` |
| Language | `Iconsax.global` ✓ | `Iconsax.global5` |
| Music | `Iconsax.music` ✓ | `Iconsax.music5` |

**When to use filled icons:**
- Specific design requirements
- To emphasize selected/active states
- When explicitly designed for a particular screen

### Common Icons

```dart
// Projects & Files
Iconsax.folder_add     // New project
Iconsax.folder         // Project list
Iconsax.mobile         // App project
Iconsax.star           // Featured/launch

// Skills & Learning
Iconsax.book           // Learning
Iconsax.code_15        // Programming (filled)
Iconsax.microphone_25  // Public speaking (filled)
Iconsax.global5        // Languages (filled)

// Content & Media
Iconsax.video          // Video content
Iconsax.music          // Audio
Iconsax.document_text  // Blog/writing
Iconsax.edit           // Draft/edit

// Performance & Metrics
Iconsax.chart_21       // Analytics
Iconsax.wallet_3       // Revenue
Iconsax.card           // Expenses

// Actions
Iconsax.add            // Create new
Iconsax.search_normal  // Search
Iconsax.setting_2      // Settings
Iconsax.notification   // Alerts
```

---

## Spacing Consistency

### Card Internal Spacing

```dart
GOLCard(
  child: Column(
    children: [
      // Between sections: space4 (16px)
      _Section1(),
      const SizedBox(height: GOLSpacing.space4),
      _Section2(),

      // Between elements: space2-3 (8-12px)
      Icon(...),
      const SizedBox(height: GOLSpacing.space2),
      Text(...),

      // Tight coupling: space1 (4px)
      Text('Title'),
      const SizedBox(height: GOLSpacing.space1),
      Text('Subtitle'),
    ],
  ),
)
```

### Card External Spacing

```dart
ListView(
  padding: EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),  // 16px
  children: [
    Card1(),
    const SizedBox(height: GOLSpacing.betweenCards),  // 12px
    Card2(),
    const SizedBox(height: GOLSpacing.betweenCards),
    Card3(),
    const SizedBox(height: GOLSpacing.betweenSections),  // 24px
    SectionHeader(),
    const SizedBox(height: GOLSpacing.space3),
    Card4(),
  ],
)
```

---

## Common Mistakes

### ❌ Vertical Icon Stacking
```dart
// DON'T DO THIS
Column(
  children: [
    Icon(Iconsax.code, size: 32),
    SizedBox(height: 8),
    Text('Python'),
  ],
)
```

### ✅ Horizontal Icon Alignment
```dart
// DO THIS INSTEAD
Row(
  children: [
    Icon(Iconsax.code, size: 32, color: colors.interactivePrimary),
    SizedBox(width: GOLSpacing.space3),
    Text('Python', style: textTheme.headlineSmall),
  ],
)
```

### ❌ Using Emojis
```dart
// DON'T DO THIS
Text('🎤', style: TextStyle(fontSize: 32))
Text('📱', style: TextStyle(fontSize: 28))
```

### ✅ Using Iconsax Icons (Outline by Default)
```dart
// DO THIS - Outline icons (default)
Icon(Iconsax.microphone, size: 32, color: colors.interactivePrimary)
Icon(Iconsax.mobile, size: 28, color: colors.interactivePrimary)

// USE SPARINGLY - Filled icons (only when needed)
Icon(Iconsax.microphone_25, size: 32, color: colors.interactivePrimary)
```

### ❌ Multiple Separate Cards
```dart
// DON'T DO THIS
Row(
  children: [
    Expanded(child: GOLCard(child: MetricA())),
    SizedBox(width: 8),
    Expanded(child: GOLCard(child: MetricB())),
    SizedBox(width: 8),
    Expanded(child: GOLCard(child: MetricC())),
  ],
)
```

### ✅ Single Combined Card
```dart
// DO THIS INSTEAD
GOLCard(
  child: IntrinsicHeight(
    child: Row(
      children: [
        Expanded(child: MetricA()),
        Container(width: 1, color: colors.borderDefault, margin: ...),
        Expanded(child: MetricB()),
        Container(width: 1, color: colors.borderDefault, margin: ...),
        Expanded(child: MetricC()),
      ],
    ),
  ),
)
```

---

## Screen-Specific Patterns

### Home/Dashboard
- Quick actions: Full-width Row with `MainAxisAlignment.spaceBetween`
- Overview cards: 2-column grid with horizontal value+subtitle
- Today's focus: Simple cards with checkbox + text

### Projects/Skills/Content
- Filter tabs: GOLChip wrapped in GestureDetector
- Item cards: Horizontal icon+text+value layout
- Progress bars: Full-width with percentage

### Performance
- Metrics: Single combined card with dividers
- Top/worst lists: Icon + name/category + profit value

### Assistant
- Messages: Left (system) / Right (user) alignment
- Input area: Icon buttons + TextField + action button

---

## References

- **SPACING_GUIDE.md** - 8pt grid system rules
- **TYPOGRAPHY_GUIDE.md** - Text style hierarchy
- **grow_out_loud_gallery_screen.dart** - Component examples
- **Example screens:**
  - `home_dashboard_screen.dart` - Quick actions, overview cards
  - `performance_screen.dart` - Combined metrics card
  - `skills_screen.dart` - Horizontal card layout
  - `content_screen.dart` - Pipeline cards with icons
