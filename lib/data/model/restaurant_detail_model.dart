import 'dart:convert';

import 'package:santap_mantap_app/data/network/api_config.dart';
import 'package:santap_mantap_app/domain/entities/restaurant_detail_entity.dart';

import '../../utils/image_size.dart';
import 'category_model.dart';
import 'menu_model.dart';
import 'review_model.dart';

class RestaurantDetailModel {
  final String id;
  final String? name;
  final String? description;
  final String? city;
  final String? address;
  final String? pictureId;
  final List<CategoryModel>? categories;
  final MenuModel? menus;
  final double? rating;
  final List<CustomerReviewModel>? customerReviews;

  RestaurantDetailModel({
    required this.id,
    this.name,
    this.description,
    this.city,
    this.address,
    this.pictureId,
    this.categories,
    this.menus,
    this.rating,
    this.customerReviews,
  });

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) {
    final categories = json['categories'] as List?;
    final menus = json['menus'] as Map<String, dynamic>?;
    final customerReviews = json['customerReviews'] as List?;

    return RestaurantDetailModel(
      id: json['id'],
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      city: json['city'] as String? ?? '',
      address: json['address'] as String? ?? '',
      pictureId: json['pictureId'] as String? ?? '',
      categories:
          categories?.map((item) => CategoryModel.fromJson(item)).toList(),
      menus: (menus == null) ? null : MenuModel.fromJson(menus),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      customerReviews: customerReviews
          ?.map((item) => CustomerReviewModel.fromJson(item))
          .toList(),
    );
  }

  String getPictureUrl() {
    if (pictureId == null || pictureId!.isEmpty) {
      return '';
    } else {
      return ApiConfig.largeImageURL(pictureId!);
    }
  }

  RestaurantDetailEntity toEntity() {
    return RestaurantDetailEntity(
      id: id,
      name: name,
      description: description,
      city: city,
      address: address,
      pictureId: pictureId,
      categories: categories?.map((item) => item.toEntity()).toList(),
      menus: menus?.toEntity(),
      rating: rating,
      customerReviews: customerReviews?.map((item) => item.toEntity()).toList(),
      pictureUrl: getPictureUrl(),
    );
  }
}
