import '../../model/restaurant_model.dart';

class RestaurantDetailResponse {
  final bool error;
  final String message;
  final RestaurantModel restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
      error: json['error'],
      message: json['message'],
      restaurant: RestaurantModel.fromJson(json['restaurant']),
    );
  }
}
