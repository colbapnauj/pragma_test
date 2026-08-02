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
  late String _breedId;

  CatBreed? get breed => _breed;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadBreed(
    String breedId, {
    String? preloadedName,
    String? preloadedImageUrl,
    bool forceRefresh = false,
  }) async {
    _breedId = breedId;
    final hasPreloadedData = preloadedName != null && preloadedImageUrl != null;

    _isLoading = true;
    _errorMessage = null;

    if (hasPreloadedData && !forceRefresh) {
      _breed = _PreloadedBreed(
        id: breedId,
        name: preloadedName,
        imageUrl: preloadedImageUrl,
      );
    }

    notifyListeners();

    final result = await _repository.getBreedById(breedId, forceRefresh: forceRefresh);

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

  Future<void> refresh() => loadBreed(_breedId, forceRefresh: true);
}

class _PreloadedBreed extends CatBreed {
  _PreloadedBreed({
    required super.id,
    required super.name,
    required String imageUrl,
  }) : super(
    origin: '',
    intelligence: 0,
    referenceImageId: '',
  ) {
    _imageUrl = imageUrl;
  }

  late String _imageUrl;

  @override
  String get imageUrl => _imageUrl;
}
