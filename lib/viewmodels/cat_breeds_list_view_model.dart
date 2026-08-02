import 'package:flutter/foundation.dart';

import '../core/utils/result.dart';
import '../data/entities/cat_breed.dart';
import '../data/repositories/cat_breed_repository.dart';

class CatBreedsListViewModel extends ChangeNotifier {
  CatBreedsListViewModel(this._repository);

  final CatBreedRepository _repository;

  List<CatBreed> _breeds = [];
  bool _isLoading = false;
  String? _errorMessage;
  final int _currentPage = 0;
  final int _pageSize = 10;

  List<CatBreed> get breeds => _breeds;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadBreeds() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.getBreeds(
      limit: _pageSize,
      page: _currentPage,
    );

    switch (result) {
      case Success(:final data):
        _breeds = data;
        _isLoading = false;
        notifyListeners();
      case Failure(:final exception):
        _errorMessage = exception.message;
        _isLoading = false;
        notifyListeners();
    }
  }
}
