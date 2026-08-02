import 'package:flutter/foundation.dart';

import '../core/utils/result.dart';
import '../data/entities/cat_breed.dart';
import '../data/repositories/cat_breed_repository.dart';

class CatBreedDetailViewModel extends ChangeNotifier {
  CatBreedDetailViewModel(this._repository);

  final CatBreedRepository _repository;

  CatBreed? _breed;
  bool _isLoading = false;
  String? _errorMessage;

  CatBreed? get breed => _breed;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadBreed(String breedId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getBreedById(breedId);

    switch (result) {
      case Success(:final data):
        _breed = data;
        _isLoading = false;
        notifyListeners();
      case Failure(:final exception):
        _errorMessage = exception.message;
        _isLoading = false;
        notifyListeners();
    }
  }
}
