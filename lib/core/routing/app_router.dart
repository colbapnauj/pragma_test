import 'package:go_router/go_router.dart';

import '../../views/cat_breed_detail_view.dart';
import '../../views/cat_breeds_list_view.dart';
import '../../views/splash_view.dart';
import '../constants/app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const CatBreedsListView(),
      ),
      GoRoute(
        path: AppRoutes.breedDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CatBreedDetailView(breedId: id);
        },
      ),
    ],
  );
}
