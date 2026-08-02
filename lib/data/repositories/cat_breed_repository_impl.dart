import 'package:dio/dio.dart';

import '../../core/utils/app_exception.dart';
import '../../core/utils/result.dart';
import '../dtos/cat_breed_dto.dart';
import '../entities/cat_breed.dart';
import '../mappers/cat_breed_mapper.dart';
import 'cat_breed_repository.dart';

class CatBreedRepositoryImpl implements CatBreedRepository {
  const CatBreedRepositoryImpl(this._dio);

  final Dio _dio;

  static const String _breedsPath = '/breeds';
  static const String _breedDetailPath = '/breeds';

  @override
  Future<Result<List<CatBreed>>> getBreeds({
    int limit = 10,
    int page = 0,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        _breedsPath,
        queryParameters: {
          'limit': limit,
          'page': page,
        },
      );

      final rawList = response.data ?? const [];
      final breeds = rawList
          .map((json) => CatBreedMapper.fromDto(
                CatBreedDto.fromJson(json as Map<String, dynamic>),
              ))
          .toList();

      return Success(breeds);
    } on DioException catch (e) {
      return Failure(
        AppException(
          e.message ?? 'Network error while fetching cat breeds',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Failure(AppException(e.toString()));
    }
  }

  @override
  Future<Result<CatBreed>> getBreedById(String breedId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_breedDetailPath/$breedId',
      );

      final json = response.data ?? {};
      final breed = CatBreedMapper.fromDto(
        CatBreedDto.fromJson(json),
      );

      return Success(breed);
    } on DioException catch (e) {
      return Failure(
        AppException(
          e.message ?? 'Network error while fetching cat breed',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Failure(AppException(e.toString()));
    }
  }

  @override
  Future<Result<List<CatBreed>>> searchBreeds(String query) async {
    if (query.isEmpty) {
      return const Success([]);
    }

    try {
      final response = await _dio.get<List<dynamic>>(
        '$_breedsPath/search',
        queryParameters: {
          'q': query,
        },
      );

      final rawList = response.data ?? const [];
      final breeds = rawList
          .map((json) => CatBreedMapper.fromDto(
                CatBreedDto.fromJson(json as Map<String, dynamic>),
              ))
          .toList();

      return Success(breeds);
    } on DioException catch (e) {
      return Failure(
        AppException(
          e.message ?? 'Network error while searching cat breeds',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Failure(AppException(e.toString()));
    }
  }
}
