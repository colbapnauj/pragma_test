class CatBreed {
  const CatBreed({
    required this.id,
    required this.name,
    required this.origin,
    required this.intelligence,
    required this.referenceImageId,
    this.description,
    this.adaptability,
    this.lifeSpan,
    this.temperament,
  });

  final String id;
  final String name;
  final String origin;
  final int intelligence;
  final String? referenceImageId;
  final String? description;
  final int? adaptability;
  final String? lifeSpan;
  final String? temperament;

  String get imageUrl {
    if (referenceImageId == null || referenceImageId!.isEmpty) {
      return '';
    }
    return 'https://cdn2.thecatapi.com/images/$referenceImageId.jpg';
  }
}
