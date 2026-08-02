class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String home = '/home';
  static const String breedDetail = ':id';

  static String breedDetailPath(String id) => id;
}
