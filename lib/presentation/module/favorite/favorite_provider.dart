import 'package:flutter/cupertino.dart';
import 'package:santap_mantap_app/data/source/local/sqlite_service.dart';
import 'package:santap_mantap_app/di/injection.dart';

import '../../../domain/entities/restaurant_entity.dart';
import '../../../utils/ui_state.dart';

class FavoriteProvider extends ChangeNotifier {
  final SqliteService _sqliteService;

  UIState _state = UIState.initial();

  UIState get state => _state;

  List<RestaurantEntity> _restaurants = [];

  List<RestaurantEntity> get restaurants => _restaurants;

  FavoriteProvider({
    required SqliteService sqliteService,
  }) : _sqliteService = sqliteService;

  Future<void> getRestaurants() async {
    _state = UIState.loading();
    notifyListeners();
    try {
      final result = await _sqliteService.getRestaurants();
      _restaurants = result.map((model) => model.toEntity()).toList();
      _state = UIState.success();
      notifyListeners();
    } catch (e) {
      _state = UIState.error(e.toString());
      notifyListeners();
    }
  }
}
