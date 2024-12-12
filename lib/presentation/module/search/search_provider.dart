import 'dart:async';

import 'package:flutter/material.dart';

import '../../../di/injection.dart';
import '../../../domain/entities/restaurant_entity.dart';
import '../../../domain/repositories/restaurant_repository.dart';
import '../../../utils/ui_state.dart';

class SearchProvider extends ChangeNotifier {
  final RestaurantRepository _repository;

  UIState _state = UIState.initial();

  UIState get state => _state;

  List<RestaurantEntity> _restaurants = [];

  List<RestaurantEntity> get restaurants => _restaurants;

  Timer? _debounce;

  String _query = "";

  SearchProvider({required RestaurantRepository repository})
      : _repository = repository;

  Future<void> searchRestaurants() async {
    onSearchInputChanged(query: _query);
  }

  Future<void> onSearchInputChanged({required String query}) async {
    if (query.isEmpty) {
      _restaurants.clear();
      notifyListeners();
    } else {
      debugPrint("onSearchInputChanged: $query");

      _query = query.trim();
      _state = UIState.loading();
      notifyListeners();

      debugPrint("isDebounce active: ${_debounce?.isActive ?? false}");

      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(seconds: 1), () async {
        try {
          _restaurants = await _repository.searchRestaurants(query: query);
          _state = UIState.success();
          notifyListeners();
        } catch (e) {
          _state = UIState.error(e.toString());
          notifyListeners();
        }
      });
    }
  }
}
