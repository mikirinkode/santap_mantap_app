import 'package:flutter/widgets.dart';
import 'package:santap_mantap_app/data/model/restaurant_detail_model.dart';
import 'package:santap_mantap_app/di/injection.dart';
import 'package:santap_mantap_app/domain/entities/restaurant_detail_entity.dart';
import 'package:santap_mantap_app/domain/repositories/restaurant_repository.dart';

import '../../../data/network/remote_data_source.dart';
import '../../../domain/entities/review_entity.dart';
import '../../../utils/ui_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantRepository _repository =
      Injection.instance.restaurantRepository;

  UIState _state = InitialState();

  UIState get state => _state;

  UIState _submitState = InitialState();

  UIState get submitState => _submitState;

  RestaurantDetailEntity? _restaurant;

  RestaurantDetailEntity? get restaurant => _restaurant;

  String userName = "";
  String userReview = "";

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

  void onUserNameChanged(String value) {
    userName = value;
  }

  void onUserReviewChanged(String value) {
    userReview = value;
  }

  Future<void> submitReview({
    required String restaurantId,
    required Function onSuccess,
  }) async {
    _submitState = UIState.loading();
    notifyListeners();
    debugPrint("userName: $userName, userReview: $userReview");
    try {
      final review = ReviewEntity(
          restaurantId: restaurantId, name: userName, review: userReview);
      await _repository.postReview(review: review);
      getRestaurantDetail(restaurantId);
      onSuccess.call();
      _submitState = UIState.success();
      notifyListeners();
    } catch (e) {
      _submitState = UIState.error(e.toString());
      notifyListeners();
    }
  }
}
