import 'dart:io';

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
import '../../../providers/settings_provider.dart';
import '../../../providers/sync_provider.dart';
import '../../../providers/connectivity_provider.dart';
import '../../../services/notification_service.dart';
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

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with WidgetsBindingObserver {
  // Dropdown expanded states
  bool _languageExpanded = false;
  bool _currencyExpanded = false;
  bool _themeExpanded = false;

  // Loading state
  bool _isLoggingOut = false;

  // Notification permission states
  bool _hasNotificationPermission = true; // Assume true until checked
  bool _hasExactAlarmPermission = true; // Assume true until checked (Android only)

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkNotificationPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-check permissions when app comes back to foreground
    if (state == AppLifecycleState.resumed) {
      _checkNotificationPermissions();
    }
  }

  Future<void> _checkNotificationPermissions() async {
    final notificationService = ref.read(notificationServiceProvider);

    // Check general notification permission
    final hasNotifications = await notificationService.areNotificationsEnabled();

    // Check exact alarm permission (Android only)
    bool hasExactAlarm = true;
    if (Platform.isAndroid) {
      hasExactAlarm = await notificationService.canScheduleExactAlarms();
    }

    if (mounted) {
      setState(() {
        _hasNotificationPermission = hasNotifications;
        _hasExactAlarmPermission = hasExactAlarm;
      });
    }
  }

  Future<void> _checkExactAlarmPermission() async {
    if (!Platform.isAndroid) return;

    final notificationService = ref.read(notificationServiceProvider);
    final hasPermission = await notificationService.canScheduleExactAlarms();
    if (mounted) {
      setState(() {
        _hasExactAlarmPermission = hasPermission;
      });
    }
  }

  Future<void> _requestNotificationPermission() async {
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.requestNotificationPermission();

    // Check again after user returns from settings
    await Future.delayed(const Duration(milliseconds: 500));
    await _checkNotificationPermissions();

    // If permission was granted, show success message
    if (_hasNotificationPermission && mounted) {
      showGOLToast(
        context,
        'Notification permission granted!',
        variant: GOLToastVariant.success,
      );
    }
  }

  Future<void> _requestExactAlarmPermission() async {
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.requestExactAlarmPermission();

    // Check again after user returns from settings
    await Future.delayed(const Duration(milliseconds: 500));
    await _checkExactAlarmPermission();

    // If permission was granted, reschedule notifications
    if (_hasExactAlarmPermission && mounted) {
      final settings = ref.read(settingsProvider);
      await notificationService.hydrateFromSettings(settings);
      showGOLToast(
        context,
        'Permission granted! Notifications rescheduled.',
        variant: GOLToastVariant.success,
      );
    }
  }

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
                name:
                    user?.userMetadata?['full_name'] as String? ??
                    user?.email?.split('@').first ??
                    l10n.defaultUserName,
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
                  final languageValue = value == l10n.languageFrench
                      ? 'French'
                      : 'English';
                  await ref
                      .read(settingsProvider.notifier)
                      .setLanguage(languageValue);
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

              // Notification permission warning (if disabled)
              if (!_hasNotificationPermission) ...[
                _NotificationPermissionCard(
                  onRequestPermission: _requestNotificationPermission,
                ),
                const SizedBox(height: GOLSpacing.space3),
              ],

              // Exact alarm permission warning (Android only)
              if (Platform.isAndroid && !_hasExactAlarmPermission) ...[
                _ExactAlarmPermissionCard(
                  onRequestPermission: _requestExactAlarmPermission,
                ),
                const SizedBox(height: GOLSpacing.space3),
              ],

              // Daily reminder with inline time picker
              _DailyReminderTile(
                isEnabled: settings.dailyReminderEnabled,
                reminderTime: settings.dailyReminderTime,
                onEnabledChanged: (value) async {
                  await ref
                      .read(settingsProvider.notifier)
                      .setDailyReminderEnabled(value);
                  if (!mounted) return;

                  // Re-read settings to get current state after async update
                  final currentSettings = ref.read(settingsProvider);

                  // Schedule or cancel the daily reminder
                  final notificationService = ref.read(
                    notificationServiceProvider,
                  );
                  if (value) {
                    await notificationService.scheduleDailyReminder(
                      time: currentSettings.dailyReminderTime,
                    );
                  } else {
                    await notificationService.cancelDailyReminder();
                  }

                  showGOLToast(
                    context,
                    value
                        ? l10n.dailyReminderEnabled
                        : l10n.dailyReminderDisabled,
                    variant: GOLToastVariant.success,
                  );
                },
                onTimeChanged: (time) async {
                  await ref
                      .read(settingsProvider.notifier)
                      .setDailyReminderTime(time);
                  if (!mounted) return;

                  // Re-read settings to get current state after async update
                  final currentSettings = ref.read(settingsProvider);

                  // Reschedule the daily reminder with new time
                  if (currentSettings.dailyReminderEnabled) {
                    final notificationService = ref.read(
                      notificationServiceProvider,
                    );
                    await notificationService.scheduleDailyReminder(time: time);
                  }

                  showGOLToast(
                    context,
                    l10n.reminderTimeUpdated,
                    variant: GOLToastVariant.success,
                  );
                },
              ),

              const SizedBox(height: GOLSpacing.space3),

              // Weekly summary
              _ToggleTile(
                icon: Iconsax.chart,
                title: l10n.weeklySummary,
                subtitle: l10n.weeklySummaryDescription,
                value: settings.weeklySummaryEnabled,
                onChanged: (value) async {
                  await ref
                      .read(settingsProvider.notifier)
                      .setWeeklySummaryEnabled(value);
                  if (!mounted) return;

                  // Schedule or cancel the weekly summary
                  final notificationService = ref.read(
                    notificationServiceProvider,
                  );
                  if (value) {
                    await notificationService.scheduleWeeklySummary(
                      time: const TimeOfDay(hour: 18, minute: 0), // Sunday 6 PM
                    );
                  } else {
                    await notificationService.cancelWeeklySummary();
                  }

                  showGOLToast(
                    context,
                    value
                        ? l10n.weeklySummaryEnabled
                        : l10n.weeklySummaryDisabled,
                    variant: GOLToastVariant.success,
                  );
                },
              ),

              const SizedBox(height: GOLSpacing.space6),

              // DATA & STORAGE SECTION
              _SectionHeader(title: l10n.dataAndStorage),
              const SizedBox(height: GOLSpacing.space3),

              _SyncStatusCard(
                pendingCount: pendingSyncCount.when(
                  data: (count) => count,
                  loading: () => 0,
                  error: (e, s) => 0,
                ),
                l10n: l10n,
                onSync: () => _handleSync(),
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
                  showGOLToast(
                    context,
                    l10n.comingSoon,
                    variant: GOLToastVariant.info,
                  );
                },
              ),

              const SizedBox(height: GOLSpacing.space3),

              _LinkTile(
                icon: Iconsax.document_text,
                title: l10n.termsOfService,
                onTap: () {
                  showGOLToast(
                    context,
                    l10n.comingSoon,
                    variant: GOLToastVariant.info,
                  );
                },
              ),

              const SizedBox(height: GOLSpacing.space7),

              // LOGOUT BUTTON
              SizedBox(
                width: double.infinity,
                child: GOLButton(
                  label: _isLoggingOut ? l10n.loggingOut : l10n.logout,
                  variant: GOLButtonVariant.destructive,
                  onPressed: _isLoggingOut
                      ? null
                      : () => _showLogoutConfirmation(l10n),
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

  ThemeMode _getThemeModeFromLocalizedLabel(
    String label,
    AppLocalizations l10n,
  ) {
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
              style: textTheme.bodySmall?.copyWith(color: colors.textTertiary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GOLSpacing.space3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.tick_circle,
                  size: 14,
                  color: Colors.black,
                ),
                const SizedBox(width: GOLSpacing.space2),
                Text(
                  l10n.logoutDataSaved,
                  style: textTheme.labelSmall?.copyWith(
                    color: Colors.black,
                  ),
                ),
              ],
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

  Future<void> _handleSync() async {
    final l10n = AppLocalizations.of(context)!;
    final isOnline = ref.read(connectivityProvider) == ConnectivityState.online;

    if (!isOnline) {
      showGOLToast(context, l10n.offlineMode, variant: GOLToastVariant.warning);
      return;
    }

    showGOLToast(context, l10n.syncing, variant: GOLToastVariant.info);

    await ref.read(syncProvider.notifier).processPendingSync();

    if (!mounted) return;

    final syncState = ref.read(syncProvider);
    if (syncState.status == SyncStatus.error) {
      showGOLToast(context, l10n.syncFailed, variant: GOLToastVariant.error);
    } else {
      showGOLToast(
        context,
        l10n.allChangesSynced,
        variant: GOLToastVariant.success,
      );
    }
  }

  Future<void> _handleLogout() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoggingOut = true);

    final result = await ref.read(authProvider.notifier).signOut();

    if (!mounted) return;

    if (result.success) {
      context.go(Routes.auth);
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
        ? name
              .split(' ')
              .map((e) => e.isNotEmpty ? e[0] : '')
              .take(2)
              .join()
              .toUpperCase()
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
              color: colors.interactivePrimary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: textTheme.headlineMedium?.copyWith(
                  color: colors.textInverse,
                  fontWeight: FontWeight.w900,
                  fontSize: 36,
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
                border: Border(top: BorderSide(color: colors.borderDefault)),
              ),
              child: Column(
                children: options.map((option) {
                  final isSelected =
                      value == option ||
                      value.startsWith(option.split(' ').first);
                  return InkWell(
                    onTap: () => onOptionSelected(option),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: GOLSpacing.cardPadding,
                        vertical: GOLSpacing.space3,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.interactivePrimary.withValues(alpha: 0.15)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Iconsax.tick_circle5 : Iconsax.record,
                            size: 18,
                            color: isSelected
                                ? colors.interactivePrimary
                                : colors.textTertiary,
                          ),
                          const SizedBox(width: GOLSpacing.space3),
                          Expanded(
                            child: Text(
                              option,
                              style: textTheme.bodyMedium?.copyWith(
                                color: isSelected
                                    ? colors.interactivePrimary
                                    : colors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
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
                    color: isDisabled
                        ? colors.textTertiary
                        : colors.textPrimary,
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
                  isSynced
                      ? l10n.allDataSynced
                      : l10n.itemsPendingSync(pendingCount),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  isSynced ? l10n.syncComplete : l10n.willSyncWhenOnline,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onSync,
            icon: Icon(Iconsax.refresh, color: colors.interactivePrimary),
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
            style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
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
              Icon(Iconsax.arrow_right_3, size: 16, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

/// Notification permission warning card.
/// Shows when the app doesn't have notification permission.
class _NotificationPermissionCard extends StatelessWidget {
  final VoidCallback onRequestPermission;

  const _NotificationPermissionCard({required this.onRequestPermission});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return GOLCard(
      variant: GOLCardVariant.standard,
      padding: const EdgeInsets.all(GOLSpacing.cardPadding),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: colors.stateError, width: 3),
          ),
        ),
        padding: const EdgeInsets.only(left: GOLSpacing.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.notification_bing, size: 20, color: colors.stateError),
                const SizedBox(width: GOLSpacing.space2),
                Expanded(
                  child: Text(
                    'Notification permission required',
                    style: textTheme.titleSmall?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: GOLSpacing.space2),
            Text(
              'Notifications are currently disabled. Please enable them in your device settings to receive reminders.',
              style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: GOLSpacing.space3),
            SizedBox(
              width: double.infinity,
              child: GOLButton(
                label: 'Enable Notifications',
                variant: GOLButtonVariant.secondary,
                size: GOLButtonSize.small,
                onPressed: onRequestPermission,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Exact alarm permission warning card.
/// Shows when the app doesn't have permission to schedule exact alarms.
class _ExactAlarmPermissionCard extends StatelessWidget {
  final VoidCallback onRequestPermission;

  const _ExactAlarmPermissionCard({required this.onRequestPermission});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return GOLCard(
      variant: GOLCardVariant.standard,
      padding: const EdgeInsets.all(GOLSpacing.cardPadding),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: colors.stateWarning, width: 3),
          ),
        ),
        padding: const EdgeInsets.only(left: GOLSpacing.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.warning_2, size: 20, color: colors.stateWarning),
                const SizedBox(width: GOLSpacing.space2),
                Expanded(
                  child: Text(
                    'Alarm permission required',
                    style: textTheme.titleSmall?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: GOLSpacing.space2),
            Text(
              'To receive notifications at exact times (even when the app is closed), please enable "Alarms & reminders" permission.',
              style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
            ),
            const SizedBox(height: GOLSpacing.space3),
            SizedBox(
              width: double.infinity,
              child: GOLButton(
                label: 'Grant Permission',
                variant: GOLButtonVariant.secondary,
                size: GOLButtonSize.small,
                onPressed: onRequestPermission,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Daily reminder tile with inline time picker.
class _DailyReminderTile extends StatelessWidget {
  final bool isEnabled;
  final TimeOfDay reminderTime;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const _DailyReminderTile({
    required this.isEnabled,
    required this.reminderTime,
    required this.onEnabledChanged,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return GOLCard(
      variant: GOLCardVariant.standard,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // Main toggle row
          Padding(
            padding: const EdgeInsets.all(GOLSpacing.cardPadding),
            child: Row(
              children: [
                Icon(Iconsax.clock, size: 20, color: colors.textSecondary),
                const SizedBox(width: GOLSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dailyReminder,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        l10n.dailyReminderDescription,
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: isEnabled,
                  onChanged: onEnabledChanged,
                  activeTrackColor: colors.interactivePrimary,
                ),
              ],
            ),
          ),

          // Time picker (only shown when enabled)
          if (isEnabled) ...[
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: colors.borderDefault)),
              ),
              child: InkWell(
                onTap: () => _showTimePicker(context),
                child: Padding(
                  padding: const EdgeInsets.all(GOLSpacing.cardPadding),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.timer_1,
                        size: 20,
                        color: colors.interactivePrimary,
                      ),
                      const SizedBox(width: GOLSpacing.space3),
                      Expanded(
                        child: Text(
                          l10n.reminderTime,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: GOLSpacing.space3,
                          vertical: GOLSpacing.space2,
                        ),
                        decoration: BoxDecoration(
                          color: colors.interactivePrimary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(GOLRadius.sm),
                        ),
                        child: Text(
                          _formatTime(reminderTime),
                          style: textTheme.labelLarge?.copyWith(
                            color: colors.interactivePrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: GOLSpacing.space2),
                      Icon(
                        Iconsax.arrow_right_3,
                        size: 16,
                        color: colors.textTertiary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final colors = Theme.of(context).extension<GOLSemanticColors>()!;

    final picked = await showTimePicker(
      context: context,
      initialTime: reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: colors.interactivePrimary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onTimeChanged(picked);
    }
  }
}
