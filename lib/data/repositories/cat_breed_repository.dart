import '../../core/utils/result.dart';
import '../entities/cat_breed.dart';

abstract class CatBreedRepository {
  Future<Result<List<CatBreed>>> getBreeds({
    int limit = 10,
    int page = 0,
  });

  Future<Result<CatBreed>> getBreedById(String breedId);

  Future<Result<List<CatBreed>>> searchBreeds(String query);
}
