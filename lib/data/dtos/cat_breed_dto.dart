class CatBreedDto {
  const CatBreedDto({
    required this.id,
    required this.name,
    this.origin,
    this.intelligence,
    this.referenceImageId,
    this.description,
    this.adaptability,
    this.lifeSpan,
    this.temperament,
  });

  factory CatBreedDto.fromJson(Map<String, dynamic> json) {
    return CatBreedDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      origin: json['origin'] as String?,
      intelligence: json['intelligence'] as int?,
      referenceImageId: json['reference_image_id'] as String?,
      description: json['description'] as String?,
      adaptability: json['adaptability'] as int?,
      lifeSpan: json['life_span'] as String?,
      temperament: json['temperament'] as String?,
    );
  }

  final String id;
  final String name;
  final String? origin;
  final int? intelligence;
  final String? referenceImageId;
  final String? description;
  final int? adaptability;
  final String? lifeSpan;
  final String? temperament;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'origin': origin,
        'intelligence': intelligence,
        'reference_image_id': referenceImageId,
        'description': description,
        'adaptability': adaptability,
        'life_span': lifeSpan,
        'temperament': temperament,
      };
}
