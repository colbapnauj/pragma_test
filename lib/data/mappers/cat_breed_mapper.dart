import '../dtos/cat_breed_dto.dart';
import '../entities/cat_breed.dart';

class CatBreedMapper {
  CatBreedMapper._();

  static CatBreed fromDto(CatBreedDto dto) {
    return CatBreed(
      id: dto.id,
      name: dto.name,
    );
  }
}
