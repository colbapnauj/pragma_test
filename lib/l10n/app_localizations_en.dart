// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cat Breeds';

  @override
  String get splashTitle => 'Cat Breeds';

  @override
  String get homeTitle => 'Cat Breeds';

  @override
  String get breedDetailTitle => 'Breed Detail';

  @override
  String get searchHint => 'Search breeds...';

  @override
  String get searchLabel => 'Search cat breeds';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get viewDetails => 'View details';

  @override
  String get moreButton => 'More...';

  @override
  String get noImageAvailable => 'No image available';

  @override
  String get noResultsFound => 'No results found';

  @override
  String get searching => 'Searching...';

  @override
  String results(Object count) {
    return 'Results ($count)';
  }

  @override
  String get noBreeds => 'No breeds found';

  @override
  String get origin => 'Origin';

  @override
  String get intelligence => 'Intelligence';

  @override
  String get adaptability => 'Adaptability';

  @override
  String get lifeSpan => 'Life Span';

  @override
  String get description => 'Description';

  @override
  String get temperament => 'Temperament';

  @override
  String breedImage(Object name) {
    return '$name image';
  }

  @override
  String breedDetails(Object name) {
    return '$name details';
  }

  @override
  String get pullToRefresh => 'Pull to refresh';

  @override
  String error(Object message) {
    return 'Error: $message';
  }

  @override
  String get loadingIndicator => 'Loading...';

  @override
  String breedCard(String name) {
    return 'Cat breed: $name';
  }
}
