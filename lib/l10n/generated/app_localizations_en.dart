// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Performance Tracker';

  @override
  String get settings => 'Settings';

  @override
  String get settingsSubtitle => 'Manage your preferences';

  @override
  String get account => 'ACCOUNT';

  @override
  String get preferences => 'PREFERENCES';

  @override
  String get notifications => 'NOTIFICATIONS';

  @override
  String get dataAndStorage => 'DATA & STORAGE';

  @override
  String get about => 'ABOUT';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'French';

  @override
  String languageUpdated(String language) {
    return 'Language updated to $language';
  }

  @override
  String get defaultCurrency => 'Default Currency';

  @override
  String get currencyUpdated => 'Default currency updated';

  @override
  String get selectCurrency => 'Select Currency';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light Mode';

  @override
  String get themeDark => 'Dark Mode';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeUpdated => 'Theme updated';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get dailyReminder => 'Daily Reminder';

  @override
  String get weeklySummary => 'Weekly Summary';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get allDataSynced => 'All data synced';

  @override
  String get lastSynced => 'Last synced: Just now';

  @override
  String itemsPendingSync(int count) {
    return '$count items pending sync';
  }

  @override
  String get willSyncWhenOnline => 'Will sync when online';

  @override
  String get syncComingSoon => 'Sync coming soon';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get logout => 'Logout';

  @override
  String get loggingOut => 'Logging out...';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to logout?';

  @override
  String get logoutConfirmSubtext =>
      'You\'ll need to sign in again to access your data.';

  @override
  String get logoutDataSaved =>
      'Your data is saved and will sync when you return.';

  @override
  String get cancel => 'Cancel';

  @override
  String get failedToLogout => 'Failed to logout';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get performance => 'Performance';

  @override
  String activeProjectsCount(int count) {
    return '$count active project';
  }

  @override
  String activeProjectsCountPlural(int count) {
    return '$count active projects';
  }

  @override
  String get trackYourPerformance => 'Track your project performance';

  @override
  String get errorLoadingTrackers => 'Error loading trackers';

  @override
  String get recentProject => 'Recent Project';

  @override
  String get topPerformers => 'Top Performers';

  @override
  String get needsAttention => 'Needs Attention';

  @override
  String get projects => 'Projects';

  @override
  String get project => 'Project';

  @override
  String get manageAllProjects => 'Manage all your projects';

  @override
  String get errorLoadingProjects => 'Error loading projects';

  @override
  String get activeProjects => 'Active Projects';

  @override
  String get archived => 'Archived';

  @override
  String get active => 'Active';

  @override
  String activeArchivedCount(int active, int archived) {
    return '$active active, $archived archived';
  }

  @override
  String get newProject => 'New Project';

  @override
  String get createProject => 'Create Project';

  @override
  String get createFirstProject => 'Create First Project';

  @override
  String get projectCreatedSuccess => 'Project created successfully';

  @override
  String get projectName => 'Project Name';

  @override
  String get projectNameHint => 'e.g., Summer Campaign 2024';

  @override
  String get enterProjectName => 'Enter project name';

  @override
  String get startDate => 'Start Date';

  @override
  String get selectStartDate => 'Select start date';

  @override
  String get currency => 'Currency';

  @override
  String get platforms => 'Platforms';

  @override
  String get selectPlatforms => 'Select platforms';

  @override
  String get revenueTarget => 'Revenue Target';

  @override
  String get revenueTargetOptional => 'Revenue Target (Optional)';

  @override
  String get optional => 'Optional';

  @override
  String get engagementTarget => 'Engagement Target';

  @override
  String get engagementTargetOptional => 'Engagement Target (Optional)';

  @override
  String get engagementTargetHint => 'e.g., 100 DMs/Leads';

  @override
  String get setupCost => 'Setup Cost';

  @override
  String get setupCostHelper =>
      'One-time cost to set up this project (ads, tools, etc.)';

  @override
  String get monthlyGrowthCost => 'Monthly Growth Cost';

  @override
  String get monthlyGrowthCostHelper =>
      'Recurring monthly expenses (subscriptions, ads budget, etc.)';

  @override
  String get goalsOptional => 'Goals (Optional)';

  @override
  String get notesOptional => 'Notes (Optional)';

  @override
  String get addNotesOptional => 'Add any notes about this project...';

  @override
  String get notes => 'Notes';

  @override
  String get anyNotesAboutToday => 'Any notes about today...';

  @override
  String get save => 'Save';

  @override
  String get saving => 'Saving...';

  @override
  String get create => 'Create';

  @override
  String get goBack => 'Go Back';

  @override
  String get projectLimitReached => 'Project Limit Reached';

  @override
  String get projectLimitMessage =>
      'You have 20 active projects. Archive some to create new ones.';

  @override
  String get pleaseSelectPlatform => 'Please select at least one platform';

  @override
  String get archiveProject => 'Archive Project';

  @override
  String get restoreProject => 'Restore Project';

  @override
  String get moveToArchive => 'Move to archive (read-only)';

  @override
  String get moveToActive => 'Move back to active projects';

  @override
  String get deleteProject => 'Delete Project';

  @override
  String get deleteProjectPermanently => 'Permanently delete this project';

  @override
  String get deleteProjectConfirmTitle => 'Delete Project?';

  @override
  String deleteProjectConfirmMessage(String name) {
    return 'This will permanently delete \"$name\" and all its entries. This action cannot be undone.';
  }

  @override
  String get delete => 'Delete';

  @override
  String get restore => 'Restore';

  @override
  String get projectRestored => 'Project restored';

  @override
  String trackerRestored(String name) {
    return '$name restored';
  }

  @override
  String get projectArchived => 'Project archived';

  @override
  String get projectDeleted => 'Project deleted';

  @override
  String trackerDeleted(String name) {
    return '$name deleted';
  }

  @override
  String get failedToRestoreProject => 'Failed to restore project';

  @override
  String get failedToRestoreTracker => 'Failed to restore tracker';

  @override
  String get failedToArchiveProject => 'Failed to archive project';

  @override
  String get failedToDeleteProject => 'Failed to delete project';

  @override
  String get failedToDeleteTracker => 'Failed to delete tracker';

  @override
  String get archivedTrackers => 'Archived Trackers';

  @override
  String get noArchivedTrackers => 'No Archived Trackers';

  @override
  String get archivedTrackersDescription =>
      'Archived trackers are campaigns you\'ve completed or paused.';

  @override
  String get archivingATracker => 'Archiving a tracker:';

  @override
  String get removesFromDashboard => 'Removes it from active dashboard';

  @override
  String get preservesAllData => 'Preserves all data';

  @override
  String get canBeRestoredAnytime => 'Can be restored anytime';

  @override
  String get keepsHistoricalRecords => 'Keeps historical records';

  @override
  String get toArchiveTracker =>
      'To archive a tracker:\nOpen tracker > Menu > Archive';

  @override
  String get archivedTrackersPreserved =>
      'These trackers are archived but preserved for reference. You can restore or permanently delete them.';

  @override
  String archivedTrackersCount(int count) {
    return 'ARCHIVED TRACKERS ($count)';
  }

  @override
  String get archivedTrackersNote =>
      'Archived trackers don\'t count toward active performance metrics';

  @override
  String get finalProfit => 'Final Profit:';

  @override
  String get duration => 'Duration';

  @override
  String get deleteTrackerTitle => 'Delete Tracker?';

  @override
  String get deleteTrackerMessage =>
      'This will permanently delete the tracker and all associated data including:';

  @override
  String get allDailyEntries => 'All daily entries';

  @override
  String get allPosts => 'All posts';

  @override
  String get allReportsData => 'All reports data';

  @override
  String get actionCannotBeUndone => 'This action cannot be undone.';

  @override
  String daysCount(int count) {
    return '$count days';
  }

  @override
  String weeksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'weeks',
      one: 'week',
    );
    return '$count $_temp0';
  }

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'months',
      one: 'month',
    );
    return '$count $_temp0';
  }

  @override
  String get signIn => 'Sign In';

  @override
  String get signInToContinue =>
      'Sign in to continue tracking your performance';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get email => 'Email';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get createPasswordHint => 'Create a password (min 6 characters)';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create account';

  @override
  String get joinToStartTracking => 'Start tracking your campaign performance';

  @override
  String get almostThereCheckEmail =>
      'Almost there! Check your email to confirm.';

  @override
  String get checkYourEmail => 'Check your email';

  @override
  String emailConfirmationSent(String email) {
    return 'We sent a confirmation link to $email';
  }

  @override
  String get fullName => 'Full Name';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get reEnterPassword => 'Re-enter your password';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get backToSignIn => 'Back to Sign In';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get resetPasswordInstructions =>
      'Enter your email and we\'ll send you a reset link';

  @override
  String get checkEmailForResetLink =>
      'Check your email for a password reset link';

  @override
  String passwordResetEmailSent(String email) {
    return 'Password reset email sent to $email';
  }

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get logEntry => 'Log Entry';

  @override
  String get editEntry => 'Edit Entry';

  @override
  String get entryDetail => 'Entry Detail';

  @override
  String get entryHistory => 'Entry History';

  @override
  String get trackerNotFound => 'Tracker not found';

  @override
  String get date => 'Date';

  @override
  String get todayLabel => 'TODAY';

  @override
  String get revenue => 'Revenue';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get howMuchEarnToday => 'How much did you earn today?';

  @override
  String get enterRevenue => 'Enter revenue';

  @override
  String get adSpend => 'AD SPEND';

  @override
  String todaySpend(String amount) {
    return 'Today: $amount';
  }

  @override
  String get enterSpendPerPlatform =>
      'Enter how much you spent on each platform today';

  @override
  String get platformSpend => 'Platform Spend';

  @override
  String get addPlatformSpend => 'Add Platform Spend';

  @override
  String get dmsLeads => 'DMs/Leads';

  @override
  String get dmsLeadsOptional => 'DMS / LEADS (Optional)';

  @override
  String get inboundOnly => 'Inbound only';

  @override
  String get summary => 'SUMMARY';

  @override
  String get profit => 'Profit';

  @override
  String get profitLoss => 'Profit/Loss';

  @override
  String get totalProfit => 'Total Profit';

  @override
  String get totalSpend => 'Total Spend';

  @override
  String get spend => 'Spend';

  @override
  String get saveEntry => 'Save Entry';

  @override
  String get entryLoggedSuccess => 'Entry logged successfully';

  @override
  String get entrySaved => 'Entry saved successfully';

  @override
  String get entryUpdated => 'Entry updated successfully';

  @override
  String get entryDeleted => 'Entry deleted successfully';

  @override
  String get deleteEntry => 'Delete Entry';

  @override
  String get deleteEntryConfirm =>
      'Are you sure you want to delete this entry?';

  @override
  String get overview => 'Overview';

  @override
  String get dailyEntries => 'Daily Entries';

  @override
  String get reports => 'Reports';

  @override
  String get entries => 'Entries';

  @override
  String get posts => 'Posts';

  @override
  String get noEntriesYet => 'No entries yet';

  @override
  String get noEntriesYetSubtitle =>
      'Log your first daily entry to start tracking revenue and spend';

  @override
  String get startLoggingEntries => 'Start logging your daily performance';

  @override
  String get logFirstEntry => 'Log First Entry';

  @override
  String get noPostsYet => 'No posts yet';

  @override
  String get noPostsYetSubtitle =>
      'Add posts to track your content across platforms';

  @override
  String get addPost => 'Add Post';

  @override
  String get noArchivedProjects => 'No archived projects';

  @override
  String get archivedProjectsAppearHere =>
      'Projects you archive will appear here';

  @override
  String get noEntriesFound => 'No entries found';

  @override
  String get tryAdjustingFilters => 'Try adjusting your filters or date range';

  @override
  String get netProfit => 'NET PROFIT';

  @override
  String get roi => 'ROI';

  @override
  String get nothingYet => 'Nothing yet';

  @override
  String get startFirstProject =>
      'Start your first project and track your progress';

  @override
  String get startNewProject => 'Start New Project';

  @override
  String get whatYouCanTrack => 'What you can track:';

  @override
  String get trackRevenueSpending => 'Track revenue & spending';

  @override
  String get monitorGrowthMetrics => 'Monitor growth metrics';

  @override
  String get logPostsContent => 'Log posts & content';

  @override
  String get seePerformanceTrends => 'See performance trends';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get allTime => 'All Time';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get designSystemGallery => 'Design System Gallery';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No data';

  @override
  String get success => 'Success';

  @override
  String get info => 'Info';

  @override
  String get warning => 'Warning';

  @override
  String get productLaunch => 'Product Launch';

  @override
  String get leadGeneration => 'Lead Generation';

  @override
  String get brandAwareness => 'Brand Awareness';

  @override
  String get sales => 'Sales';

  @override
  String get engagement => 'Engagement';

  @override
  String get projectNotFound => 'Project not found';

  @override
  String startedOn(String date) {
    return 'Started $date';
  }

  @override
  String get editProject => 'Edit Project';

  @override
  String get exportData => 'Export Data';

  @override
  String nameRestored(String name) {
    return '$name restored';
  }

  @override
  String get failedToRestore => 'Failed to restore';

  @override
  String nameArchived(String name) {
    return '$name archived';
  }

  @override
  String get failedToArchive => 'Failed to archive';

  @override
  String get failedToDelete => 'Failed to delete';

  @override
  String get recentEntries => 'Recent Entries';

  @override
  String get viewAll => 'View All';

  @override
  String get noEntriesYetShort => 'No entries yet';

  @override
  String get logFirstEntryToStart =>
      'Log your first daily entry to start tracking';

  @override
  String moreEntriesInTab(int count) {
    return '$count more entries - View in Entries tab';
  }

  @override
  String get goals => 'Goals';

  @override
  String get targets => 'Targets';

  @override
  String target(String value) {
    return 'Target: $value';
  }

  @override
  String get netLoss => 'Net loss';

  @override
  String get daysActive => 'Days Active';

  @override
  String get sinceStart => 'since start';

  @override
  String get logged => 'logged';

  @override
  String get monthlyCost => 'Monthly Cost';

  @override
  String get failedToLoadEntries => 'Failed to load entries';

  @override
  String get noEntriesYetTitle => 'No Entries Yet';

  @override
  String get dailyEntriesDescription =>
      'Daily entries track your campaign performance day by day.';

  @override
  String get eachEntryLogs => 'Each entry logs:';

  @override
  String get totalRevenueForDay => 'Total revenue for the day';

  @override
  String get adSpendPerPlatform => 'Ad spend per platform';

  @override
  String get dmsLeadsReceived => 'DMs/Leads received';

  @override
  String get dailyProfitCalculated => 'Daily profit (calculated)';

  @override
  String get startTrackingToSee =>
      'Start tracking to see trends, ROI, and burn rate.';

  @override
  String summaryFilter(String filter) {
    return 'SUMMARY ($filter)';
  }

  @override
  String get totalEntries => 'Total Entries';

  @override
  String get avgDailyProfit => 'Avg Daily Profit';

  @override
  String get totalDmsLeads => 'Total DMs/Leads';

  @override
  String get bestDay => 'Best Day';

  @override
  String get worstDay => 'Worst Day';

  @override
  String get history => 'History';

  @override
  String noEntriesForFilter(String filter) {
    return 'No entries for $filter';
  }

  @override
  String get todaySection => 'TODAY';

  @override
  String get yesterdaySection => 'YESTERDAY';

  @override
  String get thisWeekSection => 'THIS WEEK';

  @override
  String get lastWeekSection => 'LAST WEEK';

  @override
  String get thisMonthSection => 'THIS MONTH';

  @override
  String get loss => 'loss';

  @override
  String rev(String amount) {
    return 'Rev: $amount';
  }

  @override
  String spendAmount(String amount) {
    return 'Spend: $amount';
  }

  @override
  String get dms => 'DMs';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get quickExport => 'Quick Export';

  @override
  String get csv => 'CSV';

  @override
  String get pdf => 'PDF';

  @override
  String get exportAllData => 'Export all data as spreadsheet';

  @override
  String get exportFormattedReport => 'Export formatted report';

  @override
  String get exportedSuccess => 'Exported successfully';

  @override
  String get failedToExport => 'Failed to export';

  @override
  String get comingSoonExport => 'Export coming soon';

  @override
  String get keyInsights => 'Key Insights';

  @override
  String get projectPerformance => 'Project Performance';

  @override
  String get profitableProject => 'Profitable project!';

  @override
  String get needsOptimization => 'Needs optimization';

  @override
  String get avgProfitMargin => 'Avg profit margin';

  @override
  String get spendAnalysis => 'Spend Analysis';

  @override
  String get totalAdSpend => 'Total ad spend across platforms';

  @override
  String avgDailySpend(String amount) {
    return 'Avg daily spend: $amount';
  }

  @override
  String get engagementStats => 'Engagement Stats';

  @override
  String get totalLeadsReceived => 'Total leads/DMs received';

  @override
  String avgPerDay(String count) {
    return 'Avg $count/day';
  }

  @override
  String get needMoreData => 'Need more data';

  @override
  String get logMoreEntries => 'Log more entries to see insights';

  @override
  String get noPostsSection => 'Posts';

  @override
  String get addYourFirstPost => 'Add your first post to track content';

  @override
  String get performanceOverview => 'PERFORMANCE OVERVIEW';

  @override
  String activeCount(int count) {
    return '$count active';
  }

  @override
  String entryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'entries',
      one: 'entry',
    );
    return '$count $_temp0';
  }

  @override
  String get entrySingular => 'entry';

  @override
  String get entriesPlural => 'entries';

  @override
  String dailyReport(String date) {
    return 'Daily Report ($date)';
  }

  @override
  String weeklyReport(String start, String end) {
    return 'Weekly Report ($start - $end)';
  }

  @override
  String monthlyReport(String month) {
    return 'Monthly Report ($month)';
  }

  @override
  String get noDataYet => 'No data yet';

  @override
  String get logFirstEntryForReports => 'Log your first entry to see reports';

  @override
  String get totalProfitLoss => 'TOTAL PROFIT/LOSS';

  @override
  String get totalRevenueLabel => 'Total Revenue';

  @override
  String get totalSpendLabel => 'Total Spend';

  @override
  String get setupCosts => 'Setup Costs';

  @override
  String get finalProfitLabel => 'Final Profit';

  @override
  String get revenueVsSpendOverTime => 'REVENUE VS SPEND OVER TIME';

  @override
  String revenueLabel(String amount) {
    return 'Revenue: $amount';
  }

  @override
  String spendLabel(String amount) {
    return 'Spend: $amount';
  }

  @override
  String get worstPerformingDays => 'WORST PERFORMING DAYS';

  @override
  String get burnRate => 'BURN RATE';

  @override
  String get dailyBurnRate => 'Daily Burn Rate';

  @override
  String get projectedMonthlyBurn => 'Projected Monthly Burn';

  @override
  String get daysUntilBudgetDepleted => 'Days until budget depleted';

  @override
  String get cumulativeProfit => 'CUMULATIVE PROFIT';

  @override
  String get exportReport => 'Export Report';
}
