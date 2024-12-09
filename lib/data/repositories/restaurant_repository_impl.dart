import 'package:santap_mantap_app/data/model/restaurant_detail_model.dart';
import 'package:santap_mantap_app/data/network/remote_data_source.dart';
import 'package:santap_mantap_app/domain/entities/restaurant_detail_entity.dart';

import 'package:santap_mantap_app/domain/entities/restaurant_entity.dart';

import '../../domain/repositories/restaurant_repository.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  
  final RemoteDataSource _remoteDataSource;

  RestaurantRepositoryImpl({required RemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<RestaurantEntity>> getRestaurants() async {
    try {
      final result = await _remoteDataSource.getRestaurants();
      return result.map((model) => model.toEntity()).toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<RestaurantDetailEntity> getRestaurantDetail(String id) async {
     try {
      final result = await _remoteDataSource.getRestaurant(id);
      return result.toEntity();
    } catch (e) {
      return Future.error(e);
    }
  }
}
