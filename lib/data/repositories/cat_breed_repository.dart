import '../../core/utils/result.dart';
import '../entities/cat_breed.dart';

abstract class CatBreedRepository {
  Future<Result<List<CatBreed>>> getBreeds();
}
