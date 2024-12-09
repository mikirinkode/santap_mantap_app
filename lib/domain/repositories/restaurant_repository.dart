import 'package:santap_mantap_app/domain/entities/restaurant_detail_entity.dart';
import 'package:santap_mantap_app/domain/entities/restaurant_entity.dart';

import '../../data/model/restaurant_detail_model.dart';

abstract class RestaurantRepository {
  Future<List<RestaurantEntity>> getRestaurants();
  Future<RestaurantDetailEntity> getRestaurantDetail(String id);
  Future<List<RestaurantEntity>> searchRestaurants({required String query});
}
