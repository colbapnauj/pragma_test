import '../../core/constants/app_config.dart';
import '../../core/utils/app_exception.dart';
import '../../core/utils/result.dart';
import '../datasources/cat_breed_remote_data_source.dart';
import '../entities/cat_breed.dart';
import '../mappers/cat_breed_mapper.dart';
import '../models/cached_data.dart';
import 'cat_breed_repository.dart';

class CatBreedRepositoryImpl implements CatBreedRepository {
  CatBreedRepositoryImpl(this._remoteDataSource) {
    _breedCache = {};
  }

  final CatBreedRemoteDataSource _remoteDataSource;
  late final Map<String, CachedData<CatBreed>> _breedCache;


  @override
  Future<Result<List<CatBreed>>> getBreeds({
    int limit = 10,
    int page = 0,
  }) async {
    try {
      final dtos = await _remoteDataSource.getBreeds(limit: limit, page: page);
      final breeds = dtos
          .map((dto) => CatBreedMapper.fromDto(dto))
          .toList();
      return Success(breeds);
    } on Exception catch (e) {
      return Failure(_handleException(e));
    }
  }

  @override
  Future<Result<CatBreed>> getBreedById(
    String breedId, {
    bool forceRefresh = false,
  }) async {
    try {
      if (!forceRefresh && _breedCache.containsKey(breedId)) {
        final cached = _breedCache[breedId]!;
        if (cached.isValid) {
          return Success(cached.data);
        }
      }

      final dto = await _remoteDataSource.getBreedById(breedId);
      final breed = CatBreedMapper.fromDto(dto);

      _breedCache[breedId] = CachedData(
        data: breed,
        expiresAt: DateTime.now().add(AppConfig.breedDetailCacheDuration),
      );

      return Success(breed);
    } on Exception catch (e) {
      return Failure(_handleException(e));
    }
  }

  @override
  Future<Result<List<CatBreed>>> searchBreeds(String query) async {
    if (query.isEmpty) {
      return const Success([]);
    }

    try {
      final dtos = await _remoteDataSource.searchBreeds(query);
      final breeds = dtos
          .map((dto) => CatBreedMapper.fromDto(dto))
          .toList();
      return Success(breeds);
    } on Exception catch (e) {
      return Failure(_handleException(e));
    }
  }

  AppException _handleException(Exception e) {
    if (e is AppException) {
      return e;
    }
    // TODO: Capturar error y enviarlo a sistema de observabilidad o errores
    return AppException('Algo salió mal. Por favor, intenta de nuevo.');
  }
}
