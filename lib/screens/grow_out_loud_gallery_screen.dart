import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

import '../grow_out_loud/components/gol_badges.dart';
import '../grow_out_loud/components/gol_buttons.dart';
import '../grow_out_loud/components/gol_cards.dart';
import '../grow_out_loud/components/gol_chips.dart';
import '../grow_out_loud/components/gol_dividers.dart';
import '../grow_out_loud/components/gol_dropdown.dart';
import '../grow_out_loud/components/gol_grid_loader.dart';
import '../grow_out_loud/components/gol_inputs.dart';
import '../grow_out_loud/components/gol_lists.dart';
import '../grow_out_loud/components/gol_navigation.dart';
import '../grow_out_loud/components/gol_overlays.dart';
import '../grow_out_loud/components/gol_progress.dart';
import '../grow_out_loud/components/gol_skeleton.dart';
import '../grow_out_loud/components/gol_sliders.dart';
import '../grow_out_loud/foundation/gol_colors.dart';
import '../grow_out_loud/foundation/gol_radius.dart';
import '../grow_out_loud/foundation/gol_spacing.dart';
import '../grow_out_loud/foundation/gol_theme.dart';
import '../grow_out_loud/foundation/gol_typography.dart';

class GrowOutLoudGalleryScreen extends StatefulWidget {
  const GrowOutLoudGalleryScreen({super.key});

  @override
  State<GrowOutLoudGalleryScreen> createState() =>
      _GrowOutLoudGalleryScreenState();
}

