import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../grow_out_loud/foundation/gol_colors.dart';
import '../../../grow_out_loud/foundation/gol_spacing.dart';
import '../../../grow_out_loud/foundation/gol_radius.dart';
import '../../../grow_out_loud/components/gol_buttons.dart';
import '../../../grow_out_loud/components/gol_cards.dart';
import '../../../grow_out_loud/components/gol_overlays.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/database_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../core/constants/currency_constants.dart';
import '../../../routing/routes.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Screen 34: Settings Page
///
/// Single scrollable page with all app settings organized into sections.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Notification states (will be implemented later)
  bool _pushNotificationsEnabled = true;
  bool _dailyReminderEnabled = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 21, minute: 0);
  bool _weeklySummaryEnabled = true;

  // Dropdown expanded states
  bool _languageExpanded = false;
  bool _currencyExpanded = false;
  bool _themeExpanded = false;

  // Loading state
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final user = ref.watch(currentUserProvider);
    final pendingSyncCount = ref.watch(pendingSyncCountProvider);
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(GOLSpacing.screenPaddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: GOLSpacing.space4),

              // Header - matching Dashboard style
              Text(
                l10n.settings,
                style: textTheme.displaySmall?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                l10n.settingsSubtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),

              const SizedBox(height: GOLSpacing.space6),

              // ACCOUNT SECTION
              _SectionHeader(title: l10n.account),
              const SizedBox(height: GOLSpacing.space3),
              _AccountCard(
                email: user?.email ?? l10n.defaultUserEmail,
                name: user?.userMetadata?['full_name'] as String? ??
                      user?.email?.split('@').first ?? l10n.defaultUserName,
                defaultInitial: l10n.defaultUserInitial,
              ),

              const SizedBox(height: GOLSpacing.space6),

              // PREFERENCES SECTION
              _SectionHeader(title: l10n.preferences),
              const SizedBox(height: GOLSpacing.space3),

              // Language dropdown
              _DropdownTile(
                icon: Iconsax.global,
                label: l10n.language,
                value: _getLanguageDisplayName(settings.language, l10n),
                isExpanded: _languageExpanded,
                onTap: () => setState(() {
                  _languageExpanded = !_languageExpanded;
                  _currencyExpanded = false;
                  _themeExpanded = false;
                }),
                options: [l10n.languageEnglish, l10n.languageFrench],
                onOptionSelected: (value) async {
                  setState(() => _languageExpanded = false);
                  // Map display name back to storage value
                  final languageValue = value == l10n.languageFrench ? 'French' : 'English';
                  await ref.read(settingsProvider.notifier).setLanguage(languageValue);
                  if (!mounted) return;
                  showGOLToast(
                    context,
                    l10n.languageUpdated(value),
                    variant: GOLToastVariant.success,
                  );
                },
              ),

              const SizedBox(height: GOLSpacing.space3),

              // Currency dropdown
              _DropdownTile(
                icon: Iconsax.dollar_circle,
                label: l10n.defaultCurrency,
                value: _getCurrencyLabel(settings.currencyCode),
                isExpanded: _currencyExpanded,
                onTap: () => setState(() {
                  _currencyExpanded = !_currencyExpanded;
                  _languageExpanded = false;
                  _themeExpanded = false;
                }),
                options: CurrencyConstants.supportedCurrencies
                    .map((c) => '${c.code} (${c.symbol})')
                    .toList(),
                onOptionSelected: (value) async {
                  setState(() => _currencyExpanded = false);
                  final code = value.split(' ').first;
                  await ref.read(settingsProvider.notifier).setCurrency(code);
                  if (!mounted) return;
                  showGOLToast(
                    context,
                    l10n.currencyUpdated,
                    variant: GOLToastVariant.success,
                  );
                },
              ),

              const SizedBox(height: GOLSpacing.space3),

              // Theme dropdown
              _DropdownTile(
                icon: Iconsax.moon,
                label: l10n.theme,
                value: _getThemeLabelLocalized(settings.themeMode, l10n),
                isExpanded: _themeExpanded,
                onTap: () => setState(() {
                  _themeExpanded = !_themeExpanded;
                  _languageExpanded = false;
                  _currencyExpanded = false;
                }),
                options: [l10n.themeLight, l10n.themeDark, l10n.themeSystem],
                onOptionSelected: (value) async {
                  setState(() => _themeExpanded = false);
                  final mode = _getThemeModeFromLocalizedLabel(value, l10n);
                  await ref.read(settingsProvider.notifier).setThemeMode(mode);
                  if (!mounted) return;
                  showGOLToast(
                    context,
                    l10n.themeUpdated,
                    variant: GOLToastVariant.success,
                  );
                },
              ),

              const SizedBox(height: GOLSpacing.space6),

              // NOTIFICATIONS SECTION
              _SectionHeader(title: l10n.notifications),
              const SizedBox(height: GOLSpacing.space3),

              // Push notifications toggle
              _ToggleTile(
                icon: Iconsax.notification,
                title: l10n.pushNotifications,
                subtitle: l10n.comingSoon,
                value: _pushNotificationsEnabled,
                onChanged: null, // Disabled for now
              ),

              const SizedBox(height: GOLSpacing.space3),

              // Daily reminder
              _ToggleTile(
                icon: Iconsax.clock,
                title: l10n.dailyReminder,
                subtitle: l10n.comingSoon,
                value: _dailyReminderEnabled,
                onChanged: null, // Disabled for now
              ),

              const SizedBox(height: GOLSpacing.space3),

              // Weekly summary
              _ToggleTile(
                icon: Iconsax.chart,
                title: l10n.weeklySummary,
                subtitle: l10n.comingSoon,
                value: _weeklySummaryEnabled,
                onChanged: null, // Disabled for now
              ),

              const SizedBox(height: GOLSpacing.space6),

              // DATA & STORAGE SECTION
              _SectionHeader(title: l10n.dataAndStorage),
              const SizedBox(height: GOLSpacing.space3),

              _SyncStatusCard(
                pendingCount: pendingSyncCount.when(
                  data: (count) => count,
                  loading: () => 0,
                  error: (_, _) => 0,
                ),
                l10n: l10n,
                onSync: () {
                  showGOLToast(
                    context,
                    l10n.syncComingSoon,
                    variant: GOLToastVariant.info,
                  );
                },
              ),

              const SizedBox(height: GOLSpacing.space6),

              // ABOUT SECTION
              _SectionHeader(title: l10n.about),
              const SizedBox(height: GOLSpacing.space3),

              _InfoTile(
                icon: Iconsax.info_circle,
                title: l10n.version,
                value: '1.0.0',
                subtitle: 'Build 2026.01.04',
              ),

              const SizedBox(height: GOLSpacing.space3),

              _LinkTile(
                icon: Iconsax.shield_tick,
                title: l10n.privacyPolicy,
                onTap: () {
                  showGOLToast(context, l10n.comingSoon, variant: GOLToastVariant.info);
                },
              ),

              const SizedBox(height: GOLSpacing.space3),

              _LinkTile(
                icon: Iconsax.document_text,
                title: l10n.termsOfService,
                onTap: () {
                  showGOLToast(context, l10n.comingSoon, variant: GOLToastVariant.info);
                },
              ),

              const SizedBox(height: GOLSpacing.space7),

              // LOGOUT BUTTON
              SizedBox(
                width: double.infinity,
                child: GOLButton(
                  label: _isLoggingOut ? l10n.loggingOut : l10n.logout,
                  variant: GOLButtonVariant.destructive,
                  onPressed: _isLoggingOut ? null : () => _showLogoutConfirmation(l10n),
                ),
              ),

              const SizedBox(height: GOLSpacing.space7),
            ],
          ),
        ),
      ),
    );
  }

  String _getCurrencyLabel(String code) {
    final currency = CurrencyConstants.getCurrency(code);
    return '${currency.code} (${currency.symbol})';
  }

  String _getLanguageDisplayName(String language, AppLocalizations l10n) {
    return switch (language) {
      'French' => l10n.languageFrench,
      _ => l10n.languageEnglish,
    };
  }

  String _getThemeLabelLocalized(ThemeMode mode, AppLocalizations l10n) {
    return switch (mode) {
      ThemeMode.light => l10n.themeLight,
      ThemeMode.dark => l10n.themeDark,
      ThemeMode.system => l10n.themeSystem,
    };
  }

  ThemeMode _getThemeModeFromLocalizedLabel(String label, AppLocalizations l10n) {
    if (label == l10n.themeLight) return ThemeMode.light;
    if (label == l10n.themeDark) return ThemeMode.dark;
    return ThemeMode.system;
  }

  void _showLogoutConfirmation(AppLocalizations l10n) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: colors.surfaceDefault,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GOLRadius.modal),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colors.stateError.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.logout,
                size: 32,
                color: colors.stateError,
              ),
            ),
            const SizedBox(height: GOLSpacing.space4),
            Text(
              l10n.logoutConfirmTitle,
              style: textTheme.titleLarge?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: GOLSpacing.space3),
            Text(
              l10n.logoutConfirmMessage,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GOLSpacing.space2),
            Text(
              l10n.logoutConfirmSubtext,
              style: textTheme.bodySmall?.copyWith(
                color: colors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GOLSpacing.space3),
            Container(
              padding: const EdgeInsets.all(GOLSpacing.space3),
              decoration: BoxDecoration(
                color: colors.stateSuccess.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(GOLRadius.md),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.tick_circle,
                    size: 16,
                    color: colors.stateSuccess,
                  ),
                  const SizedBox(width: GOLSpacing.space2),
                  Expanded(
                    child: Text(
                      l10n.logoutDataSaved,
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.stateSuccess,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: GOLButton(
                  label: l10n.cancel,
                  variant: GOLButtonVariant.secondary,
                  onPressed: () => Navigator.pop(dialogContext),
                ),
              ),
              const SizedBox(width: GOLSpacing.space3),
              Expanded(
                child: GOLButton(
                  label: l10n.logout,
                  variant: GOLButtonVariant.destructive,
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    await _handleLogout();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoggingOut = true);

    final result = await ref.read(authProvider.notifier).signOut();

    if (!mounted) return;

    if (result.success) {
      context.go(Routes.login);
    } else {
      setState(() => _isLoggingOut = false);
      showGOLToast(
        context,
        result.error ?? l10n.failedToLogout,
        variant: GOLToastVariant.error,
      );
    }
  }
}

// =============================================================================
// HELPER WIDGETS
// =============================================================================

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      title,
      style: textTheme.labelSmall?.copyWith(
        color: colors.textTertiary,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final String email;
  final String name;
  final String defaultInitial;

  const _AccountCard({
    required this.email,
    required this.name,
    required this.defaultInitial,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final initials = name.isNotEmpty
        ? name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
        : defaultInitial;

    return GOLCard(
      variant: GOLCardVariant.elevated,
      padding: const EdgeInsets.all(GOLSpacing.cardPadding),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colors.interactivePrimary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: textTheme.titleLarge?.copyWith(
                  color: colors.interactivePrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: GOLSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.titleMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isExpanded;
  final VoidCallback onTap;
  final List<String> options;
  final ValueChanged<String> onOptionSelected;

  const _DropdownTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.isExpanded,
    required this.onTap,
    required this.options,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return GOLCard(
      variant: GOLCardVariant.standard,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(GOLRadius.md),
            child: Padding(
              padding: const EdgeInsets.all(GOLSpacing.cardPadding),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: colors.textSecondary),
                  const SizedBox(width: GOLSpacing.space3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          value,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isExpanded ? Iconsax.arrow_up_2 : Iconsax.arrow_down_1,
                    size: 16,
                    color: colors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: colors.borderDefault),
                ),
              ),
              child: Column(
                children: options.map((option) {
                  final isSelected = value == option || value.startsWith(option.split(' ').first);
                  return InkWell(
                    onTap: () => onOptionSelected(option),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: GOLSpacing.cardPadding,
                        vertical: GOLSpacing.space3,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: isSelected
                                ? colors.interactivePrimary
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Iconsax.tick_circle5
                                : Iconsax.record,
                            size: 18,
                            color: isSelected
                                ? colors.interactivePrimary
                                : colors.textTertiary,
                          ),
                          const SizedBox(width: GOLSpacing.space3),
                          Text(
                            option,
                            style: textTheme.bodyMedium?.copyWith(
                              color: isSelected
                                  ? colors.interactivePrimary
                                  : colors.textPrimary,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final isDisabled = onChanged == null;

    return GOLCard(
      variant: GOLCardVariant.standard,
      padding: const EdgeInsets.all(GOLSpacing.cardPadding),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDisabled ? colors.textTertiary : colors.textSecondary,
          ),
          const SizedBox(width: GOLSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyMedium?.copyWith(
                    color: isDisabled ? colors.textTertiary : colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: colors.interactivePrimary,
          ),
        ],
      ),
    );
  }
}

class _SyncStatusCard extends StatelessWidget {
  final int pendingCount;
  final AppLocalizations l10n;
  final VoidCallback onSync;

  const _SyncStatusCard({
    required this.pendingCount,
    required this.l10n,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    final isSynced = pendingCount == 0;

    return GOLCard(
      variant: GOLCardVariant.standard,
      padding: const EdgeInsets.all(GOLSpacing.cardPadding),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSynced
                  ? colors.stateSuccess.withValues(alpha: 0.1)
                  : colors.stateWarning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isSynced ? Iconsax.tick_circle : Iconsax.cloud,
              size: 20,
              color: isSynced ? colors.stateSuccess : colors.stateWarning,
            ),
          ),
          const SizedBox(width: GOLSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSynced ? l10n.allDataSynced : l10n.itemsPendingSync(pendingCount),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  isSynced ? l10n.lastSynced : l10n.willSyncWhenOnline,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onSync,
            icon: Icon(
              Iconsax.refresh,
              color: colors.interactivePrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return GOLCard(
      variant: GOLCardVariant.standard,
      padding: const EdgeInsets.all(GOLSpacing.cardPadding),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.textSecondary),
          const SizedBox(width: GOLSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _LinkTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return GOLCard(
      variant: GOLCardVariant.standard,
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(GOLRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(GOLSpacing.cardPadding),
          child: Row(
            children: [
              Icon(icon, size: 20, color: colors.textSecondary),
              const SizedBox(width: GOLSpacing.space3),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Iconsax.arrow_right_3,
                size: 16,
                color: colors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
