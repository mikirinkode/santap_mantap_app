import 'package:santap_mantap_app/data/network/remote_data_source.dart';
import 'package:santap_mantap_app/domain/repositories/restaurant_repository.dart';

import '../data/repositories/restaurant_repository_impl.dart';

class Injection {
  static Injection? _instance;

  RemoteDataSource? _remoteDataSource;

  RestaurantRepository? _restaurantRepository;

  Injection._internal() {
    _instance = this;
  }

  static Injection get instance => _instance ??= Injection._internal();

  initialize(){
    _remoteDataSource = RemoteDataSource();
    _restaurantRepository = RestaurantRepositoryImpl(remoteDataSource: _remoteDataSource!);
  }

  RestaurantRepository get restaurantRepository => _restaurantRepository!;
}
