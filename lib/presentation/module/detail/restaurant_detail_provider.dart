import 'package:flutter/widgets.dart';
import 'package:santap_mantap_app/data/source/local/sqlite_service.dart';
import 'package:santap_mantap_app/di/injection.dart';
import 'package:santap_mantap_app/domain/entities/restaurant_detail_entity.dart';
import 'package:santap_mantap_app/domain/entities/restaurant_entity.dart';
import 'package:santap_mantap_app/domain/repositories/restaurant_repository.dart';
import 'package:santap_mantap_app/utils/build_context.dart';

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

  final _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  final imageHeight = ValueNotifier<double>(600);
  final imageBlur = ValueNotifier<double>(0);

  final BuildContext _context;

  RestaurantDetailProvider({required BuildContext context})
      : _context = context;


  Future<void> getRestaurantDetail(String id) async {
    resetState();
    _state = UIState.loading();
    notifyListeners();
    try {
      _restaurant = await _repository.getRestaurantDetail(id);
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

  void attachListener() {
    _scrollController.addListener(onScrollChanged);
  }

  void detachListener() {
    _scrollController.removeListener(onScrollChanged);
  }

  void onScrollChanged() async {
    debugPrint("offset: ${_scrollController.offset}");
    debugPrint(
        "minScrollExtent: ${_scrollController.position.minScrollExtent}");
    debugPrint(
        "maxScrollExtent: ${_scrollController.position.maxScrollExtent}");

    final offset = _scrollController.offset;
    const minHeight = 300.0;
    final maxHeight = _context.height;

    final minBlur = 0.0;
    final maxBlur = 10.0;

    final minScrollExtent = _scrollController.position.minScrollExtent;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;

    if (offset <= minScrollExtent) {
      imageHeight.value = minHeight;
      imageBlur.value = minBlur;
      notifyListeners();
    } else if (offset >= maxScrollExtent) {
      imageHeight.value = maxHeight;
      imageBlur.value = maxBlur;
      notifyListeners();
    } else {
      // Calculate proportional height
      final progress =
          (offset - minScrollExtent) / (maxScrollExtent - minScrollExtent);
      imageHeight.value = minHeight + (maxHeight - minHeight) * progress;
      imageBlur.value = minBlur + (maxBlur - minBlur) * progress;
      notifyListeners();
    }
  }

  void resetState() {
    imageBlur.value = 0.0;
    imageHeight.value = 300.0;
    _isFavorite = false;
    _shouldRefreshPreviousScreen = false;
    notifyListeners();
  }
}
