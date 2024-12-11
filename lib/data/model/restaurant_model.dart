import 'package:santap_mantap_app/data/source/network/api_config.dart';
import 'package:santap_mantap_app/domain/entities/restaurant_entity.dart';


class RestaurantModel {
  final String id;
  final String? name;
  final String? description;
  final String? pictureId;
  final String? city;
  final double? rating;

  RestaurantModel({
    required this.id,
    this.name,
    this.description,
    this.city,
    this.pictureId,
    this.rating,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      city: json['city'] as String? ?? '',
      pictureId: json['pictureId'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String getPictureUrl() {
    if (pictureId == null || pictureId!.isEmpty) {
      return '';
    } else {
      return ApiConfig.smallImageURL(pictureId!);
    }
  }

  RestaurantEntity toEntity() {
    return RestaurantEntity(
      id: id,
      name: name,
      description: description,
      city: city,
      pictureId: pictureId,
      rating: rating,
      pictureUrl: getPictureUrl(),
    );
  }
}
