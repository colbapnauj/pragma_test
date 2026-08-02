class CatBreedDto {
  const CatBreedDto({
    required this.id,
    required this.name,
    this.origin,
    this.intelligence,
    this.referenceImageId,
  });

  factory CatBreedDto.fromJson(Map<String, dynamic> json) {
    return CatBreedDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      origin: json['origin'] as String?,
      intelligence: json['intelligence'] as int?,
      referenceImageId: json['reference_image_id'] as String?,
    );
  }

  final String id;
  final String name;
  final String? origin;
  final int? intelligence;
  final String? referenceImageId;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'origin': origin,
        'intelligence': intelligence,
        'reference_image_id': referenceImageId,
      };
}
