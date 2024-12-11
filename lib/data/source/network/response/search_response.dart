import '../../../model/restaurant_model.dart';

class SearchResponse {
  final bool error;
  final int founded;
  final List<RestaurantModel> restaurants;

  SearchResponse({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      error: json['error'],
      founded: json['founded'],
      restaurants: (json['restaurants'] as List)
          .map((restaurant) => RestaurantModel.fromJson(restaurant))
          .toList(),
    );
  }
}