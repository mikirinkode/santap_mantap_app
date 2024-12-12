import 'package:flutter/widgets.dart';
import 'package:santap_mantap_app/di/injection.dart';
import 'package:santap_mantap_app/domain/entities/restaurant_entity.dart';
import 'package:santap_mantap_app/domain/repositories/restaurant_repository.dart';
import 'package:santap_mantap_app/utils/ui_state.dart';

class HomeProvider extends ChangeNotifier {
  final RestaurantRepository _repository;

  UIState _state = UIState.initial();

  UIState get state => _state;

  List<RestaurantEntity> _topRestaurants = [];

  List<RestaurantEntity> get topRestaurants => _topRestaurants;

  List<RestaurantEntity> _restaurants = [];

  List<RestaurantEntity> get restaurants => _restaurants;

  HomeProvider({required RestaurantRepository repository})
      : _repository = repository;

  Future<void> getRestaurants() async {
    _state = UIState.loading();
    notifyListeners();
    try {
      List<RestaurantEntity> result = await _repository.getRestaurants();

      // Create a copy of the original list
      List<RestaurantEntity> unsortedList = List.from(result);

      // Sort the list to get the top 3
      final sortedRestaurants = result;
      sortedRestaurants.sort(
        (a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0),
      );

      _topRestaurants = sortedRestaurants.take(3).toList();

      // remove the top 3 from the unsorted list
      _restaurants =
          unsortedList.where((item) => !topRestaurants.contains(item)).toList();

      _state = UIState.success();
      notifyListeners();
    } catch (e) {
      _state = UIState.error(e.toString());
      notifyListeners();
    }
  }
}
