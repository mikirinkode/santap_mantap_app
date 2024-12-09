import 'package:flutter/widgets.dart';
import 'package:santap_mantap_app/model/restaurant_model.dart';
import 'package:santap_mantap_app/network/api_service.dart';
import 'package:santap_mantap_app/utils/ui_state.dart';

class HomeProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  UIState _state = InitialState();

  UIState get state => _state;

  List<RestaurantModel> _topRestaurants = [];

  List<RestaurantModel> get topRestaurants => _topRestaurants;

  List<RestaurantModel> _restaurants = [];

  List<RestaurantModel> get restaurants => _restaurants;

  Future<void> getRestaurants() async {
    _state = UIState.loading();
    notifyListeners();
    try {
      List<RestaurantModel> result = await apiService.getRestaurants();

      // Create a copy of the original list
      List<RestaurantModel> unsortedList = List.from(result);

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
