import 'package:flutter/foundation.dart';

import '../core/utils/result.dart';
import '../data/entities/cat_breed.dart';
import '../data/repositories/cat_breed_repository.dart';

class CatBreedsListViewModel extends ChangeNotifier {
  CatBreedsListViewModel(this._repository);

  final CatBreedRepository _repository;

  List<CatBreed> _breeds = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMoreData = true;

  List<CatBreed> get breeds => _breeds;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  bool get hasMoreData => _hasMoreData;

  Future<void> loadBreeds() async {
    _isLoading = true;
    _isLoadingMore = false;
    _errorMessage = null;
    _currentPage = 0;
    _breeds = [];
    notifyListeners();

    final result = await _repository.getBreeds(
      limit: _pageSize,
      page: _currentPage,
    );

    switch (result) {
      case Success(:final data):
        _breeds = data;
        _hasMoreData = data.length >= _pageSize;
        _isLoading = false;
        notifyListeners();
      case Failure(:final exception):
        _errorMessage = exception.message;
        _isLoading = false;
        _hasMoreData = false;
        notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    notifyListeners();

    _currentPage++;
    final result = await _repository.getBreeds(
      limit: _pageSize,
      page: _currentPage,
    );

    switch (result) {
      case Success(:final data):
        _breeds.addAll(data);
        _hasMoreData = data.length >= _pageSize;
        _isLoadingMore = false;
        notifyListeners();
      case Failure(:final exception):
        _errorMessage = exception.message;
        _currentPage--;
        _isLoadingMore = false;
        notifyListeners();
    }
  }
}
