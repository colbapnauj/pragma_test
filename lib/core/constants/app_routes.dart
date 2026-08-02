class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String home = '/home';
  static const String breedDetail = '/breed/:id';

  static String breedDetailPath(String id) => '/breed/$id';
}
