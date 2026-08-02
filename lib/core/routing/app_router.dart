import 'package:go_router/go_router.dart';

import '../../viewmodels/splash_view_model.dart';
import '../../views/cat_breed_detail_view.dart';
import '../../views/cat_breeds_list_view.dart';
import '../../views/splash_view.dart';
import '../constants/app_routes.dart';
import '../di/service_locator.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: getIt<SplashViewModel>(),
    redirect: (context, state) {
      final splashViewModel = getIt<SplashViewModel>();
      if (splashViewModel.isReady && state.matchedLocation == AppRoutes.splash) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const CatBreedsListView(),
        routes: [
          GoRoute(
            path: AppRoutes.breedDetail,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              final name = state.uri.queryParameters['name'];
              final imageUrl = state.uri.queryParameters['imageUrl'];
              return CatBreedDetailView(
                breedId: id,
                breedName: name,
                breedImageUrl: imageUrl,
              );
            },
          ),
        ],
      ),
    ],
  );
}
