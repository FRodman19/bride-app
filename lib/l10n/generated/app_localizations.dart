import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Performance Tracker'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your preferences'**
  String get settingsSubtitle;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get account;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferences;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get notifications;

  /// No description provided for @dataAndStorage.
  ///
  /// In en, this message translates to:
  /// **'DATA & STORAGE'**
  String get dataAndStorage;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get about;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @languageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Language updated to {language}'**
  String languageUpdated(String language);

  /// No description provided for @defaultCurrency.
  ///
  /// In en, this message translates to:
  /// **'Default Currency'**
  String get defaultCurrency;

  /// No description provided for @currencyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Default currency updated'**
  String get currencyUpdated;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get selectCurrency;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @themeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Theme updated'**
  String get themeUpdated;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get dailyReminder;

  /// No description provided for @weeklySummary.
  ///
  /// In en, this message translates to:
  /// **'Weekly Summary'**
  String get weeklySummary;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @allDataSynced.
  ///
  /// In en, this message translates to:
  /// **'All data synced'**
  String get allDataSynced;

  /// No description provided for @lastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced: {time}'**
  String lastSynced(String time);

  /// No description provided for @itemsPendingSync.
  ///
  /// In en, this message translates to:
  /// **'{count} items pending sync'**
  String itemsPendingSync(int count);

  /// No description provided for @willSyncWhenOnline.
  ///
  /// In en, this message translates to:
  /// **'Will sync when online'**
  String get willSyncWhenOnline;

  /// No description provided for @syncComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Sync coming soon'**
  String get syncComingSoon;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @loggingOut.
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get loggingOut;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmMessage;

  /// No description provided for @logoutConfirmSubtext.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to sign in again to access your data.'**
  String get logoutConfirmSubtext;

  /// No description provided for @logoutDataSaved.
  ///
  /// In en, this message translates to:
  /// **'Your data is saved and will sync when you return.'**
  String get logoutDataSaved;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @failedToLogout.
  ///
  /// In en, this message translates to:
  /// **'Failed to logout'**
  String get failedToLogout;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @activeProjectsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active project'**
  String activeProjectsCount(int count);

  /// No description provided for @activeProjectsCountPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} active projects'**
  String activeProjectsCountPlural(int count);

  /// No description provided for @trackYourPerformance.
  ///
  /// In en, this message translates to:
  /// **'Track your project performance'**
  String get trackYourPerformance;

  /// No description provided for @errorLoadingTrackers.
  ///
  /// In en, this message translates to:
  /// **'Error loading trackers'**
  String get errorLoadingTrackers;

  /// No description provided for @recentProject.
  ///
  /// In en, this message translates to:
  /// **'Recent Project'**
  String get recentProject;

  /// No description provided for @topPerformers.
  ///
  /// In en, this message translates to:
  /// **'Top Performers'**
  String get topPerformers;

  /// No description provided for @needsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs Attention'**
  String get needsAttention;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @manageAllProjects.
  ///
  /// In en, this message translates to:
  /// **'Manage all your projects'**
  String get manageAllProjects;

  /// No description provided for @errorLoadingProjects.
  ///
  /// In en, this message translates to:
  /// **'Error loading projects'**
  String get errorLoadingProjects;

  /// No description provided for @activeProjects.
  ///
  /// In en, this message translates to:
  /// **'Active Projects'**
  String get activeProjects;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @activeArchivedCount.
  ///
  /// In en, this message translates to:
  /// **'{active} active, {archived} archived'**
  String activeArchivedCount(int active, int archived);

  /// No description provided for @newProject.
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get newProject;

  /// No description provided for @createProject.
  ///
  /// In en, this message translates to:
  /// **'Create Project'**
  String get createProject;

  /// No description provided for @createFirstProject.
  ///
  /// In en, this message translates to:
  /// **'Create First Project'**
  String get createFirstProject;

  /// No description provided for @projectCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Project created successfully'**
  String get projectCreatedSuccess;

  /// No description provided for @projectName.
  ///
  /// In en, this message translates to:
  /// **'Project Name'**
  String get projectName;

  /// No description provided for @projectNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Summer Campaign 2024'**
  String get projectNameHint;

  /// No description provided for @enterProjectName.
  ///
  /// In en, this message translates to:
  /// **'Enter project name'**
  String get enterProjectName;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @selectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Select start date'**
  String get selectStartDate;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @platforms.
  ///
  /// In en, this message translates to:
  /// **'Platforms'**
  String get platforms;

  /// No description provided for @selectPlatforms.
  ///
  /// In en, this message translates to:
  /// **'Select platforms'**
  String get selectPlatforms;

  /// No description provided for @revenueTarget.
  ///
  /// In en, this message translates to:
  /// **'Revenue Target'**
  String get revenueTarget;

  /// No description provided for @revenueTargetOptional.
  ///
  /// In en, this message translates to:
  /// **'Revenue Target (Optional)'**
  String get revenueTargetOptional;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @engagementTarget.
  ///
  /// In en, this message translates to:
  /// **'Engagement Target'**
  String get engagementTarget;

  /// No description provided for @engagementTargetOptional.
  ///
  /// In en, this message translates to:
  /// **'Engagement Target (Optional)'**
  String get engagementTargetOptional;

  /// No description provided for @engagementTargetHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 100 DMs/Leads'**
  String get engagementTargetHint;

  /// No description provided for @setupCost.
  ///
  /// In en, this message translates to:
  /// **'Setup Cost'**
  String get setupCost;

  /// No description provided for @setupCostHelper.
  ///
  /// In en, this message translates to:
  /// **'One-time cost to set up this project (ads, tools, etc.)'**
  String get setupCostHelper;

  /// No description provided for @monthlyGrowthCost.
  ///
  /// In en, this message translates to:
  /// **'Monthly Growth Cost'**
  String get monthlyGrowthCost;

  /// No description provided for @monthlyGrowthCostHelper.
  ///
  /// In en, this message translates to:
  /// **'Recurring monthly expenses (subscriptions, ads budget, etc.)'**
  String get monthlyGrowthCostHelper;

  /// No description provided for @goalsOptional.
  ///
  /// In en, this message translates to:
  /// **'Goals (Optional)'**
  String get goalsOptional;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesOptional;

  /// No description provided for @addNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Add any notes about this project...'**
  String get addNotesOptional;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @anyNotesAboutToday.
  ///
  /// In en, this message translates to:
  /// **'Any notes about today...'**
  String get anyNotesAboutToday;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @projectLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Project Limit Reached'**
  String get projectLimitReached;

  /// No description provided for @projectLimitMessage.
  ///
  /// In en, this message translates to:
  /// **'You have 20 active projects. Archive some to create new ones.'**
  String get projectLimitMessage;

  /// No description provided for @pleaseSelectPlatform.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one platform'**
  String get pleaseSelectPlatform;

  /// No description provided for @archiveProject.
  ///
  /// In en, this message translates to:
  /// **'Archive Project'**
  String get archiveProject;

  /// No description provided for @restoreProject.
  ///
  /// In en, this message translates to:
  /// **'Restore Project'**
  String get restoreProject;

  /// No description provided for @moveToArchive.
  ///
  /// In en, this message translates to:
  /// **'Move to archive (read-only)'**
  String get moveToArchive;

  /// No description provided for @moveToActive.
  ///
  /// In en, this message translates to:
  /// **'Move back to active projects'**
  String get moveToActive;

  /// No description provided for @deleteProject.
  ///
  /// In en, this message translates to:
  /// **'Delete Project'**
  String get deleteProject;

  /// No description provided for @deleteProjectPermanently.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete this project'**
  String get deleteProjectPermanently;

  /// No description provided for @deleteProjectConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Project?'**
  String get deleteProjectConfirmTitle;

  /// No description provided for @deleteProjectConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete \"{name}\" and all its entries. This action cannot be undone.'**
  String deleteProjectConfirmMessage(String name);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @projectRestored.
  ///
  /// In en, this message translates to:
  /// **'Project restored'**
  String get projectRestored;

  /// No description provided for @trackerRestored.
  ///
  /// In en, this message translates to:
  /// **'{name} restored'**
  String trackerRestored(String name);

  /// No description provided for @projectArchived.
  ///
  /// In en, this message translates to:
  /// **'Project archived'**
  String get projectArchived;

  /// No description provided for @projectDeleted.
  ///
  /// In en, this message translates to:
  /// **'Project deleted'**
  String get projectDeleted;

  /// No description provided for @trackerDeleted.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String trackerDeleted(String name);

  /// No description provided for @failedToRestoreProject.
  ///
  /// In en, this message translates to:
  /// **'Failed to restore project'**
  String get failedToRestoreProject;

  /// No description provided for @failedToRestoreTracker.
  ///
  /// In en, this message translates to:
  /// **'Failed to restore tracker'**
  String get failedToRestoreTracker;

  /// No description provided for @failedToArchiveProject.
  ///
  /// In en, this message translates to:
  /// **'Failed to archive project'**
  String get failedToArchiveProject;

  /// No description provided for @failedToDeleteProject.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete project'**
  String get failedToDeleteProject;

  /// No description provided for @failedToDeleteTracker.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete tracker'**
  String get failedToDeleteTracker;

  /// No description provided for @archivedTrackers.
  ///
  /// In en, this message translates to:
  /// **'Archived Trackers'**
  String get archivedTrackers;

  /// No description provided for @noArchivedTrackers.
  ///
  /// In en, this message translates to:
  /// **'No Archived Trackers'**
  String get noArchivedTrackers;

  /// No description provided for @archivedTrackersDescription.
  ///
  /// In en, this message translates to:
  /// **'Archived trackers are campaigns you\'ve completed or paused.'**
  String get archivedTrackersDescription;

  /// No description provided for @archivingATracker.
  ///
  /// In en, this message translates to:
  /// **'Archiving a tracker:'**
  String get archivingATracker;

  /// No description provided for @removesFromDashboard.
  ///
  /// In en, this message translates to:
  /// **'Removes it from active dashboard'**
  String get removesFromDashboard;

  /// No description provided for @preservesAllData.
  ///
  /// In en, this message translates to:
  /// **'Preserves all data'**
  String get preservesAllData;

  /// No description provided for @canBeRestoredAnytime.
  ///
  /// In en, this message translates to:
  /// **'Can be restored anytime'**
  String get canBeRestoredAnytime;

  /// No description provided for @keepsHistoricalRecords.
  ///
  /// In en, this message translates to:
  /// **'Keeps historical records'**
  String get keepsHistoricalRecords;

  /// No description provided for @toArchiveTracker.
  ///
  /// In en, this message translates to:
  /// **'To archive a tracker:\nOpen tracker > Menu > Archive'**
  String get toArchiveTracker;

  /// No description provided for @archivedTrackersPreserved.
  ///
  /// In en, this message translates to:
  /// **'These trackers are archived but preserved for reference. You can restore or permanently delete them.'**
  String get archivedTrackersPreserved;

  /// No description provided for @archivedTrackersCount.
  ///
  /// In en, this message translates to:
  /// **'ARCHIVED TRACKERS ({count})'**
  String archivedTrackersCount(int count);

  /// No description provided for @archivedTrackersNote.
  ///
  /// In en, this message translates to:
  /// **'Archived trackers don\'t count toward active performance metrics'**
  String get archivedTrackersNote;

  /// No description provided for @finalProfit.
  ///
  /// In en, this message translates to:
  /// **'Final Profit:'**
  String get finalProfit;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @deleteTrackerTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Tracker?'**
  String get deleteTrackerTitle;

  /// No description provided for @deleteTrackerMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete the tracker and all associated data including:'**
  String get deleteTrackerMessage;

  /// No description provided for @allDailyEntries.
  ///
  /// In en, this message translates to:
  /// **'All daily entries'**
  String get allDailyEntries;

  /// No description provided for @allPosts.
  ///
  /// In en, this message translates to:
  /// **'All posts'**
  String get allPosts;

  /// No description provided for @allReportsData.
  ///
  /// In en, this message translates to:
  /// **'All reports and analytics data'**
  String get allReportsData;

  /// No description provided for @actionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get actionCannotBeUndone;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysCount(int count);

  /// No description provided for @weeksCount.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{week} other{weeks}}'**
  String weeksCount(int count);

  /// No description provided for @monthsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{month} other{months}}'**
  String monthsCount(int count);

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue tracking your performance'**
  String get signInToContinue;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @createPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a password (min 6 characters)'**
  String get createPasswordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @joinToStartTracking.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your campaign performance'**
  String get joinToStartTracking;

  /// No description provided for @almostThereCheckEmail.
  ///
  /// In en, this message translates to:
  /// **'Almost there! Check your email to confirm.'**
  String get almostThereCheckEmail;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkYourEmail;

  /// No description provided for @emailConfirmationSent.
  ///
  /// In en, this message translates to:
  /// **'We sent a confirmation link to {email}'**
  String emailConfirmationSent(String email);

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @reEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reEnterPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @resetPasswordInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a reset link'**
  String get resetPasswordInstructions;

  /// No description provided for @checkEmailForResetLink.
  ///
  /// In en, this message translates to:
  /// **'Check your email for a password reset link'**
  String get checkEmailForResetLink;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent to {email}'**
  String passwordResetEmailSent(String email);

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @logEntry.
  ///
  /// In en, this message translates to:
  /// **'Log Entry'**
  String get logEntry;

  /// No description provided for @editEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit Entry'**
  String get editEntry;

  /// No description provided for @entryDetail.
  ///
  /// In en, this message translates to:
  /// **'Entry Detail'**
  String get entryDetail;

  /// No description provided for @entryHistory.
  ///
  /// In en, this message translates to:
  /// **'Entry History'**
  String get entryHistory;

  /// No description provided for @trackerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Tracker not found'**
  String get trackerNotFound;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get todayLabel;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @howMuchEarnToday.
  ///
  /// In en, this message translates to:
  /// **'How much did you earn today?'**
  String get howMuchEarnToday;

  /// No description provided for @enterRevenue.
  ///
  /// In en, this message translates to:
  /// **'Enter revenue'**
  String get enterRevenue;

  /// No description provided for @adSpend.
  ///
  /// In en, this message translates to:
  /// **'AD SPEND'**
  String get adSpend;

  /// No description provided for @todaySpend.
  ///
  /// In en, this message translates to:
  /// **'Today: {amount}'**
  String todaySpend(String amount);

  /// No description provided for @enterSpendPerPlatform.
  ///
  /// In en, this message translates to:
  /// **'Enter how much you spent on each platform today'**
  String get enterSpendPerPlatform;

  /// No description provided for @platformSpend.
  ///
  /// In en, this message translates to:
  /// **'Platform Spend'**
  String get platformSpend;

  /// No description provided for @addPlatformSpend.
  ///
  /// In en, this message translates to:
  /// **'Add Platform Spend'**
  String get addPlatformSpend;

  /// No description provided for @dmsLeads.
  ///
  /// In en, this message translates to:
  /// **'DMs/Leads'**
  String get dmsLeads;

  /// No description provided for @dmsLeadsOptional.
  ///
  /// In en, this message translates to:
  /// **'DMS / LEADS (Optional)'**
  String get dmsLeadsOptional;

  /// No description provided for @inboundOnly.
  ///
  /// In en, this message translates to:
  /// **'Inbound only'**
  String get inboundOnly;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'SUMMARY'**
  String get summary;

  /// No description provided for @profit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get profit;

  /// No description provided for @profitLoss.
  ///
  /// In en, this message translates to:
  /// **'Profit/Loss'**
  String get profitLoss;

  /// No description provided for @totalProfit.
  ///
  /// In en, this message translates to:
  /// **'Total Profit'**
  String get totalProfit;

  /// No description provided for @totalSpend.
  ///
  /// In en, this message translates to:
  /// **'Total Spend'**
  String get totalSpend;

  /// No description provided for @spend.
  ///
  /// In en, this message translates to:
  /// **'Spend'**
  String get spend;

  /// No description provided for @saveEntry.
  ///
  /// In en, this message translates to:
  /// **'Save Entry'**
  String get saveEntry;

  /// No description provided for @entryLoggedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Entry logged successfully'**
  String get entryLoggedSuccess;

  /// No description provided for @entrySaved.
  ///
  /// In en, this message translates to:
  /// **'Entry saved successfully'**
  String get entrySaved;

  /// No description provided for @entryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Entry updated successfully'**
  String get entryUpdated;

  /// No description provided for @entryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Entry deleted successfully'**
  String get entryDeleted;

  /// No description provided for @deleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete Entry'**
  String get deleteEntry;

  /// No description provided for @deleteEntryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this entry?'**
  String get deleteEntryConfirm;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @dailyEntries.
  ///
  /// In en, this message translates to:
  /// **'Daily Entries'**
  String get dailyEntries;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @entries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get entries;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @noEntriesYet.
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get noEntriesYet;

  /// No description provided for @noEntriesYetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log your first daily entry to start tracking revenue and spend'**
  String get noEntriesYetSubtitle;

  /// No description provided for @startLoggingEntries.
  ///
  /// In en, this message translates to:
  /// **'Start logging your daily performance'**
  String get startLoggingEntries;

  /// No description provided for @logFirstEntry.
  ///
  /// In en, this message translates to:
  /// **'Log First Entry'**
  String get logFirstEntry;

  /// No description provided for @noPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get noPostsYet;

  /// No description provided for @noPostsYetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add posts to track your content across platforms'**
  String get noPostsYetSubtitle;

  /// No description provided for @addPost.
  ///
  /// In en, this message translates to:
  /// **'Add Post'**
  String get addPost;

  /// No description provided for @noArchivedProjects.
  ///
  /// In en, this message translates to:
  /// **'No archived projects'**
  String get noArchivedProjects;

  /// No description provided for @archivedProjectsAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Projects you archive will appear here'**
  String get archivedProjectsAppearHere;

  /// No description provided for @noEntriesFound.
  ///
  /// In en, this message translates to:
  /// **'No entries found'**
  String get noEntriesFound;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or date range'**
  String get tryAdjustingFilters;

  /// No description provided for @netProfit.
  ///
  /// In en, this message translates to:
  /// **'NET PROFIT'**
  String get netProfit;

  /// No description provided for @roi.
  ///
  /// In en, this message translates to:
  /// **'ROI'**
  String get roi;

  /// No description provided for @nothingYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing yet'**
  String get nothingYet;

  /// No description provided for @startFirstProject.
  ///
  /// In en, this message translates to:
  /// **'Start your first project and track your progress'**
  String get startFirstProject;

  /// No description provided for @startNewProject.
  ///
  /// In en, this message translates to:
  /// **'Start New Project'**
  String get startNewProject;

  /// No description provided for @whatYouCanTrack.
  ///
  /// In en, this message translates to:
  /// **'What you can track:'**
  String get whatYouCanTrack;

  /// No description provided for @trackRevenueSpending.
  ///
  /// In en, this message translates to:
  /// **'Track revenue & spending'**
  String get trackRevenueSpending;

  /// No description provided for @monitorGrowthMetrics.
  ///
  /// In en, this message translates to:
  /// **'Monitor growth metrics'**
  String get monitorGrowthMetrics;

  /// No description provided for @logPostsContent.
  ///
  /// In en, this message translates to:
  /// **'Log posts & content'**
  String get logPostsContent;

  /// No description provided for @seePerformanceTrends.
  ///
  /// In en, this message translates to:
  /// **'See performance trends'**
  String get seePerformanceTrends;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @designSystemGallery.
  ///
  /// In en, this message translates to:
  /// **'Design System Gallery'**
  String get designSystemGallery;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @productLaunch.
  ///
  /// In en, this message translates to:
  /// **'Product Launch'**
  String get productLaunch;

  /// No description provided for @leadGeneration.
  ///
  /// In en, this message translates to:
  /// **'Lead Generation'**
  String get leadGeneration;

  /// No description provided for @brandAwareness.
  ///
  /// In en, this message translates to:
  /// **'Brand Awareness'**
  String get brandAwareness;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @engagement.
  ///
  /// In en, this message translates to:
  /// **'Engagement'**
  String get engagement;

  /// No description provided for @projectNotFound.
  ///
  /// In en, this message translates to:
  /// **'Project not found'**
  String get projectNotFound;

  /// No description provided for @startedOn.
  ///
  /// In en, this message translates to:
  /// **'Started {date}'**
  String startedOn(String date);

  /// No description provided for @editProject.
  ///
  /// In en, this message translates to:
  /// **'Edit Project'**
  String get editProject;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @nameRestored.
  ///
  /// In en, this message translates to:
  /// **'{name} restored'**
  String nameRestored(String name);

  /// No description provided for @failedToRestore.
  ///
  /// In en, this message translates to:
  /// **'Failed to restore'**
  String get failedToRestore;

  /// No description provided for @nameArchived.
  ///
  /// In en, this message translates to:
  /// **'{name} archived'**
  String nameArchived(String name);

  /// No description provided for @failedToArchive.
  ///
  /// In en, this message translates to:
  /// **'Failed to archive'**
  String get failedToArchive;

  /// No description provided for @failedToDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete'**
  String get failedToDelete;

  /// No description provided for @recentEntries.
  ///
  /// In en, this message translates to:
  /// **'Recent Entries'**
  String get recentEntries;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noEntriesYetShort.
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get noEntriesYetShort;

  /// No description provided for @logFirstEntryToStart.
  ///
  /// In en, this message translates to:
  /// **'Log your first daily entry to start tracking'**
  String get logFirstEntryToStart;

  /// No description provided for @moreEntriesInTab.
  ///
  /// In en, this message translates to:
  /// **'{count} more entries - View in Entries tab'**
  String moreEntriesInTab(int count);

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @targets.
  ///
  /// In en, this message translates to:
  /// **'Targets'**
  String get targets;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target: {value}'**
  String target(String value);

  /// No description provided for @netLoss.
  ///
  /// In en, this message translates to:
  /// **'Net loss'**
  String get netLoss;

  /// No description provided for @daysActive.
  ///
  /// In en, this message translates to:
  /// **'Days Active'**
  String get daysActive;

  /// No description provided for @sinceStart.
  ///
  /// In en, this message translates to:
  /// **'since start'**
  String get sinceStart;

  /// No description provided for @logged.
  ///
  /// In en, this message translates to:
  /// **'Logged'**
  String get logged;

  /// No description provided for @monthlyCost.
  ///
  /// In en, this message translates to:
  /// **'Monthly Cost'**
  String get monthlyCost;

  /// No description provided for @failedToLoadEntries.
  ///
  /// In en, this message translates to:
  /// **'Failed to load entries'**
  String get failedToLoadEntries;

  /// No description provided for @noEntriesYetTitle.
  ///
  /// In en, this message translates to:
  /// **'No Entries Yet'**
  String get noEntriesYetTitle;

  /// No description provided for @dailyEntriesDescription.
  ///
  /// In en, this message translates to:
  /// **'Daily entries track your campaign performance day by day.'**
  String get dailyEntriesDescription;

  /// No description provided for @eachEntryLogs.
  ///
  /// In en, this message translates to:
  /// **'Each entry logs:'**
  String get eachEntryLogs;

  /// No description provided for @totalRevenueForDay.
  ///
  /// In en, this message translates to:
  /// **'Total revenue for the day'**
  String get totalRevenueForDay;

  /// No description provided for @adSpendPerPlatform.
  ///
  /// In en, this message translates to:
  /// **'Ad spend per platform'**
  String get adSpendPerPlatform;

  /// No description provided for @dmsLeadsReceived.
  ///
  /// In en, this message translates to:
  /// **'DMs/Leads received'**
  String get dmsLeadsReceived;

  /// No description provided for @dailyProfitCalculated.
  ///
  /// In en, this message translates to:
  /// **'Daily profit (calculated)'**
  String get dailyProfitCalculated;

  /// No description provided for @startTrackingToSee.
  ///
  /// In en, this message translates to:
  /// **'Start tracking to see trends, ROI, and burn rate.'**
  String get startTrackingToSee;

  /// No description provided for @summaryFilter.
  ///
  /// In en, this message translates to:
  /// **'SUMMARY ({filter})'**
  String summaryFilter(String filter);

  /// No description provided for @totalEntries.
  ///
  /// In en, this message translates to:
  /// **'Total Entries'**
  String get totalEntries;

  /// No description provided for @avgDailyProfit.
  ///
  /// In en, this message translates to:
  /// **'Avg Daily Profit'**
  String get avgDailyProfit;

  /// No description provided for @totalDmsLeads.
  ///
  /// In en, this message translates to:
  /// **'Total DMs/Leads'**
  String get totalDmsLeads;

  /// No description provided for @bestDay.
  ///
  /// In en, this message translates to:
  /// **'Best Day'**
  String get bestDay;

  /// No description provided for @worstDay.
  ///
  /// In en, this message translates to:
  /// **'Worst Day'**
  String get worstDay;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @noEntriesForFilter.
  ///
  /// In en, this message translates to:
  /// **'No entries for {filter}'**
  String noEntriesForFilter(String filter);

  /// No description provided for @todaySection.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get todaySection;

  /// No description provided for @yesterdaySection.
  ///
  /// In en, this message translates to:
  /// **'YESTERDAY'**
  String get yesterdaySection;

  /// No description provided for @thisWeekSection.
  ///
  /// In en, this message translates to:
  /// **'THIS WEEK'**
  String get thisWeekSection;

  /// No description provided for @lastWeekSection.
  ///
  /// In en, this message translates to:
  /// **'LAST WEEK'**
  String get lastWeekSection;

  /// No description provided for @thisMonthSection.
  ///
  /// In en, this message translates to:
  /// **'THIS MONTH'**
  String get thisMonthSection;

  /// No description provided for @loss.
  ///
  /// In en, this message translates to:
  /// **'loss'**
  String get loss;

  /// No description provided for @rev.
  ///
  /// In en, this message translates to:
  /// **'Rev: {amount}'**
  String rev(String amount);

  /// No description provided for @spendAmount.
  ///
  /// In en, this message translates to:
  /// **'Spend: {amount}'**
  String spendAmount(String amount);

  /// No description provided for @dms.
  ///
  /// In en, this message translates to:
  /// **'DMs'**
  String get dms;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @quickExport.
  ///
  /// In en, this message translates to:
  /// **'Quick Export'**
  String get quickExport;

  /// No description provided for @csv.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get csv;

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @exportAllData.
  ///
  /// In en, this message translates to:
  /// **'Export all data as spreadsheet'**
  String get exportAllData;

  /// No description provided for @exportFormattedReport.
  ///
  /// In en, this message translates to:
  /// **'Export formatted report'**
  String get exportFormattedReport;

  /// No description provided for @exportedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Exported successfully'**
  String get exportedSuccess;

  /// No description provided for @failedToExport.
  ///
  /// In en, this message translates to:
  /// **'Failed to export'**
  String get failedToExport;

  /// No description provided for @comingSoonExport.
  ///
  /// In en, this message translates to:
  /// **'Export coming soon'**
  String get comingSoonExport;

  /// No description provided for @keyInsights.
  ///
  /// In en, this message translates to:
  /// **'Key Insights'**
  String get keyInsights;

  /// No description provided for @projectPerformance.
  ///
  /// In en, this message translates to:
  /// **'Project Performance'**
  String get projectPerformance;

  /// No description provided for @profitableProject.
  ///
  /// In en, this message translates to:
  /// **'Profitable project!'**
  String get profitableProject;

  /// No description provided for @needsOptimization.
  ///
  /// In en, this message translates to:
  /// **'Needs optimization'**
  String get needsOptimization;

  /// No description provided for @avgProfitMargin.
  ///
  /// In en, this message translates to:
  /// **'Avg profit margin'**
  String get avgProfitMargin;

  /// No description provided for @spendAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Spend Analysis'**
  String get spendAnalysis;

  /// No description provided for @totalAdSpend.
  ///
  /// In en, this message translates to:
  /// **'Total ad spend across platforms'**
  String get totalAdSpend;

  /// No description provided for @avgDailySpend.
  ///
  /// In en, this message translates to:
  /// **'Avg daily spend: {amount}'**
  String avgDailySpend(String amount);

  /// No description provided for @engagementStats.
  ///
  /// In en, this message translates to:
  /// **'Engagement Stats'**
  String get engagementStats;

  /// No description provided for @totalLeadsReceived.
  ///
  /// In en, this message translates to:
  /// **'Total leads/DMs received'**
  String get totalLeadsReceived;

  /// No description provided for @avgPerDay.
  ///
  /// In en, this message translates to:
  /// **'Avg {count}/day'**
  String avgPerDay(String count);

  /// No description provided for @needMoreData.
  ///
  /// In en, this message translates to:
  /// **'Need more data'**
  String get needMoreData;

  /// No description provided for @logMoreEntries.
  ///
  /// In en, this message translates to:
  /// **'Log more entries to see insights'**
  String get logMoreEntries;

  /// No description provided for @noPostsSection.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get noPostsSection;

  /// No description provided for @addYourFirstPost.
  ///
  /// In en, this message translates to:
  /// **'Add your first post to track content'**
  String get addYourFirstPost;

  /// No description provided for @performanceOverview.
  ///
  /// In en, this message translates to:
  /// **'PERFORMANCE OVERVIEW'**
  String get performanceOverview;

  /// No description provided for @activeCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active'**
  String activeCount(int count);

  /// No description provided for @entryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{entry} other{entries}}'**
  String entryCount(int count);

  /// No description provided for @entrySingular.
  ///
  /// In en, this message translates to:
  /// **'entry'**
  String get entrySingular;

  /// No description provided for @entriesPlural.
  ///
  /// In en, this message translates to:
  /// **'entries'**
  String get entriesPlural;

  /// No description provided for @dailyReport.
  ///
  /// In en, this message translates to:
  /// **'Daily Report ({date})'**
  String dailyReport(String date);

  /// No description provided for @weeklyReport.
  ///
  /// In en, this message translates to:
  /// **'Weekly Report ({start} - {end})'**
  String weeklyReport(String start, String end);

  /// No description provided for @monthlyReport.
  ///
  /// In en, this message translates to:
  /// **'Monthly Report ({month})'**
  String monthlyReport(String month);

  /// No description provided for @noDataYet.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get noDataYet;

  /// No description provided for @logFirstEntryForReports.
  ///
  /// In en, this message translates to:
  /// **'Log your first entry to see reports'**
  String get logFirstEntryForReports;

  /// No description provided for @totalProfitLoss.
  ///
  /// In en, this message translates to:
  /// **'TOTAL PROFIT/LOSS'**
  String get totalProfitLoss;

  /// No description provided for @totalRevenueLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenueLabel;

  /// No description provided for @totalSpendLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Spend'**
  String get totalSpendLabel;

  /// No description provided for @setupCosts.
  ///
  /// In en, this message translates to:
  /// **'Setup Costs'**
  String get setupCosts;

  /// No description provided for @finalProfitLabel.
  ///
  /// In en, this message translates to:
  /// **'Final Profit'**
  String get finalProfitLabel;

  /// No description provided for @revenueVsSpendOverTime.
  ///
  /// In en, this message translates to:
  /// **'REVENUE VS SPEND OVER TIME'**
  String get revenueVsSpendOverTime;

  /// No description provided for @revenueLabel.
  ///
  /// In en, this message translates to:
  /// **'Revenue: {amount}'**
  String revenueLabel(String amount);

  /// No description provided for @spendLabel.
  ///
  /// In en, this message translates to:
  /// **'Spend: {amount}'**
  String spendLabel(String amount);

  /// No description provided for @worstPerformingDays.
  ///
  /// In en, this message translates to:
  /// **'WORST PERFORMING DAYS'**
  String get worstPerformingDays;

  /// No description provided for @burnRate.
  ///
  /// In en, this message translates to:
  /// **'BURN RATE'**
  String get burnRate;

  /// No description provided for @dailyBurnRate.
  ///
  /// In en, this message translates to:
  /// **'Daily Burn Rate'**
  String get dailyBurnRate;

  /// No description provided for @projectedMonthlyBurn.
  ///
  /// In en, this message translates to:
  /// **'Projected Monthly Burn'**
  String get projectedMonthlyBurn;

  /// No description provided for @daysUntilBudgetDepleted.
  ///
  /// In en, this message translates to:
  /// **'Days until budget depleted'**
  String get daysUntilBudgetDepleted;

  /// No description provided for @cumulativeProfit.
  ///
  /// In en, this message translates to:
  /// **'CUMULATIVE PROFIT'**
  String get cumulativeProfit;

  /// No description provided for @exportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get exportReport;

  /// No description provided for @adding.
  ///
  /// In en, this message translates to:
  /// **'Adding...'**
  String get adding;

  /// No description provided for @adjustFiltersOrSearch.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search'**
  String get adjustFiltersOrSearch;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @allEntries.
  ///
  /// In en, this message translates to:
  /// **'All Entries'**
  String get allEntries;

  /// No description provided for @averageDailySpend.
  ///
  /// In en, this message translates to:
  /// **'Average Daily Spend'**
  String get averageDailySpend;

  /// No description provided for @averageMonthlySpend.
  ///
  /// In en, this message translates to:
  /// **'Average Monthly Spend'**
  String get averageMonthlySpend;

  /// No description provided for @averageWeeklySpend.
  ///
  /// In en, this message translates to:
  /// **'Average Weekly Spend'**
  String get averageWeeklySpend;

  /// No description provided for @avgDaily.
  ///
  /// In en, this message translates to:
  /// **'Avg Daily'**
  String get avgDaily;

  /// No description provided for @breakEvenLabel.
  ///
  /// In en, this message translates to:
  /// **'Break-even: {date} (day {day})'**
  String breakEvenLabel(String date, int day);

  /// No description provided for @breakdown.
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get breakdown;

  /// No description provided for @burnRateDescription.
  ///
  /// In en, this message translates to:
  /// **'How fast you\'re spending money'**
  String get burnRateDescription;

  /// No description provided for @burnRateProjection.
  ///
  /// In en, this message translates to:
  /// **'At this rate, you\'ll spend {amount} per year on ads'**
  String burnRateProjection(String amount);

  /// No description provided for @calculation.
  ///
  /// In en, this message translates to:
  /// **'Calculation'**
  String get calculation;

  /// No description provided for @completeHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} - Complete History'**
  String completeHistoryTitle(String name);

  /// No description provided for @completeTimeline.
  ///
  /// In en, this message translates to:
  /// **'Complete timeline'**
  String get completeTimeline;

  /// No description provided for @createdOn.
  ///
  /// In en, this message translates to:
  /// **'Created: {date}'**
  String createdOn(String date);

  /// No description provided for @cumulativeProfitTrend.
  ///
  /// In en, this message translates to:
  /// **'CUMULATIVE PROFIT TREND'**
  String get cumulativeProfitTrend;

  /// No description provided for @currentPace.
  ///
  /// In en, this message translates to:
  /// **'Current Pace:'**
  String get currentPace;

  /// No description provided for @dailyEarningQuestion.
  ///
  /// In en, this message translates to:
  /// **'How much did you earn this day?'**
  String get dailyEarningQuestion;

  /// No description provided for @dailyLoss.
  ///
  /// In en, this message translates to:
  /// **'Daily Loss'**
  String get dailyLoss;

  /// No description provided for @dailyProfit.
  ///
  /// In en, this message translates to:
  /// **'Daily Profit'**
  String get dailyProfit;

  /// No description provided for @dailyReportLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily Report ({date})'**
  String dailyReportLabel(String date);

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @dateLocked.
  ///
  /// In en, this message translates to:
  /// **'Date cannot be changed when editing'**
  String get dateLocked;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// No description provided for @defaultUserEmail.
  ///
  /// In en, this message translates to:
  /// **'utilisateur@example.com'**
  String get defaultUserEmail;

  /// No description provided for @defaultUserInitial.
  ///
  /// In en, this message translates to:
  /// **'U'**
  String get defaultUserInitial;

  /// No description provided for @defaultUserName.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get defaultUserName;

  /// No description provided for @deletePost.
  ///
  /// In en, this message translates to:
  /// **'Delete Post'**
  String get deletePost;

  /// No description provided for @deletePostQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Post?'**
  String get deletePostQuestion;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// No description provided for @designSystemGalleryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Design System Gallery'**
  String get designSystemGalleryTooltip;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editPost.
  ///
  /// In en, this message translates to:
  /// **'Edit Post'**
  String get editPost;

  /// No description provided for @engagementMetrics.
  ///
  /// In en, this message translates to:
  /// **'Engagement metrics'**
  String get engagementMetrics;

  /// No description provided for @entriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{entry} other{entries}}'**
  String entriesCount(int count);

  /// No description provided for @entriesNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Entries not loaded'**
  String get entriesNotLoaded;

  /// No description provided for @entryDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Entry deleted successfully'**
  String get entryDeletedSuccessfully;

  /// No description provided for @entryHistoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Entry history shows all your daily performance logs in one place.'**
  String get entryHistoryDescription;

  /// No description provided for @entryHistoryHighlightsTitle.
  ///
  /// In en, this message translates to:
  /// **'As you log entries, you\'ll see:'**
  String get entryHistoryHighlightsTitle;

  /// No description provided for @entryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Entry not found'**
  String get entryNotFound;

  /// No description provided for @entryUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Entry updated successfully'**
  String get entryUpdatedSuccessfully;

  /// No description provided for @exporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get exporting;

  /// No description provided for @failedToAddPost.
  ///
  /// In en, this message translates to:
  /// **'Failed to add post'**
  String get failedToAddPost;

  /// No description provided for @failedToDeleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete entry'**
  String get failedToDeleteEntry;

  /// No description provided for @failedToDeletePost.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete post'**
  String get failedToDeletePost;

  /// No description provided for @failedToUpdatePost.
  ///
  /// In en, this message translates to:
  /// **'Failed to update post'**
  String get failedToUpdatePost;

  /// No description provided for @fromAllChannelsCombined.
  ///
  /// In en, this message translates to:
  /// **'From all channels combined'**
  String get fromAllChannelsCombined;

  /// No description provided for @goalBrandAwareness.
  ///
  /// In en, this message translates to:
  /// **'Brand Awareness'**
  String get goalBrandAwareness;

  /// No description provided for @goalEngagement.
  ///
  /// In en, this message translates to:
  /// **'Engagement'**
  String get goalEngagement;

  /// No description provided for @goalLeadGeneration.
  ///
  /// In en, this message translates to:
  /// **'Lead Generation'**
  String get goalLeadGeneration;

  /// No description provided for @goalProductLaunch.
  ///
  /// In en, this message translates to:
  /// **'Product Launch'**
  String get goalProductLaunch;

  /// No description provided for @goalSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get goalSales;

  /// No description provided for @lastEdited.
  ///
  /// In en, this message translates to:
  /// **'Last edited'**
  String get lastEdited;

  /// No description provided for @lastEditedLabel.
  ///
  /// In en, this message translates to:
  /// **'Last edited'**
  String get lastEditedLabel;

  /// No description provided for @lastEditedOn.
  ///
  /// In en, this message translates to:
  /// **'Last edited: {date} at {time}'**
  String lastEditedOn(String date, String time);

  /// No description provided for @loggedOn.
  ///
  /// In en, this message translates to:
  /// **'Logged: {date} at {time}'**
  String loggedOn(String date, String time);

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'message'**
  String get message;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'messages'**
  String get messages;

  /// No description provided for @messagesReceivedQuestion.
  ///
  /// In en, this message translates to:
  /// **'How many messages or leads did you receive?'**
  String get messagesReceivedQuestion;

  /// No description provided for @metadata.
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get metadata;

  /// No description provided for @monthlyReportLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly Report ({monthYear})'**
  String monthlyReportLabel(String monthYear);

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @noAdSpendRecorded.
  ///
  /// In en, this message translates to:
  /// **'No ad spend recorded'**
  String get noAdSpendRecorded;

  /// No description provided for @noEntriesFor.
  ///
  /// In en, this message translates to:
  /// **'No entries for'**
  String get noEntriesFor;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @platformLabel.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platformLabel;

  /// No description provided for @platformRequired.
  ///
  /// In en, this message translates to:
  /// **'Platform *'**
  String get platformRequired;

  /// No description provided for @postAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Post added successfully'**
  String get postAddedSuccessfully;

  /// No description provided for @postContentPrompt.
  ///
  /// In en, this message translates to:
  /// **'What content did you publish?'**
  String get postContentPrompt;

  /// No description provided for @postDeleted.
  ///
  /// In en, this message translates to:
  /// **'Post deleted'**
  String get postDeleted;

  /// No description provided for @postDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Post caption or summary...'**
  String get postDescriptionHint;

  /// No description provided for @postInfo.
  ///
  /// In en, this message translates to:
  /// **'Post Info'**
  String get postInfo;

  /// No description provided for @postLinkOptional.
  ///
  /// In en, this message translates to:
  /// **'Post Link (Optional)'**
  String get postLinkOptional;

  /// No description provided for @postTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Launch Announcement'**
  String get postTitleHint;

  /// No description provided for @postTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Post Title *'**
  String get postTitleRequired;

  /// No description provided for @postTitleValidation.
  ///
  /// In en, this message translates to:
  /// **'Title must be at least 3 characters'**
  String get postTitleValidation;

  /// No description provided for @postUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Post updated successfully'**
  String get postUpdatedSuccessfully;

  /// No description provided for @postedOn.
  ///
  /// In en, this message translates to:
  /// **'Posted: {date}'**
  String postedOn(String date);

  /// No description provided for @postsDoNotAffectMetrics.
  ///
  /// In en, this message translates to:
  /// **'Note: Posts don\'t affect revenue or profit calculations.'**
  String get postsDoNotAffectMetrics;

  /// No description provided for @postsOptionalDescription.
  ///
  /// In en, this message translates to:
  /// **'Posts are optional reference links to track what content you published.'**
  String get postsOptionalDescription;

  /// No description provided for @potentialLeads.
  ///
  /// In en, this message translates to:
  /// **'Potential leads'**
  String get potentialLeads;

  /// No description provided for @profitLossSummary.
  ///
  /// In en, this message translates to:
  /// **'PROFIT/LOSS SUMMARY'**
  String get profitLossSummary;

  /// No description provided for @profitTrends.
  ///
  /// In en, this message translates to:
  /// **'Profit trends'**
  String get profitTrends;

  /// No description provided for @publishDate.
  ///
  /// In en, this message translates to:
  /// **'Publish Date'**
  String get publishDate;

  /// No description provided for @recoveredSetupCosts.
  ///
  /// In en, this message translates to:
  /// **'Recovered setup costs on {date}'**
  String recoveredSetupCosts(String date);

  /// No description provided for @revenuePatterns.
  ///
  /// In en, this message translates to:
  /// **'Revenue patterns'**
  String get revenuePatterns;

  /// No description provided for @roiEarningsDescription.
  ///
  /// In en, this message translates to:
  /// **'For every 1 {currency} spent, you earn {multiplier} in revenue'**
  String roiEarningsDescription(String currency, String multiplier);

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @searchByDateHint.
  ///
  /// In en, this message translates to:
  /// **'Search by date...'**
  String get searchByDateHint;

  /// No description provided for @selectDateOptional.
  ///
  /// In en, this message translates to:
  /// **'Select date (optional)'**
  String get selectDateOptional;

  /// No description provided for @startLoggingHistory.
  ///
  /// In en, this message translates to:
  /// **'Start logging to build your performance history!'**
  String get startLoggingHistory;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @totalReceived.
  ///
  /// In en, this message translates to:
  /// **'Total Received'**
  String get totalReceived;

  /// No description provided for @viewAllPosts.
  ///
  /// In en, this message translates to:
  /// **'View all {count} posts'**
  String viewAllPosts(int count);

  /// No description provided for @weeklyReportRange.
  ///
  /// In en, this message translates to:
  /// **'Weekly Report ({start} - {end})'**
  String weeklyReportRange(String start, String end);

  /// No description provided for @projectsHeading.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projectsHeading;

  /// No description provided for @projectStartedOn.
  ///
  /// In en, this message translates to:
  /// **'Started {date}'**
  String projectStartedOn(String date);

  /// No description provided for @projectUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Project updated successfully'**
  String get projectUpdatedSuccess;

  /// No description provided for @startDateCannotBeChanged.
  ///
  /// In en, this message translates to:
  /// **'Start date cannot be changed after creation'**
  String get startDateCannotBeChanged;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'DANGER ZONE'**
  String get dangerZone;

  /// No description provided for @thisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get thisActionCannotBeUndone;

  /// No description provided for @whatWillBeDeleted.
  ///
  /// In en, this message translates to:
  /// **'What will be deleted:'**
  String get whatWillBeDeleted;

  /// No description provided for @allEntriesCount.
  ///
  /// In en, this message translates to:
  /// **'All {count} entries'**
  String allEntriesCount(int count);

  /// No description provided for @completeHistory.
  ///
  /// In en, this message translates to:
  /// **'Complete project history'**
  String get completeHistory;

  /// No description provided for @typeProjectNameToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type \"{name}\" to confirm deletion'**
  String typeProjectNameToConfirm(String name);

  /// No description provided for @projectDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Project deleted successfully'**
  String get projectDeletedSuccess;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @errorOccurredTryAgain.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorOccurredTryAgain;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// No description provided for @checkInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get checkInternetConnection;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline'**
  String get offlineMode;

  /// No description provided for @offlineWithPending.
  ///
  /// In en, this message translates to:
  /// **'Offline - {count} changes pending'**
  String offlineWithPending(int count);

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing;

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed - tap for details'**
  String get syncFailed;

  /// No description provided for @pendingChanges.
  ///
  /// In en, this message translates to:
  /// **'{count} changes waiting to sync'**
  String pendingChanges(int count);

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @neverSynced.
  ///
  /// In en, this message translates to:
  /// **'Never synced'**
  String get neverSynced;

  /// No description provided for @syncComplete.
  ///
  /// In en, this message translates to:
  /// **'Sync complete'**
  String get syncComplete;

  /// No description provided for @allChangesSynced.
  ///
  /// In en, this message translates to:
  /// **'All changes synced successfully'**
  String get allChangesSynced;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
