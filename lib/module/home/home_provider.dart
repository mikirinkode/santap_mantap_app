import 'package:flutter/widgets.dart';
import 'package:santap_mantap_app/model/restaurant_model.dart';
import 'package:santap_mantap_app/network/api_service.dart';

sealed class HomeState {}

class InitialState extends HomeState {}

class LoadingState extends HomeState {}

class ErrorState extends HomeState {
  final String errorMessage;

  ErrorState(this.errorMessage);
}

class LoadedState extends HomeState {}

class HomeProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  HomeState _state = InitialState();

  HomeState get state => _state;

  List<RestaurantModel> _topRestaurants = [];

  List<RestaurantModel> get topRestaurants => _topRestaurants;

  List<RestaurantModel> _restaurants = [];

  List<RestaurantModel> get restaurants => _restaurants;

  Future<void> getRestaurants() async {
    _state = LoadingState();
    notifyListeners();
    try {
      List<RestaurantModel> restaurants = await apiService.getRestaurants();

      // Sort the list to get the top 3
      final sorterRestaurants = restaurants;
      sorterRestaurants.sort(
        (a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0),
      );

      _topRestaurants = sorterRestaurants.take(3).toList();

      // remove the top 3 from the list
      restaurants.removeWhere((item) => topRestaurants.contains(item));
      _restaurants = restaurants;

      _state = LoadedState();
      notifyListeners();
    } catch (e) {
      _state = ErrorState(e.toString());
      notifyListeners();
    }
  }
}
