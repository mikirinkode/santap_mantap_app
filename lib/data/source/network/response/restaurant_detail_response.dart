import '../../../model/restaurant_detail_model.dart';

class RestaurantDetailResponse {
  final bool error;
  final String message;
  final RestaurantDetailModel restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
      error: json['error'],
      message: json['message'],
      restaurant: RestaurantDetailModel.fromJson(json['restaurant']),
    );
  }
}
