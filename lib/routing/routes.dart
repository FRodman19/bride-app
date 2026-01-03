/// Route path constants for the app.
///
/// Use these constants instead of hardcoded strings.
class Routes {
  Routes._();

  // Auth routes
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot-password';

  // Main app routes (with bottom nav)
  static const String dashboard = '/';
  static const String trackers = '/trackers';
  static const String settings = '/settings';

  // Dev/Debug routes (temporary, remove in production)
  static const String designSystemGallery = '/design-system-v3';

  // Tracker routes
  static const String createTracker = '/trackers/create';
  static const String trackerHub = '/trackers/:id';
  static const String editTracker = '/trackers/:id/edit';
  static const String archive = '/archive';

  // Entry routes
  static const String logEntry = '/trackers/:id/entries/log';
  static const String entryDetail = '/trackers/:id/entries/:entryId';
  static const String editEntry = '/trackers/:id/entries/:entryId/edit';
  static const String entryHistory = '/trackers/:id/entries/history';
  static const String bulkEdit = '/trackers/:id/entries/bulk';

  // Posts routes
  static const String posts = '/trackers/:id/posts';
  static const String addPost = '/trackers/:id/posts/add';
  static const String editPost = '/trackers/:id/posts/:postId/edit';

  // Settings routes
  static const String platformManagement = '/settings/platforms';

  // Helper methods to build paths with parameters
  static String trackerHubPath(String trackerId) => '/trackers/$trackerId';
  static String editTrackerPath(String trackerId) => '/trackers/$trackerId/edit';
  static String logEntryPath(String trackerId) => '/trackers/$trackerId/entries/log';
  static String entryDetailPath(String trackerId, String entryId) =>
      '/trackers/$trackerId/entries/$entryId';
  static String editEntryPath(String trackerId, String entryId) =>
      '/trackers/$trackerId/entries/$entryId/edit';
  static String entryHistoryPath(String trackerId) => '/trackers/$trackerId/entries/history';
  static String bulkEditPath(String trackerId) => '/trackers/$trackerId/entries/bulk';
  static String postsPath(String trackerId) => '/trackers/$trackerId/posts';
  static String addPostPath(String trackerId) => '/trackers/$trackerId/posts/add';
  static String editPostPath(String trackerId, String postId) =>
      '/trackers/$trackerId/posts/$postId/edit';
}
