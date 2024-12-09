import 'package:santap_mantap_app/domain/entities/category_entity.dart';
import 'package:santap_mantap_app/domain/entities/customer_review_entity.dart';
import 'package:santap_mantap_app/domain/entities/menu_entity.dart';

class RestaurantDetailEntity {
  final String id;
  final String? name;
  final String? description;
  final String? city;
  final String? address;
  final String? pictureId;
  final String? pictureUrl;
  final List<CategoryEntity>? categories;
  final MenuEntity? menus;
  final double? rating;
  final List<CustomerReviewEntity>? customerReviews;

  RestaurantDetailEntity({
    required this.id,
    this.name,
    this.description,
    this.city,
    this.address,
    this.pictureId,
    this.pictureUrl,
    this.categories,
    this.menus,
    this.rating,
    this.customerReviews,
  });
}
