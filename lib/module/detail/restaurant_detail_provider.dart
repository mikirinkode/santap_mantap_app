import 'package:flutter/widgets.dart';
import 'package:santap_mantap_app/model/restaurant_model.dart';

import '../../network/api_service.dart';
import '../../utils/ui_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();

  UIState _state = InitialState();

  UIState get state => _state;

  RestaurantModel? _restaurant;

  RestaurantModel? get restaurant => _restaurant;

  Future<void> getRestaurant(String id) async {
    _state = UIState.loading();
    notifyListeners();
    try {
      _restaurant = await apiService.getRestaurant(id);
      _state = UIState.success();
      notifyListeners();
    } catch (e) {
      _state = UIState.error(e.toString());
      notifyListeners();
    }
  }
}
