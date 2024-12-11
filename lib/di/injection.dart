import 'package:santap_mantap_app/data/source/network/remote_data_source.dart';
import 'package:santap_mantap_app/domain/repositories/restaurant_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/restaurant_repository_impl.dart';
import '../data/source/local/shared_preferences_service.dart';

class Injection {
  static Injection? _instance;

  RestaurantRepository? _restaurantRepository;

  SharedPreferencesService? _sharedPreferencesService;

  Injection._internal() {
    _instance = this;
  }

  static Injection get instance => _instance ??= Injection._internal();

  initialize() async {
    final remoteDataSource = RemoteDataSource();
    final sharedPreferences = await SharedPreferences.getInstance();

    _restaurantRepository = RestaurantRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    _sharedPreferencesService = SharedPreferencesService(
      preferences: sharedPreferences,
    );
  }

  RestaurantRepository get restaurantRepository => _restaurantRepository!;

  SharedPreferencesService get sharedPreferencesService => _sharedPreferencesService!;
}
