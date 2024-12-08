import 'dart:convert';

import 'package:santap_mantap_app/network/api_config.dart';

import 'category_model.dart';
import 'menu_model.dart';
import 'review_model.dart';

class RestaurantModel {
  final String? id;
  final String? name;
  final String? description;
  final String? city;
  final String? address;
  final String? pictureId;
  final List<CategoryModel>? categories;
  final MenuModel? menus;
  final double? rating;
  final List<CustomerReviewModel>? customerReviews;

  RestaurantModel({
    this.id,
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

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    final categories = json['categories'] as List?;
    final menus = json['menus'] as Map<String, dynamic>?;
    final customerReviews = json['customerReviews'] as List?;

    return RestaurantModel(
      id: json['id'] as String? ?? '',
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

  static List<RestaurantModel> parseRestaurants(String? json) {
    if (json == null) {
      return [];
    }

    final Map<String, dynamic> parsed = jsonDecode(json);
    final List data = parsed["restaurants"];
    final result = data.map((json) => RestaurantModel.fromJson(json)).toList();
    return result;
  }

  String getPictureUrl({
    String size = 'small',
  }) {
    if (pictureId == null) {
      return '';
    } else {
      return ApiConfig.smallImageURL(pictureId!);
    }
  }
}
