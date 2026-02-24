// ABOUTME: Central place for app route path constants. Used by GoRouter and widgets to avoid hardcoded paths.
// ABOUTME: Home and dataset detail routes; dataset detail uses path parameter :id.

/// Route path constants for the app. Use these instead of hardcoded strings.
abstract final class AppRoutes {
  AppRoutes._();

  static const String home = '/';

  /// About the app (bottom nav "O Aplikaciji").
  static const String about = '/about';

  /// Path pattern for dataset detail (use with GoRoute). Path param: :id.
  static const String datasetDetail = '/dataset/:id';

  /// Builds the dataset detail path for a given [id].
  static String datasetDetailPath(String id) => '/dataset/$id';
}
