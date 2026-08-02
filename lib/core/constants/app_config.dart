class AppConfig {
  AppConfig._();

  // Cache
  static const Duration breedDetailCacheDuration = Duration(hours: 1);

  // Timing
  static const Duration splashDisplayDuration = Duration(seconds: 2);
  static const Duration searchDebounceDelay = Duration(milliseconds: 800);

  // UI
  static const double breedDetailImageHeightRatio = 0.5;
  static const double paginationThreshold = 500;
  static const int pageSize = 10;

  // Spacing
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double cardMarginBottom = 16.0;
}
