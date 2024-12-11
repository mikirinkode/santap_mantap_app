import 'package:flutter/widgets.dart';
import 'package:santap_mantap_app/data/source/local/sqlite_service.dart';
import 'package:santap_mantap_app/di/injection.dart';
import 'package:santap_mantap_app/domain/entities/restaurant_detail_entity.dart';
import 'package:santap_mantap_app/domain/entities/restaurant_entity.dart';
import 'package:santap_mantap_app/domain/repositories/restaurant_repository.dart';

import '../../../data/model/restaurant_model.dart';
import '../../../domain/entities/review_entity.dart';
import '../../../utils/ui_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RestaurantRepository _repository =
      Injection.instance.restaurantRepository;

  final SqliteService _service = Injection.instance.sqliteService; // TODO: MOVE

  UIState _state = InitialState();

  UIState get state => _state;

  RestaurantDetailEntity? _restaurant;

  RestaurantDetailEntity? get restaurant => _restaurant;

  String _userName = "";
  String _userReview = "";

  final isLoadingSubmitReview = ValueNotifier<bool>(false);

  bool _isFavorite = false;

  bool get isFavorite => _isFavorite;

  bool _shouldRefreshPreviousScreen = false;

  bool get shouldRefreshPreviousScreen => _shouldRefreshPreviousScreen;

  Future<void> getRestaurantDetail(String id) async {
    _state = UIState.loading();
    notifyListeners();
    try {
      _restaurant = await _repository.getRestaurantDetail(id);
      _shouldRefreshPreviousScreen = false;
      _checkIsFavorite();
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
      getRestaurantDetail(restaurantId);
    } catch (e) {
      debugPrint("Error: $e");
      isLoadingSubmitReview.value = false;
      debugPrint("isLoadingSubmitReview: ${isLoadingSubmitReview.value}");
      onError.call();
    }
  }

  Future<void> toggleFavorite({
    required Function(String message) onSuccess,
    required Function(String message) onFailed,
  }) async {
    _isFavorite = !_isFavorite;
    notifyListeners();

    try {
      debugPrint("Toggling favorite...");
      if (_isFavorite) {
        final data = RestaurantModel.fromEntity(
          RestaurantEntity(
            id: restaurant!.id,
            name: restaurant?.name,
            description: restaurant?.description,
            city: restaurant?.city,
            pictureId: restaurant?.pictureId,
            rating: restaurant?.rating,
            pictureUrl: restaurant?.pictureUrl,
          ),
        );
        await _service.insertRestaurant(data);
        onSuccess("Berhasil ditambahkan ke favorit");
        debugPrint("on success called");
      } else {
        await _service.removeRestaurant(restaurant?.id ?? "");
        onSuccess("Berhasil dihapus dari favorit");
        debugPrint("on success called");
      }
      _shouldRefreshPreviousScreen = true;
      notifyListeners();
    } catch (e) {
      debugPrint("Error: $e"); // TODO
      if (_isFavorite) {
        onFailed("Gagal menambahkan ke favorit");
      } else {
        onFailed("Gagal menghapus dari favorit");
      }
      _isFavorite = !_isFavorite;
      notifyListeners();
    }
  }

  Future<void> _checkIsFavorite() async {
    _isFavorite = await _service.contain(restaurant?.id ?? "");
    notifyListeners();
  }
}
