import 'package:flutter/widgets.dart';
import 'package:santap_mantap_app/data/model/restaurant_detail_model.dart';
import 'package:santap_mantap_app/di/injection.dart';
import 'package:santap_mantap_app/domain/entities/restaurant_detail_entity.dart';
import 'package:santap_mantap_app/domain/repositories/restaurant_repository.dart';

import '../../../data/network/remote_data_source.dart';
import '../../../utils/ui_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantRepository _repository =
      Injection.instance.restaurantRepository;

  UIState _state = InitialState();

  UIState get state => _state;

  RestaurantDetailEntity? _restaurant;

  RestaurantDetailEntity? get restaurant => _restaurant;

  Future<void> getRestaurantDetail(String id) async {
    _state = UIState.loading();
    notifyListeners();
    try {
      _restaurant = await _repository.getRestaurantDetail(id);
      _state = UIState.success();
      notifyListeners();
    } catch (e) {
      _state = UIState.error(e.toString());
      notifyListeners();
    }
  }
}
