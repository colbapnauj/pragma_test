class ApiEndpoints {
  ApiEndpoints._();

  /// Rutas que requieren header x-api-key
  static const List<String> routesRequiringApiKey = [
    // '/breeds',
    // '/breeds/search',
  ];

  static bool requiresApiKey(String path) {
    return routesRequiringApiKey.any((route) => path.contains(route));
  }
}
