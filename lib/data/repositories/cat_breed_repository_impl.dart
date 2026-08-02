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

  @override
  Future<Result<List<CatBreed>>> getBreeds() async {
    try {
      final response = await _dio.get<List<dynamic>>(_breedsPath);

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
}
