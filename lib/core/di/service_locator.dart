import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/cat_breed_remote_data_source.dart';
import '../../data/repositories/cat_breed_repository.dart';
import '../../data/repositories/cat_breed_repository_impl.dart';
import '../../viewmodels/splash_view_model.dart';
import '../network/dio_client.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<Dio>(
    () => DioClient.create(apiKey: dotenv.env['CAT_API_KEY']),
  );

  getIt.registerLazySingleton<CatBreedRemoteDataSource>(
    () => CatBreedRemoteDataSourceImpl(getIt<Dio>()),
  );

  getIt.registerLazySingleton<CatBreedRepository>(
    () => CatBreedRepositoryImpl(getIt<CatBreedRemoteDataSource>()),
  );

  getIt.registerSingleton<SplashViewModel>(SplashViewModel());
}
