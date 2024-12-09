import 'package:santap_mantap_app/model/restaurant_model.dart';
import 'package:santap_mantap_app/network/api_config.dart';
import 'package:santap_mantap_app/network/api_handler.dart';

import 'response/restaurant_detail_response.dart';
import 'response/restaurant_list_response.dart';

class ApiService {
  Future<List<RestaurantModel>> getRestaurants() async {
    return await ApiHandler.get(
      url: ApiConfig.restaurantListURL,
      fromJson: (json) => RestaurantListResponse.fromJson(json).restaurants,
      errorMessage: "Gagal mengambil daftar restoran.",
    );
  }

  Future<RestaurantModel> getRestaurant(String id) async {
    return await ApiHandler.get(
      url: ApiConfig.restaurantDetailURL(id),
      fromJson: (json) => RestaurantDetailResponse.fromJson(json).restaurant,
      errorMessage: "Gagal mengambil detail restoran.",
    );
  }
}
