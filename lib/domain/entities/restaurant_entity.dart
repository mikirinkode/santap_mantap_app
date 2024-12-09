class RestaurantEntity {
  final String id;
  final String? name;
  final String? description;
  final String? city;
  final String? pictureId;
  final double? rating;
  final String? pictureUrl;

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.pictureId,
    required this.rating,
    required this.pictureUrl,
  });
}
