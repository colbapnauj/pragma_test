import 'package:dio/dio.dart';

import '../dtos/cat_breed_dto.dart';

abstract class CatBreedRemoteDataSource {
  Future<List<CatBreedDto>> getBreeds({required int limit, required int page});
  Future<CatBreedDto> getBreedById(String breedId);
  Future<List<CatBreedDto>> searchBreeds(String query);
}

class CatBreedRemoteDataSourceImpl implements CatBreedRemoteDataSource {
  CatBreedRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  static const String _breedsPath = '/breeds';

  @override
  Future<List<CatBreedDto>> getBreeds({required int limit, required int page}) async {
    final response = await _dio.get<List<dynamic>>(
      _breedsPath,
      queryParameters: {
        'limit': limit,
        'page': page,
      },
    );

    final rawList = response.data ?? const [];
    return rawList
        .map((json) => CatBreedDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CatBreedDto> getBreedById(String breedId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_breedsPath/$breedId',
    );

    final json = response.data ?? {};
    return CatBreedDto.fromJson(json);
  }

  @override
  Future<List<CatBreedDto>> searchBreeds(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final response = await _dio.get<List<dynamic>>(
      '$_breedsPath/search',
      queryParameters: {
        'q': query,
      },
    );

    final rawList = response.data ?? const [];
    return rawList
        .map((json) => CatBreedDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
