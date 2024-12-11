import 'package:santap_mantap_app/data/model/restaurant_detail_model.dart';
import 'package:santap_mantap_app/data/source/network/api_config.dart';
import 'package:santap_mantap_app/data/source/network/api_handler.dart';
import 'package:santap_mantap_app/data/source/network/response/post_review_response.dart';
import 'package:santap_mantap_app/data/source/network/response/search_response.dart';

import '../../model/restaurant_model.dart';
import 'body/review_body.dart';
import 'response/restaurant_detail_response.dart';
import 'response/restaurant_list_response.dart';

class RemoteDataSource {
  Future<List<RestaurantModel>> getRestaurants() async {
    return await ApiHandler.get(
      url: ApiConfig.restaurantListURL,
      fromJson: (json) => RestaurantListResponse.fromJson(json).restaurants,
      errorMessage: "Gagal mengambil daftar restoran.",
    );
  }

  Future<RestaurantDetailModel> getRestaurant(String id) async {
    return await ApiHandler.get(
      url: "${ApiConfig.restaurantDetailURL}/$id",
      fromJson: (json) => RestaurantDetailResponse.fromJson(json).restaurant,
      errorMessage: "Gagal mengambil detail restoran.",
    );
  }

  Future<List<RestaurantModel>> searchRestaurants(String query) async {
    return await ApiHandler.get(
      url: "${ApiConfig.searchURL}?q=$query",
      fromJson: (json) => SearchResponse.fromJson(json).restaurants,
      errorMessage: "Gagal mengambil daftar restoran.",
    );
  }

  Future<PostReviewResponse> postReview(ReviewBody review) async {
    return ApiHandler.post(
      url: ApiConfig.postReviewURL,
      headers: ApiConfig.headers,
      body: review.toJson(),
      fromJson: (json) => PostReviewResponse.fromJson(json),
      errorMessage: "Gagal mengirim review.",
    );
  }
}