class _GrowOutLoudGalleryScreenState extends State<GrowOutLoudGalleryScreen>
    with TickerProviderStateMixin {
  bool _checkboxValue = true;
  int _radioValue = 1;
  bool _switchValue = false;
  double _sliderValue = 0.4;
  RangeValues _rangeValues = const RangeValues(0.2, 0.8);
  bool _animateToggle = false;
  String _selectedWorkspace = 'workspace';

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final theme = brightness == Brightness.dark
        ? GOLThemeData.dark()
        : GOLThemeData.light();

    return Theme(
      data: theme,
      child: Builder(
        builder: (context) {
          final colors = Theme.of(context).extension<GOLSemanticColors>()!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Design System: Grow Out Loud'),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(
                    children: [
                      Icon(
                        brightness == Brightness.dark ? Iconsax.moon : Iconsax.sun,
                        size: 18,
                        color: colors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        brightness == Brightness.dark ? 'Dark' : 'Light',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Colors'),
                  Tab(text: 'Typography'),
                  Tab(text: 'Spacing'),
                  Tab(text: 'Components'),
                  Tab(text: 'Patterns'),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildColorsTab(context),
                _buildTypographyTab(context),
                _buildSpacingTab(context),
                _buildComponentsTab(context),
                _buildPatternsTab(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorsTab(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return ListView(
      padding: const EdgeInsets.all(GOLSpacing.space6),
      children: [
        _sectionHeader(context, 'Neutral Scale'),
        _swatchRow(context, [
          GOLPrimitives.neutral0,
          GOLPrimitives.neutral50,
          GOLPrimitives.neutral100,
          GOLPrimitives.neutral200,
          GOLPrimitives.neutral300,
          GOLPrimitives.neutral400,
          GOLPrimitives.neutral500,
          GOLPrimitives.neutral600,
          GOLPrimitives.neutral700,
          GOLPrimitives.neutral800,
          GOLPrimitives.neutral900,
        ]),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Accent Scale'),
        _swatchRow(context, [
          GOLPrimitives.accent50,
          GOLPrimitives.accent100,
          GOLPrimitives.accent200,
          GOLPrimitives.accent300,
          GOLPrimitives.accent400,
          GOLPrimitives.accent500,
          GOLPrimitives.accent600,
          GOLPrimitives.accent700,
          GOLPrimitives.accent800,
        ]),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Semantic Colors'),
        Wrap(
          spacing: GOLSpacing.space3,
          runSpacing: GOLSpacing.space3,
          children: [
            _colorSwatch(context, 'Success', GOLPrimitives.success500),
            _colorSwatch(context, 'Warning', GOLPrimitives.warning500),
            _colorSwatch(context, 'Error', GOLPrimitives.error500),
            _colorSwatch(context, 'Info', GOLPrimitives.info500),
          ],
        ),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Theme Preview'),
        Row(
          children: [
            Expanded(
              child: _themePreview(
                label: 'Light',
                background: GOLPrimitives.neutral0,
                textColor: GOLPrimitives.neutral900,
              ),
            ),
            const SizedBox(width: GOLSpacing.space4),
            Expanded(
              child: _themePreview(
                label: 'Dark',
                background: GOLPrimitives.dark100,
                textColor: GOLPrimitives.dark900,
              ),
            ),
          ],
        ),
        const SizedBox(height: GOLSpacing.space6),
        Text(
          'Accent usage stays under 10% of the surface. The electric cyan is reserved for primary actions and active states.',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildTypographyTab(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return ListView(
      padding: const EdgeInsets.all(GOLSpacing.space6),
      children: [
        _sectionHeader(context, 'Display'),
        _typeSample(context, 'display-lg',
            Theme.of(context).textTheme.displayLarge!),
        _typeSample(context, 'display-md',
            Theme.of(context).textTheme.displayMedium!),
        const SizedBox(height: GOLSpacing.space6),
        _sectionHeader(context, 'Headings'),
        _typeSample(context, 'heading-xl',
            Theme.of(context).textTheme.displaySmall!),
        _typeSample(context, 'heading-lg',
            Theme.of(context).textTheme.headlineLarge!),
        _typeSample(context, 'heading-md',
            Theme.of(context).textTheme.headlineMedium!),
        _typeSample(context, 'heading-sm',
            Theme.of(context).textTheme.headlineSmall!),
        _typeSample(context, 'heading-xs',
            Theme.of(context).textTheme.titleLarge!),
        const SizedBox(height: GOLSpacing.space6),
        _sectionHeader(context, 'Body'),
        _typeSample(context, 'body-lg', Theme.of(context).textTheme.bodyLarge!),
        _typeSample(context, 'body-md', Theme.of(context).textTheme.bodyMedium!),
        _typeSample(context, 'body-sm', Theme.of(context).textTheme.bodySmall!),
        const SizedBox(height: GOLSpacing.space6),
        _sectionHeader(context, 'UI Text'),
        _typeSample(context, 'ui-lg', Theme.of(context).textTheme.labelLarge!),
        _typeSample(context, 'ui-md', Theme.of(context).textTheme.labelMedium!),
        _typeSample(context, 'ui-sm', Theme.of(context).textTheme.labelSmall!),
        const SizedBox(height: GOLSpacing.space6),
        _sectionHeader(context, 'Caption & Micro'),
        _typeSample(context, 'caption', GOLTypography.caption(colors.textSecondary)),
        _typeSample(context, 'overline',
            GOLTypography.overline(colors.textSecondary),
            sample: 'SECTION LABEL'),
        _typeSample(context, 'micro', GOLTypography.micro(colors.textSecondary)),
        const SizedBox(height: GOLSpacing.space6),
        _sectionHeader(context, 'Mono'),
        _typeSample(
          context,
          'jetbrains-mono',
          GOLTypography.mono(
            size: 14,
            weight: FontWeight.w500,
            color: colors.textPrimary,
          ),
          sample: 'REQ-2048  |  12,403.32',
        ),
      ],
    );
  }

  Widget _buildSpacingTab(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return ListView(
      padding: const EdgeInsets.all(GOLSpacing.space6),
      children: [
        _sectionHeader(context, '8-point Grid'),
        _spacingScaleRow(context, [
          _SpacingToken('4px', GOLSpacing.space1),
          _SpacingToken('8px', GOLSpacing.space2),
          _SpacingToken('12px', GOLSpacing.space3),
          _SpacingToken('16px', GOLSpacing.space4),
          _SpacingToken('20px', GOLSpacing.space5),
          _SpacingToken('24px', GOLSpacing.space6),
          _SpacingToken('32px', GOLSpacing.space7),
          _SpacingToken('40px', GOLSpacing.space8),
          _SpacingToken('48px', GOLSpacing.space9),
          _SpacingToken('56px', GOLSpacing.space10),
          _SpacingToken('64px', GOLSpacing.space11),
          _SpacingToken('80px', GOLSpacing.space12),
        ]),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Screen Layout Tokens'),
        _spacingInfoRow(
          context,
          label: 'Screen padding (mobile)',
          value: '16px horizontal',
          detail: '16px inner gutter, 56px top when app bar present',
        ),
        _spacingInfoRow(
          context,
          label: 'Screen padding (tablet)',
          value: '24px horizontal',
          detail: 'More breathing room for wider viewports',
        ),
        _spacingInfoRow(
          context,
          label: 'Bottom padding',
          value: '88px above nav / 32px no nav',
          detail: 'Safe area aware (iOS bottom inset ~34px)',
        ),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Component Spacing'),
        _spacingInfoRow(
          context,
          label: 'Button gap (inline)',
          value: '12px horizontal',
          detail: 'Aligns icon + text, prevents crossing',
        ),
        _spacingInfoRow(
          context,
          label: 'Form field gap',
          value: '16px vertical',
          detail: 'Labels, inputs, helper text keep rhythm',
        ),
        _spacingInfoRow(
          context,
          label: 'Card padding',
          value: '16px / 20px / 24px',
          detail: 'Use tighter padding for dense data, more room for storytelling',
        ),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Internal ≤ External'),
        Row(
          children: [
            Expanded(
              child: GOLCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Correct', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: GOLSpacing.space2),
                    Text(
                      'Card padding 16px, margin 16px between cards.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: GOLSpacing.space3),
            Expanded(
              child: GOLCard(
                variant: GOLCardVariant.standard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Incorrect', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: GOLSpacing.space2),
                    Text(
                      'Padding 24px, spacing 16px (internal > external).',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colors.stateWarning,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Touch Targets'),
        _spacingInfoRow(
          context,
          label: 'Minimum tap area',
          value: '48 × 48px',
          detail: 'Primary CTAs use 56 × 56px (height), icon buttons 48 × 48px.',
        ),
        _spacingInfoRow(
          context,
          label: 'Floating action',
          value: '56px circle / 40px mini',
          detail: 'Positioned 24px from edges when no nav, 88px above bottom nav.',
        ),
        const SizedBox(height: GOLSpacing.space6),
        Text(
          'Spacing tokens stay grounded on the 8-point grid. Mix inset/stack/inline tokens in your layouts to keep rhythm and clarity.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
        ),
      ],
    );
  }

  Widget _buildComponentsTab(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return ListView(
      padding: const EdgeInsets.all(GOLSpacing.space6),
      children: [
        _sectionHeader(context, 'Buttons'),
        Text(
          '8PT GRID SYSTEM: All button heights follow multiples of 8 (or 4 for very small spacing)',
          style: GOLTypography.overline(colors.textTertiary),
        ),
        const SizedBox(height: GOLSpacing.space3),
        _usageNote(
          context,
          'Large: 48px height (8×6), 12px vertical padding (4×3)',
        ),
        _usageNote(
          context,
          'Medium: 40px height (8×5), 8px vertical padding (8×1)',
        ),
        _usageNote(
          context,
          'Small: 32px height (8×4), 4px vertical padding (4×1)',
        ),
        const SizedBox(height: GOLSpacing.space4),
        Wrap(
          spacing: GOLSpacing.space3,
          runSpacing: GOLSpacing.space3,
          children: [
            GOLButton(
              label: 'Large Primary',
              size: GOLButtonSize.large,
              onPressed: () {},
            ),
            GOLButton(label: 'Medium Primary', onPressed: () {}),
            GOLButton(
              label: 'Small Primary',
              size: GOLButtonSize.small,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: GOLSpacing.space3),
        Wrap(
          spacing: GOLSpacing.space3,
          runSpacing: GOLSpacing.space3,
          children: [
            GOLButton(
              label: 'Secondary',
              variant: GOLButtonVariant.secondary,
              onPressed: () {},
            ),
            GOLButton(
              label: 'Tertiary',
              variant: GOLButtonVariant.tertiary,
              onPressed: () {},
            ),
            GOLButton(
              label: 'Destructive',
              variant: GOLButtonVariant.destructive,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: GOLSpacing.space4),
        _usageNote(
          context,
          'Use Primary for main actions, Secondary for alternatives, Tertiary for low-priority actions, and Destructive for dangerous operations.',
        ),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Cards'),
        GOLCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Standard card',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: GOLSpacing.space2),
              Text(
                'Dense layout, quiet borders, and clear hierarchy.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: GOLSpacing.space3),
        GOLCard(
          variant: GOLCardVariant.elevated,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Elevated card',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: GOLSpacing.space2),
              Text(
                'Raised surface for focus areas and key modules.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Form Inputs'),
        GOLTextField(
          label: 'Project Name',
          hintText: 'Grow Out Loud Launch',
          helperText: 'Give the project a clear label.',
        ),
        const SizedBox(height: GOLSpacing.space4),
        GOLTextField(
          label: 'Email',
          hintText: 'name@company.com',
          errorText: 'Email address is invalid.',
        ),
        const SizedBox(height: GOLSpacing.space4),
        GOLSearchField(hintText: 'Search projects...'),
        const SizedBox(height: GOLSpacing.space4),
        GOLDropdown<String>(
          label: 'Workspace',
          value: _selectedWorkspace,
          hint: 'Select workspace',
          items: const [
            GOLDropdownItem(value: 'workspace', label: 'Workspace'),
            GOLDropdownItem(value: 'insights', label: 'Insights', icon: Icon(Iconsax.chart)),
            GOLDropdownItem(value: 'studio', label: 'Studio', icon: Icon(Iconsax.paintbucket)),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedWorkspace = value);
            }
          },
        ),
        const SizedBox(height: GOLSpacing.space4),
        GOLCheckboxTile(
          value: _checkboxValue,
          onChanged: (value) => setState(() => _checkboxValue = value ?? false),
          label: 'Notify me about milestone updates.',
        ),
        const SizedBox(height: GOLSpacing.space3),
        GOLRadioTile<int>(
          value: 1,
          groupValue: _radioValue,
          onChanged: (value) => setState(() => _radioValue = value ?? 1),
          label: 'Weekly summary',
        ),
        const SizedBox(height: GOLSpacing.space2),
        GOLRadioTile<int>(
          value: 2,
          groupValue: _radioValue,
          onChanged: (value) => setState(() => _radioValue = value ?? 1),
          label: 'Monthly report',
        ),
        const SizedBox(height: GOLSpacing.space3),
        GOLSwitchTile(
          value: _switchValue,
          onChanged: (value) => setState(() => _switchValue = value),
          label: 'Enable focus mode',
        ),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Navigation'),
        const GOLAppBarPreview(),
        const SizedBox(height: GOLSpacing.space4),
        const GOLTabBarPreview(),
        const SizedBox(height: GOLSpacing.space4),
        const GOLBottomNavPreview(),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Chips & Badges'),
        Wrap(
          spacing: GOLSpacing.space3,
          runSpacing: GOLSpacing.space3,
          children: [
            const GOLChip(label: 'Active', selected: true),
            const GOLChip(label: 'Draft', selected: false),
            GOLChip(
              label: 'Design',
              variant: GOLChipVariant.input,
              onDeleted: () {},
            ),
            const GOLChip(label: 'Success', variant: GOLChipVariant.status),
          ],
        ),
        const SizedBox(height: GOLSpacing.space3),
        Row(
          children: const [
            GOLBadge(variant: GOLBadgeVariant.dot),
            SizedBox(width: GOLSpacing.space3),
            GOLBadge(variant: GOLBadgeVariant.count, count: '24'),
          ],
        ),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Lists'),
        GOLCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              GOLListItem(
                leading: Icon(
                  Iconsax.folder,
                  size: 24,
                  color: colors.textSecondary,
                ),
                title: 'Campaign Assets',
                subtitle: 'Updated 4 hours ago',
                trailing: Icon(
                  Iconsax.arrow_right,
                  size: 20,
                  color: colors.textSecondary,
                ),
              ),
              Divider(height: 1, color: colors.borderDefault),
              GOLListItem(
                leading: Icon(
                  Iconsax.document,
                  size: 24,
                  color: colors.textSecondary,
                ),
                title: 'Weekly Brief',
                subtitle: 'Ready for review',
                trailing: Icon(
                  Iconsax.arrow_right,
                  size: 20,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: GOLSpacing.space5),
        _sectionHeader(context, 'Dividers'),
        Row(
          children: [
            Expanded(
              child: Text(
                'Navigation',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Container(
              width: 1,
              height: 48,
              color: colors.borderDefault,
            ),
            Expanded(
              child: Text(
                'Actions',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: GOLSpacing.space4),
        const GOLDivider(),
        const SizedBox(height: GOLSpacing.space4),
        const GOLDivider(label: 'OR'),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Menu'),
        GOLCard(
          child: Column(
            children: [
            _menuTile(
              context,
              icon: Iconsax.menu_board,
              label: 'Workspace',
              detail: 'Switch between spaces',
            ),
            _menuTile(
              context,
              icon: Iconsax.setting_2,
              label: 'Settings',
              detail: 'Configure automations',
            ),
              _menuTile(
                context,
                icon: Iconsax.support,
                label: 'Help Desk',
                detail: 'Share feedback or report bugs',
              ),
            ],
          ),
        ),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Iconography'),
        Wrap(
          spacing: GOLSpacing.space3,
          runSpacing: GOLSpacing.space3,
          children: [
            _iconSpot(
              context,
              label: 'Home',
              icon: Icon(
                Iconsax.home_2,
                size: 32,
                color: colors.textPrimary,
              ),
            ),
            _iconSpot(
              context,
              label: 'Face',
              icon: Icon(
                Iconsax.smileys,
                size: 32,
                color: colors.interactivePrimary,
              ),
            ),
            _iconSpot(
              context,
              label: 'Notifications',
              icon: Icon(
                Iconsax.notification_bing,
                size: 32,
                color: colors.stateWarning,
              ),
            ),
            _iconSpot(
              context,
              label: 'Facebook',
              icon: SvgPicture.asset(
                'assets/icons/facebook.svg',
                height: 32,
                width: 32,
              ),
            ),
            _iconSpot(
              context,
              label: 'TikTok',
              icon: SvgPicture.asset(
                'assets/icons/tiktok.svg',
                height: 32,
                width: 32,
              ),
            ),
            _iconSpot(
              context,
              label: 'Google Ads',
              icon: SvgPicture.asset(
                'assets/icons/google-ads.svg',
                height: 32,
                width: 32,
              ),
            ),
            _iconSpot(
              context,
              label: 'LinkedIn',
              icon: SvgPicture.asset(
                'assets/icons/linkedin.svg',
                height: 32,
                width: 32,
              ),
            ),
            _iconSpot(
              context,
              label: 'X',
              icon: SvgPicture.asset(
                'assets/icons/x.svg',
                height: 32,
                width: 32,
              ),
            ),
            _iconSpot(
              context,
              label: 'Reddit',
              icon: SvgPicture.asset(
                'assets/icons/reddit.svg',
                height: 32,
                width: 32,
              ),
            ),
            _iconSpot(
              context,
              label: 'YouTube',
              icon: SvgPicture.asset(
                'assets/icons/youtube.svg',
                height: 32,
                width: 32,
              ),
            ),
          ],
        ),
        const SizedBox(height: GOLSpacing.space2),
        Text(
          'Platform icons with branded colors. All 7 platforms now available: Facebook, TikTok, Google Ads, LinkedIn, X, Reddit, YouTube. Use these SVG assets from assets/icons/ whenever you need social/ad platform icons.',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Progress'),
        const GOLLinearProgress(value: 0.6),
        const SizedBox(height: GOLSpacing.space3),
        const GOLLinearProgress(),
        const SizedBox(height: GOLSpacing.space3),
        const GOLCircularProgress(size: 48, value: 0.75),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Sliders'),
        GOLSlider(
          value: _sliderValue,
          onChanged: (value) => setState(() => _sliderValue = value),
        ),
        const SizedBox(height: GOLSpacing.space4),
        GOLRangeSlider(
          values: _rangeValues,
          onChanged: (values) => setState(() => _rangeValues = values),
        ),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Dividers'),
        const GOLDivider(),
        const SizedBox(height: GOLSpacing.space4),
        const GOLDivider(label: 'OR'),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Empty State'),
        _emptyStateCard(context),
      ],
    );
  }

  Widget _buildPatternsTab(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return ListView(
      padding: const EdgeInsets.all(GOLSpacing.space6),
      children: [
        _sectionHeader(context, 'Loading States'),
        Row(
          children: const [
            GOLGridLoader(size: 48),
            SizedBox(width: GOLSpacing.space4),
            Expanded(child: GOLLinearProgress()),
          ],
        ),
        const SizedBox(height: GOLSpacing.space4),
        Row(
          children: const [
            GOLSkeleton(width: 48, height: 48, radius: GOLRadius.full),
            SizedBox(width: GOLSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GOLSkeleton(width: 160, height: 16),
                  SizedBox(height: GOLSpacing.space2),
                  GOLSkeleton(width: 120, height: 12),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Overlays'),
        Wrap(
          spacing: GOLSpacing.space3,
          runSpacing: GOLSpacing.space3,
          children: [
            GOLButton(
              label: 'Show Dialog',
              onPressed: () => showGOLDialog(context),
            ),
            GOLButton(
              label: 'Bottom Sheet',
              variant: GOLButtonVariant.secondary,
              onPressed: () => showGOLBottomSheet(context),
            ),
            GOLButton(
              label: 'Toast',
              variant: GOLButtonVariant.tertiary,
              onPressed: () => showGOLToast(context, 'Saved to timeline.'),
            ),
          ],
        ),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Toasts'),
        Column(
          children: [
            _toastPreview(
              context,
              icon: Iconsax.tick_circle5,
              message: 'Project saved',
              iconColor: colors.stateSuccess,
            ),
            const SizedBox(height: GOLSpacing.space3),
            _toastPreview(
              context,
              icon: Iconsax.close_circle5,
              message: 'Failed to sync',
              iconColor: colors.stateError,
            ),
            const SizedBox(height: GOLSpacing.space3),
            _toastPreview(
              context,
              icon: Iconsax.warning_25,
              message: 'Connection unstable',
              iconColor: colors.stateWarning,
            ),
            const SizedBox(height: GOLSpacing.space3),
            _toastPreview(
              context,
              icon: Iconsax.info_circle5,
              message: 'New update available',
              iconColor: colors.interactivePrimary,
            ),
          ],
        ),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Animations'),
        Row(
          children: [
            GOLButton(
              label: _animateToggle ? 'Reset' : 'Animate',
              variant: GOLButtonVariant.secondary,
              onPressed: () => setState(() => _animateToggle = !_animateToggle),
            ),
            const SizedBox(width: GOLSpacing.space4),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                height: 64,
                decoration: BoxDecoration(
                  color: _animateToggle
                      ? colors.interactivePrimary
                      : colors.backgroundTertiary,
                  borderRadius: BorderRadius.circular(GOLRadius.md),
                ),
                child: Center(
                  child: Text(
                    _animateToggle ? 'Active' : 'Idle',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _animateToggle
                              ? colors.textInverse
                              : colors.textSecondary,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: GOLSpacing.space7),
        _sectionHeader(context, 'Error State'),
        GOLCard(
          child: Row(
            children: [
              Icon(Iconsax.danger, size: 24, color: colors.stateError),
              const SizedBox(width: GOLSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sync failed',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      'We could not refresh your metrics. Try again.',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              GOLButton(
                label: 'Retry',
                size: GOLButtonSize.small,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: GOLSpacing.space3),
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    );
  }

  Widget _typeSample(
    BuildContext context,
    String label,
    TextStyle style, {
    String? sample,
  }) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: GOLSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GOLTypography.mono(
              size: 12,
              weight: FontWeight.w500,
              color: colors.textTertiary,
            ),
          ),
          const SizedBox(height: GOLSpacing.space1),
          Text(sample ?? 'Precision in every line.', style: style),
        ],
      ),
    );
  }

  Widget _spacingScaleRow(BuildContext context, List<_SpacingToken> tokens) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return Wrap(
      spacing: GOLSpacing.space3,
      runSpacing: GOLSpacing.space3,
      children: tokens
          .map(
            (token) => Container(
              width: 128,
              padding: const EdgeInsets.all(GOLSpacing.space3),
              decoration: BoxDecoration(
                color: colors.surfaceRaised,
                borderRadius: BorderRadius.circular(GOLRadius.sm),
                border: Border.all(color: colors.borderDefault),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 8,
                    width: (token.value * 2).clamp(24.0, 160.0),
                    decoration: BoxDecoration(
                      color: colors.borderStrong,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: GOLSpacing.space2),
                  Text(token.label, style: Theme.of(context).textTheme.bodyMedium),
                  Text('${token.value.toInt()}px',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: colors.textTertiary)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _spacingInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    required String detail,
  }) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: GOLSpacing.space3),
      child: GOLCard(
        variant: GOLCardVariant.standard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: GOLSpacing.space1),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: colors.textAccent),
            ),
            const SizedBox(height: GOLSpacing.space1),
            Text(
              detail,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String detail,
  }) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: colors.textAccent, size: 24),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(
        detail,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
      ),
      trailing: Icon(Iconsax.arrow_right, color: colors.textSecondary, size: 20),
    );
  }

  Widget _iconSpot(BuildContext context, {required String label, required Widget icon}) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return Container(
      width: 120,
      padding: const EdgeInsets.all(GOLSpacing.space3),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(GOLRadius.sm),
        border: Border.all(color: colors.borderDefault),
      ),
      child: Column(
        children: [
          icon,
          const SizedBox(height: GOLSpacing.space2),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _toastPreview(
    BuildContext context, {
    required IconData icon,
    required String message,
    required Color iconColor,
  }) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(GOLSpacing.space3),
      decoration: BoxDecoration(
        color: colors.surfaceDefault,
        borderRadius: BorderRadius.circular(GOLRadius.sm),
        border: Border.all(
          color: colors.borderDefault,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: GOLSpacing.space4),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorSwatch(BuildContext context, String label, Color color) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return Container(
      width: 100,
      padding: const EdgeInsets.all(GOLSpacing.space2),
      decoration: BoxDecoration(
        color: colors.surfaceDefault,
        borderRadius: BorderRadius.circular(GOLRadius.sm),
        border: Border.all(color: colors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(GOLRadius.xs),
            ),
          ),
          const SizedBox(height: GOLSpacing.space2),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          Text(
            _hex(color),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _swatchRow(BuildContext context, List<Color> colors) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: colors
            .map(
              (color) => Padding(
                padding: const EdgeInsets.only(right: GOLSpacing.space2),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(GOLRadius.xs),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _themePreview({
    required String label,
    required Color background,
    required Color textColor,
  }) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(GOLSpacing.space4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(GOLRadius.md),
        border: Border.all(color: GOLPrimitives.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: textColor, fontSize: 12)),
          const SizedBox(height: 8),
          Text(
            'Preview',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            height: 8,
            width: 48,
            decoration: BoxDecoration(
              color: GOLPrimitives.accent500,
              borderRadius: BorderRadius.circular(GOLRadius.full),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyStateCard(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return GOLCard(
      variant: GOLCardVariant.elevated,
      child: Column(
        children: [
          Icon(Iconsax.direct_inbox, size: 48, color: colors.textTertiary),
          const SizedBox(height: GOLSpacing.space3),
          Text(
            'No projects yet',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: GOLSpacing.space2),
          Text(
            'Create your first project to start tracking progress.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: GOLSpacing.space4),
          GOLButton(label: 'Create Project', onPressed: () {}),
        ],
      ),
    );
  }

  String _hex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  Widget _usageNote(BuildContext context, String text) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: GOLSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Iconsax.info_circle, size: 16, color: colors.textAccent),
          const SizedBox(width: GOLSpacing.space2),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpacingToken {
  final String label;
  final double value;

  const _SpacingToken(this.label, this.value);
}
