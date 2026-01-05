// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Suivi de Performance';

  @override
  String get settings => 'Paramètres';

  @override
  String get settingsSubtitle => 'Gérez vos préférences';

  @override
  String get account => 'COMPTE';

  @override
  String get preferences => 'PRÉFÉRENCES';

  @override
  String get notifications => 'NOTIFICATIONS';

  @override
  String get dataAndStorage => 'DONNÉES & STOCKAGE';

  @override
  String get about => 'À PROPOS';

  @override
  String get language => 'Langue';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageFrench => 'Français';

  @override
  String languageUpdated(String language) {
    return 'Langue mise à jour: $language';
  }

  @override
  String get defaultCurrency => 'Devise par défaut';

  @override
  String get currencyUpdated => 'Devise par défaut mise à jour';

  @override
  String get selectCurrency => 'Sélectionner la devise';

  @override
  String get theme => 'Thème';

  @override
  String get themeLight => 'Mode Clair';

  @override
  String get themeDark => 'Mode Sombre';

  @override
  String get themeSystem => 'Système par défaut';

  @override
  String get themeUpdated => 'Thème mis à jour';

  @override
  String get pushNotifications => 'Notifications Push';

  @override
  String get dailyReminder => 'Rappel Quotidien';

  @override
  String get weeklySummary => 'Résumé Hebdomadaire';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get allDataSynced => 'Toutes les données synchronisées';

  @override
  String get lastSynced => 'Dernière synchro: À l\'instant';

  @override
  String itemsPendingSync(int count) {
    return '$count éléments en attente';
  }

  @override
  String get willSyncWhenOnline => 'Synchro quand en ligne';

  @override
  String get syncComingSoon => 'Synchro bientôt disponible';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get logout => 'Déconnexion';

  @override
  String get loggingOut => 'Déconnexion...';

  @override
  String get logoutConfirmTitle => 'Déconnexion';

  @override
  String get logoutConfirmMessage => 'Voulez-vous vraiment vous déconnecter?';

  @override
  String get logoutConfirmSubtext =>
      'Vous devrez vous reconnecter pour accéder à vos données.';

  @override
  String get logoutDataSaved =>
      'Vos données sont sauvegardées et se synchroniseront à votre retour.';

  @override
  String get cancel => 'Annuler';

  @override
  String get failedToLogout => 'Échec de la déconnexion';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get performance => 'Performance';

  @override
  String activeProjectsCount(int count) {
    return '$count projet actif';
  }

  @override
  String activeProjectsCountPlural(int count) {
    return '$count projets actifs';
  }

  @override
  String get trackYourPerformance => 'Suivez la performance de vos projets';

  @override
  String get errorLoadingTrackers => 'Erreur de chargement des projets';

  @override
  String get recentProject => 'Projet Récent';

  @override
  String get topPerformers => 'Meilleures Performances';

  @override
  String get needsAttention => 'Nécessite Attention';

  @override
  String get projects => 'Projets';

  @override
  String get project => 'Projet';

  @override
  String get manageAllProjects => 'Gérez tous vos projets';

  @override
  String get errorLoadingProjects => 'Erreur de chargement des projets';

  @override
  String get activeProjects => 'Projets Actifs';

  @override
  String get archived => 'Archivés';

  @override
  String get active => 'Actif';

  @override
  String activeArchivedCount(int active, int archived) {
    return '$active actifs, $archived archivés';
  }

  @override
  String get newProject => 'Nouveau Projet';

  @override
  String get createProject => 'Créer le Projet';

  @override
  String get createFirstProject => 'Créer Premier Projet';

  @override
  String get projectCreatedSuccess => 'Projet créé avec succès';

  @override
  String get projectName => 'Nom du Projet';

  @override
  String get projectNameHint => 'ex: Campagne Été 2024';

  @override
  String get enterProjectName => 'Entrez le nom du projet';

  @override
  String get startDate => 'Date de Début';

  @override
  String get selectStartDate => 'Sélectionnez la date de début';

  @override
  String get currency => 'Devise';

  @override
  String get platforms => 'Plateformes';

  @override
  String get selectPlatforms => 'Sélectionnez les plateformes';

  @override
  String get revenueTarget => 'Objectif de Revenu';

  @override
  String get revenueTargetOptional => 'Objectif de Revenu (Optionnel)';

  @override
  String get optional => 'Optionnel';

  @override
  String get engagementTarget => 'Objectif d\'Engagement';

  @override
  String get engagementTargetOptional => 'Objectif d\'Engagement (Optionnel)';

  @override
  String get engagementTargetHint => 'ex: 100 DMs/Prospects';

  @override
  String get setupCost => 'Coût d\'Installation';

  @override
  String get setupCostHelper =>
      'Coût unique pour configurer ce projet (pubs, outils, etc.)';

  @override
  String get monthlyGrowthCost => 'Coût de Croissance Mensuel';

  @override
  String get monthlyGrowthCostHelper =>
      'Dépenses mensuelles récurrentes (abonnements, budget pubs, etc.)';

  @override
  String get goalsOptional => 'Objectifs (Optionnel)';

  @override
  String get notesOptional => 'Notes (Optionnel)';

  @override
  String get addNotesOptional => 'Ajoutez des notes sur ce projet...';

  @override
  String get notes => 'Notes';

  @override
  String get anyNotesAboutToday => 'Des notes sur aujourd\'hui...';

  @override
  String get save => 'Enregistrer';

  @override
  String get saving => 'Enregistrement...';

  @override
  String get create => 'Créer';

  @override
  String get goBack => 'Retour';

  @override
  String get projectLimitReached => 'Limite de Projets Atteinte';

  @override
  String get projectLimitMessage =>
      'Vous avez 20 projets actifs. Archivez-en pour en créer de nouveaux.';

  @override
  String get pleaseSelectPlatform =>
      'Veuillez sélectionner au moins une plateforme';

  @override
  String get archiveProject => 'Archiver le Projet';

  @override
  String get restoreProject => 'Restaurer le Projet';

  @override
  String get moveToArchive => 'Déplacer vers les archives (lecture seule)';

  @override
  String get moveToActive => 'Remettre dans les projets actifs';

  @override
  String get deleteProject => 'Supprimer le Projet';

  @override
  String get deleteProjectPermanently => 'Supprimer définitivement ce projet';

  @override
  String get deleteProjectConfirmTitle => 'Supprimer le Projet?';

  @override
  String deleteProjectConfirmMessage(String name) {
    return 'Ceci supprimera définitivement \"$name\" et toutes ses entrées. Cette action est irréversible.';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get restore => 'Restaurer';

  @override
  String get projectRestored => 'Projet restauré';

  @override
  String trackerRestored(String name) {
    return '$name restauré';
  }

  @override
  String get projectArchived => 'Projet archivé';

  @override
  String get projectDeleted => 'Projet supprimé';

  @override
  String trackerDeleted(String name) {
    return '$name supprimé';
  }

  @override
  String get failedToRestoreProject => 'Échec de la restauration du projet';

  @override
  String get failedToRestoreTracker => 'Échec de la restauration';

  @override
  String get failedToArchiveProject => 'Échec de l\'archivage du projet';

  @override
  String get failedToDeleteProject => 'Échec de la suppression du projet';

  @override
  String get failedToDeleteTracker => 'Échec de la suppression';

  @override
  String get archivedTrackers => 'Projets Archivés';

  @override
  String get noArchivedTrackers => 'Aucun Projet Archivé';

  @override
  String get archivedTrackersDescription =>
      'Les projets archivés sont des campagnes terminées ou en pause.';

  @override
  String get archivingATracker => 'Archiver un projet:';

  @override
  String get removesFromDashboard => 'Le retire du tableau de bord actif';

  @override
  String get preservesAllData => 'Préserve toutes les données';

  @override
  String get canBeRestoredAnytime => 'Peut être restauré à tout moment';

  @override
  String get keepsHistoricalRecords => 'Conserve les historiques';

  @override
  String get toArchiveTracker =>
      'Pour archiver un projet:\nOuvrir projet > Menu > Archiver';

  @override
  String get archivedTrackersPreserved =>
      'Ces projets sont archivés mais conservés pour référence. Vous pouvez les restaurer ou les supprimer définitivement.';

  @override
  String archivedTrackersCount(int count) {
    return 'PROJETS ARCHIVÉS ($count)';
  }

  @override
  String get archivedTrackersNote =>
      'Les projets archivés ne comptent pas dans les métriques de performance actives';

  @override
  String get finalProfit => 'Profit Final:';

  @override
  String get duration => 'Durée';

  @override
  String get deleteTrackerTitle => 'Supprimer le Projet?';

  @override
  String get deleteTrackerMessage =>
      'Ceci supprimera définitivement le projet et toutes les données associées incluant:';

  @override
  String get allDailyEntries => 'Toutes les entrées quotidiennes';

  @override
  String get allPosts => 'Tous les posts';

  @override
  String get allReportsData => 'Toutes les données de rapports';

  @override
  String get actionCannotBeUndone => 'Cette action est irréversible.';

  @override
  String daysCount(int count) {
    return '$count jours';
  }

  @override
  String weeksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'semaines',
      one: 'semaine',
    );
    return '$count $_temp0';
  }

  @override
  String monthsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mois',
      one: 'mois',
    );
    return '$count $_temp0';
  }

  @override
  String get signIn => 'Se connecter';

  @override
  String get signInToContinue => 'Connectez-vous pour suivre vos performances';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get email => 'Email';

  @override
  String get enterYourEmail => 'Entrez votre email';

  @override
  String get password => 'Mot de passe';

  @override
  String get enterYourPassword => 'Entrez votre mot de passe';

  @override
  String get createPasswordHint => 'Créez un mot de passe (min 6 caractères)';

  @override
  String get forgotPassword => 'Mot de passe oublié?';

  @override
  String get dontHaveAccount => 'Pas encore de compte? ';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get joinToStartTracking =>
      'Commencez à suivre vos performances de campagne';

  @override
  String get almostThereCheckEmail =>
      'Presque terminé! Vérifiez votre email pour confirmer.';

  @override
  String get checkYourEmail => 'Vérifiez votre email';

  @override
  String emailConfirmationSent(String email) {
    return 'Nous avons envoyé un lien de confirmation à $email';
  }

  @override
  String get fullName => 'Nom Complet';

  @override
  String get enterYourName => 'Entrez votre nom';

  @override
  String get confirmPassword => 'Confirmer le Mot de passe';

  @override
  String get reEnterPassword => 'Ressaisissez votre mot de passe';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte? ';

  @override
  String get backToSignIn => 'Retour à la connexion';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordInstructions =>
      'Entrez votre email et nous vous enverrons un lien de réinitialisation';

  @override
  String get checkEmailForResetLink =>
      'Vérifiez votre email pour le lien de réinitialisation';

  @override
  String passwordResetEmailSent(String email) {
    return 'Email de réinitialisation envoyé à $email';
  }

  @override
  String get sendResetLink => 'Envoyer le Lien';

  @override
  String get logEntry => 'Saisir une Entrée';

  @override
  String get editEntry => 'Modifier l\'Entrée';

  @override
  String get entryDetail => 'Détail de l\'Entrée';

  @override
  String get entryHistory => 'Historique des Entrées';

  @override
  String get trackerNotFound => 'Projet non trouvé';

  @override
  String get date => 'Date';

  @override
  String get todayLabel => 'AUJOURD\'HUI';

  @override
  String get revenue => 'Revenu';

  @override
  String get totalRevenue => 'Revenu Total';

  @override
  String get howMuchEarnToday => 'Combien avez-vous gagné aujourd\'hui?';

  @override
  String get enterRevenue => 'Entrez le revenu';

  @override
  String get adSpend => 'DÉPENSES PUB';

  @override
  String todaySpend(String amount) {
    return 'Aujourd\'hui: $amount';
  }

  @override
  String get enterSpendPerPlatform =>
      'Entrez vos dépenses par plateforme aujourd\'hui';

  @override
  String get platformSpend => 'Dépenses par Plateforme';

  @override
  String get addPlatformSpend => 'Ajouter Dépense Plateforme';

  @override
  String get dmsLeads => 'DMs/Prospects';

  @override
  String get dmsLeadsOptional => 'DMS / PROSPECTS (Optionnel)';

  @override
  String get inboundOnly => 'Entrants uniquement';

  @override
  String get summary => 'RÉSUMÉ';

  @override
  String get profit => 'Profit';

  @override
  String get profitLoss => 'Profit/Perte';

  @override
  String get totalProfit => 'Profit Total';

  @override
  String get totalSpend => 'Dépenses Totales';

  @override
  String get spend => 'Dépenses';

  @override
  String get saveEntry => 'Enregistrer l\'Entrée';

  @override
  String get entryLoggedSuccess => 'Entrée enregistrée avec succès';

  @override
  String get entrySaved => 'Entrée enregistrée avec succès';

  @override
  String get entryUpdated => 'Entrée mise à jour avec succès';

  @override
  String get entryDeleted => 'Entrée supprimée avec succès';

  @override
  String get deleteEntry => 'Supprimer l\'Entrée';

  @override
  String get deleteEntryConfirm =>
      'Voulez-vous vraiment supprimer cette entrée?';

  @override
  String get overview => 'Aperçu';

  @override
  String get dailyEntries => 'Entrées Quotidiennes';

  @override
  String get reports => 'Rapports';

  @override
  String get entries => 'Entrées';

  @override
  String get posts => 'Posts';

  @override
  String get noEntriesYet => 'Aucune entrée';

  @override
  String get noEntriesYetSubtitle =>
      'Enregistrez votre première entrée pour suivre revenus et dépenses';

  @override
  String get startLoggingEntries =>
      'Commencez à enregistrer vos performances quotidiennes';

  @override
  String get logFirstEntry => 'Première Entrée';

  @override
  String get noPostsYet => 'Aucun post';

  @override
  String get noPostsYetSubtitle =>
      'Ajoutez des posts pour suivre votre contenu sur les plateformes';

  @override
  String get addPost => 'Ajouter un Post';

  @override
  String get noArchivedProjects => 'Aucun projet archivé';

  @override
  String get archivedProjectsAppearHere =>
      'Les projets archivés apparaîtront ici';

  @override
  String get noEntriesFound => 'Aucune entrée trouvée';

  @override
  String get tryAdjustingFilters =>
      'Essayez d\'ajuster vos filtres ou la période';

  @override
  String get netProfit => 'PROFIT NET';

  @override
  String get roi => 'ROI';

  @override
  String get nothingYet => 'Rien pour l\'instant';

  @override
  String get startFirstProject =>
      'Commencez votre premier projet et suivez vos progrès';

  @override
  String get startNewProject => 'Nouveau Projet';

  @override
  String get whatYouCanTrack => 'Ce que vous pouvez suivre:';

  @override
  String get trackRevenueSpending => 'Suivre revenus & dépenses';

  @override
  String get monitorGrowthMetrics => 'Surveiller les métriques de croissance';

  @override
  String get logPostsContent => 'Enregistrer posts & contenu';

  @override
  String get seePerformanceTrends => 'Voir les tendances de performance';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get thisWeek => 'Cette Semaine';

  @override
  String get thisMonth => 'Ce Mois';

  @override
  String get allTime => 'Tout le Temps';

  @override
  String get daily => 'Quotidien';

  @override
  String get weekly => 'Hebdomadaire';

  @override
  String get monthly => 'Mensuel';

  @override
  String get designSystemGallery => 'Galerie du Système de Design';

  @override
  String get error => 'Erreur';

  @override
  String get retry => 'Réessayer';

  @override
  String get loading => 'Chargement...';

  @override
  String get noData => 'Aucune donnée';

  @override
  String get success => 'Succès';

  @override
  String get info => 'Info';

  @override
  String get warning => 'Avertissement';

  @override
  String get productLaunch => 'Lancement de Produit';

  @override
  String get leadGeneration => 'Génération de Prospects';

  @override
  String get brandAwareness => 'Notoriété de Marque';

  @override
  String get sales => 'Ventes';

  @override
  String get engagement => 'Engagement';

  @override
  String get projectNotFound => 'Projet non trouvé';

  @override
  String startedOn(String date) {
    return 'Démarré le $date';
  }

  @override
  String get editProject => 'Modifier le Projet';

  @override
  String get exportData => 'Exporter les Données';

  @override
  String nameRestored(String name) {
    return '$name restauré';
  }

  @override
  String get failedToRestore => 'Échec de la restauration';

  @override
  String nameArchived(String name) {
    return '$name archivé';
  }

  @override
  String get failedToArchive => 'Échec de l\'archivage';

  @override
  String get failedToDelete => 'Échec de la suppression';

  @override
  String get recentEntries => 'Entrées Récentes';

  @override
  String get viewAll => 'Voir Tout';

  @override
  String get noEntriesYetShort => 'Aucune entrée';

  @override
  String get logFirstEntryToStart =>
      'Enregistrez votre première entrée pour commencer le suivi';

  @override
  String moreEntriesInTab(int count) {
    return '$count entrées de plus - Voir dans l\'onglet Entrées';
  }

  @override
  String get goals => 'Objectifs';

  @override
  String get targets => 'Cibles';

  @override
  String target(String value) {
    return 'Cible: $value';
  }

  @override
  String get netLoss => 'Perte nette';

  @override
  String get daysActive => 'Jours Actifs';

  @override
  String get sinceStart => 'depuis le début';

  @override
  String get logged => 'enregistrées';

  @override
  String get monthlyCost => 'Coût Mensuel';

  @override
  String get failedToLoadEntries => 'Échec du chargement des entrées';

  @override
  String get noEntriesYetTitle => 'Aucune Entrée';

  @override
  String get dailyEntriesDescription =>
      'Les entrées quotidiennes suivent les performances de votre campagne jour après jour.';

  @override
  String get eachEntryLogs => 'Chaque entrée enregistre:';

  @override
  String get totalRevenueForDay => 'Revenu total du jour';

  @override
  String get adSpendPerPlatform => 'Dépenses pub par plateforme';

  @override
  String get dmsLeadsReceived => 'DMs/Prospects reçus';

  @override
  String get dailyProfitCalculated => 'Profit quotidien (calculé)';

  @override
  String get startTrackingToSee =>
      'Commencez le suivi pour voir les tendances, le ROI et le taux de dépenses.';

  @override
  String summaryFilter(String filter) {
    return 'RÉSUMÉ ($filter)';
  }

  @override
  String get totalEntries => 'Total Entrées';

  @override
  String get avgDailyProfit => 'Profit Quotidien Moy.';

  @override
  String get totalDmsLeads => 'Total DMs/Prospects';

  @override
  String get bestDay => 'Meilleur Jour';

  @override
  String get worstDay => 'Pire Jour';

  @override
  String get history => 'Historique';

  @override
  String noEntriesForFilter(String filter) {
    return 'Aucune entrée pour $filter';
  }

  @override
  String get todaySection => 'AUJOURD\'HUI';

  @override
  String get yesterdaySection => 'HIER';

  @override
  String get thisWeekSection => 'CETTE SEMAINE';

  @override
  String get lastWeekSection => 'SEMAINE DERNIÈRE';

  @override
  String get thisMonthSection => 'CE MOIS';

  @override
  String get loss => 'perte';

  @override
  String rev(String amount) {
    return 'Rev: $amount';
  }

  @override
  String spendAmount(String amount) {
    return 'Dép: $amount';
  }

  @override
  String get dms => 'DMs';

  @override
  String get reportsTitle => 'Rapports';

  @override
  String get quickExport => 'Export Rapide';

  @override
  String get csv => 'CSV';

  @override
  String get pdf => 'PDF';

  @override
  String get exportAllData => 'Exporter toutes les données en tableur';

  @override
  String get exportFormattedReport => 'Exporter un rapport formaté';

  @override
  String get exportedSuccess => 'Exporté avec succès';

  @override
  String get failedToExport => 'Échec de l\'export';

  @override
  String get comingSoonExport => 'Export bientôt disponible';

  @override
  String get keyInsights => 'Insights Clés';

  @override
  String get projectPerformance => 'Performance du Projet';

  @override
  String get profitableProject => 'Projet rentable!';

  @override
  String get needsOptimization => 'Optimisation nécessaire';

  @override
  String get avgProfitMargin => 'Marge bénéficiaire moy.';

  @override
  String get spendAnalysis => 'Analyse des Dépenses';

  @override
  String get totalAdSpend => 'Total des dépenses pub sur les plateformes';

  @override
  String avgDailySpend(String amount) {
    return 'Dépense quotidienne moy.: $amount';
  }

  @override
  String get engagementStats => 'Stats d\'Engagement';

  @override
  String get totalLeadsReceived => 'Total prospects/DMs reçus';

  @override
  String avgPerDay(String count) {
    return 'Moy. $count/jour';
  }

  @override
  String get needMoreData => 'Besoin de plus de données';

  @override
  String get logMoreEntries =>
      'Enregistrez plus d\'entrées pour voir les insights';

  @override
  String get noPostsSection => 'Posts';

  @override
  String get addYourFirstPost =>
      'Ajoutez votre premier post pour suivre le contenu';

  @override
  String get performanceOverview => 'APERÇU DES PERFORMANCES';

  @override
  String activeCount(int count) {
    return '$count actifs';
  }

  @override
  String entryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'entrées',
      one: 'entrée',
    );
    return '$count $_temp0';
  }

  @override
  String get entrySingular => 'entrée';

  @override
  String get entriesPlural => 'entrées';

  @override
  String dailyReport(String date) {
    return 'Rapport Quotidien ($date)';
  }

  @override
  String weeklyReport(String start, String end) {
    return 'Rapport Hebdomadaire ($start - $end)';
  }

  @override
  String monthlyReport(String month) {
    return 'Rapport Mensuel ($month)';
  }

  @override
  String get noDataYet => 'Pas encore de données';

  @override
  String get logFirstEntryForReports =>
      'Enregistrez votre première entrée pour voir les rapports';

  @override
  String get totalProfitLoss => 'PROFIT/PERTE TOTAL';

  @override
  String get totalRevenueLabel => 'Revenu Total';

  @override
  String get totalSpendLabel => 'Dépense Totale';

  @override
  String get setupCosts => 'Coûts d\'Installation';

  @override
  String get finalProfitLabel => 'Profit Final';

  @override
  String get revenueVsSpendOverTime => 'REVENUS VS DÉPENSES AU FIL DU TEMPS';

  @override
  String revenueLabel(String amount) {
    return 'Revenus: $amount';
  }

  @override
  String spendLabel(String amount) {
    return 'Dépenses: $amount';
  }

  @override
  String get worstPerformingDays => 'JOURS LES MOINS PERFORMANTS';

  @override
  String get burnRate => 'TAUX DE CONSOMMATION';

  @override
  String get dailyBurnRate => 'Taux Quotidien';

  @override
  String get projectedMonthlyBurn => 'Projection Mensuelle';

  @override
  String get daysUntilBudgetDepleted => 'Jours avant épuisement du budget';

  @override
  String get cumulativeProfit => 'PROFIT CUMULÉ';

  @override
  String get exportReport => 'Exporter le Rapport';
}
