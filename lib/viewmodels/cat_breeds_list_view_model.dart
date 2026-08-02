import 'package:flutter/foundation.dart';

import '../core/constants/app_config.dart';
import '../core/utils/debounce.dart';
import '../core/utils/result.dart';
import '../data/entities/cat_breed.dart';
import '../data/repositories/cat_breed_repository.dart';

class CatBreedsListViewModel extends ChangeNotifier {
  CatBreedsListViewModel(this._repository) {
    _searchDebounce = Debounce(duration: AppConfig.searchDebounceDelay);
  }

  final CatBreedRepository _repository;
  late final Debounce _searchDebounce;

  List<CatBreed> _breeds = [];
  List<CatBreed> _searchResults = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isSearching = false;
  String? _errorMessage;
  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMoreData = true;
  String _searchQuery = '';

  List<CatBreed> get breeds => _searchQuery.isEmpty ? _breeds : _searchResults;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  bool get hasMoreData => _hasMoreData;
  bool get isInSearchMode => _searchQuery.isNotEmpty;

  Future<void> loadBreeds() async {
    _isLoading = true;
    _isLoadingMore = false;
    _errorMessage = null;
    _currentPage = 0;
    _breeds = [];
    _searchQuery = '';
    _searchResults = [];
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
    if (_isLoadingMore || !_hasMoreData || isInSearchMode) return;

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

  void updateSearchQuery(String query) {
    _searchQuery = query.trim();
  }

  Future<void> performSearch() async {
    if (_searchQuery.isEmpty) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    final result = await _repository.searchBreeds(_searchQuery);

    switch (result) {
      case Success(:final data):
        _searchResults = data;
        _isSearching = false;
        notifyListeners();
      case Failure(:final exception):
        _errorMessage = exception.message;
        _isSearching = false;
        notifyListeners();
    }
  }

  @override
  void dispose() {
    _searchDebounce.dispose();
    super.dispose();
  }
}
