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

  RestaurantDetailEntity? _restaurant;

  RestaurantDetailEntity? get restaurant => _restaurant;

  String _userName = "";
  String _userReview = "";

  final isLoadingSubmitReview = ValueNotifier<bool>(false);

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
    _userName = value;
  }

  void onUserReviewChanged(String value) {
    _userReview = value;
  }

Future<void> submitReview({
  required String restaurantId,
  required Function onSuccess,
  required Function onError,
}) async {
  debugPrint("Submitting review...");
  try {
    isLoadingSubmitReview.value = true;
    debugPrint("isLoadingSubmitReview: ${isLoadingSubmitReview.value}");
    
    final review = ReviewEntity(
      restaurantId: restaurantId,
      name: _userName,
      review: _userReview,
    );
    await _repository.postReview(review: review);

    isLoadingSubmitReview.value = false;
    debugPrint("isLoadingSubmitReview: ${isLoadingSubmitReview.value}");
    onSuccess.call();
  } catch (e) {
    debugPrint("Error: $e");
    isLoadingSubmitReview.value = false;
    debugPrint("isLoadingSubmitReview: ${isLoadingSubmitReview.value}");
    onError.call();
  }
}

}
