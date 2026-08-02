import 'package:flutter/foundation.dart';

import '../data/repositories/cat_breed_repository.dart';

class CatBreedsListViewModel extends ChangeNotifier {
  CatBreedsListViewModel(this._repository);

  final CatBreedRepository _repository;

  // TODO: exponer estado (loading/data/error) y método para cargar breeds.
}
