import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:santap_mantap_app/domain/entities/customer_review_entity.dart';
import 'package:santap_mantap_app/domain/entities/menu_entity.dart';
import 'package:santap_mantap_app/domain/entities/restaurant_entity.dart';
import 'package:santap_mantap_app/presentation/module/detail/restaurant_detail_provider.dart';
import 'package:santap_mantap_app/presentation/module/detail/widget/menu_card.dart';
import 'package:santap_mantap_app/utils/app_icons.dart';
import 'package:santap_mantap_app/utils/ui_loading_dummy_data.dart';
import 'package:santap_mantap_app/utils/ui_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../global_widgets/error_state_view.dart';
import '../../../theme/app_color.dart';
import '../../../utils/cache_manager_provider.dart';
import '../../../utils/ui_utils.dart';
import 'widget/review_card.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final RestaurantEntity restaurantArg;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurantArg,
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RestaurantDetailProvider>().getRestaurantDetail(
            widget.restaurantArg.id,
          );
    });
    context.read<RestaurantDetailProvider>().attachListener();
  }

  @override
  void dispose() {
    super.dispose();
    context.read<RestaurantDetailProvider>().detachListener();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, provider, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? _) async {
            Navigator.pop(context, provider.shouldRefreshPreviousScreen);
          },
          child: Scaffold(
            body: buildContent(),
          ),
        );
      },
    );
  }

  Widget buildContent() {
    return Consumer<RestaurantDetailProvider>(
      builder: (context, provider, child) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Hero(
                tag: "restaurant-image-${widget.restaurantArg.id}",
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.restaurantArg.pictureUrl ?? "",
                      height: provider.imageHeight.value,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      cacheManager: CacheMangerProvider.restaurantImage,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: CupertinoActivityIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColor.neutral200,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: AppColor.neutral700,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: provider.imageBlur.value,
                          sigmaY: provider.imageBlur.value,
                        ),
                        child: Container(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: UIUtils.paddingHorizontal(8),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: SingleChildScrollView(
                    controller: provider.scrollController,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    child: provider.state.when(
                      onInitial: () => const SizedBox(),
                      onLoading: () => buildLoadingIndicator(),
                      onError: (message) => ErrorStateView(
                        message: message,
                        onRetry: () {
                          provider.getRestaurantDetail(widget.restaurantArg.id);
                        },
                      ),
                      onSuccess: () => ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        child: Column(
                          children: [
                            UIUtils.heightSpace(200),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                              child: Column(
                                children: [
                                  buildBasicInfoSection(
                                    name: provider.restaurant?.name ?? "",
                                    address:
                                        "${provider.restaurant?.address ?? ""}, ${provider.restaurant?.city ?? ""}",
                                    rating: widget.restaurantArg.rating ?? 0.0,
                                  ),
                                  buildMenuSection(
                                    menu: provider.restaurant?.menus ??
                                        MenuEntity(
                                          foods: [],
                                          drinks: [],
                                        ),
                                  ),
                                  buildAboutSection(
                                    about:
                                        provider.restaurant?.description ?? "",
                                  ),
                                  buildReviewSection(
                                    reviews:
                                        provider.restaurant?.customerReviews ??
                                            [],
                                  ),
                                  UIUtils.heightSpace(72),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: UIUtils.paddingSymmetric(vertical: 16, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton.small(
                      heroTag: "back-button",
                      onPressed: () {
                        // provider.resetState();
                        Navigator.pop(context, true);
                      },
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColor.neutral700,
                      ),
                    ),
                    Visibility(
                      visible: provider.state is SuccessState,
                      child: FloatingActionButton.small(
                        heroTag: "favorite-button",
                        onPressed: () {
                          provider.toggleFavorite(onSuccess: (message) {
                            _showSnackbar(message: message);
                          }, onFailed: (message) {
                            _showSnackbar(message: message);
                          });
                        },
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Icon(
                          provider.isFavorite
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          // color: AppColor.neutral700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: provider.state is SuccessState,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: UIUtils.paddingAll(24),
                  child: FloatingActionButton.extended(
                    heroTag: "add-review-button",
                    onPressed: () {
                      _showAddReviewDialog();
                    },
                    label: Row(
                      children: [
                        const Icon(Icons.edit_note_sharp),
                        UIUtils.widthSpace(8),
                        const Text(
                          "Tulis Review",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: provider.isLoadingSubmitReview.value,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(width: 1, color: AppColor.primary500),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: UIUtils.paddingAll(24),
                  child: const CupertinoActivityIndicator(radius: 18),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildLoadingIndicator() {
    return Skeletonizer(
      child: Column(
        children: [
          UIUtils.heightSpace(200),
          Padding(
            padding: UIUtils.paddingHorizontal(8),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  buildBasicInfoSection(
                    name: "Name",
                    address: "Restaurant address",
                    rating: 0.0,
                  ),
                  buildMenuSection(
                    menu: UiLoadingDummyData.dummyMenu,
                  ),
                  buildAboutSection(
                    about: UiLoadingDummyData.description,
                  ),
                  buildReviewSection(
                    reviews: UiLoadingDummyData.dummyCustomerReviews,
                  ),
                  UIUtils.heightSpace(72),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBasicInfoSection({
    required String name,
    required String address,
    required double rating,
  }) {
    return Padding(
      padding: UIUtils.paddingFromLTRB(
        left: 16,
        top: 16,
        right: 16,
        bottom: 0,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Theme.of(context).cardColor,
        ),
        padding: UIUtils.paddingAll(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                  UIUtils.heightSpace(8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 16,
                      ),
                      UIUtils.widthSpace(8),
                      Flexible(
                        child: Text(
                          address,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: UIUtils.paddingLeft(8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.primary500,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: UIUtils.paddingSymmetric(vertical: 2, horizontal: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    UIUtils.widthSpace(4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMenuSection({required MenuEntity menu}) {
    return Padding(
      padding: UIUtils.paddingFromLTRB(
        left: 0,
        top: 24,
        right: 0,
        bottom: 0,
      ),
      child: Column(
        children: [
          Padding(
            padding: UIUtils.paddingHorizontal(16),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: UIUtils.paddingSymmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Image.asset(
                    AppIcons.food,
                    width: 16,
                    height: 16,
                    color: AppColor.neutral400,
                  ),
                  UIUtils.widthSpace(12),
                  const Text(
                    "Makanan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          UIUtils.heightSpace(16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: UIUtils.paddingHorizontal(16),
            child: IntrinsicHeight(
              child: Row(
                children: menu.foods
                        ?.map(
                          (food) => MenuCard(
                            name: food.name ?? "",
                            isFood: true,
                          ),
                        )
                        .toList() ??
                    [],
              ),
            ),
          ),
          UIUtils.heightSpace(24),
          Padding(
            padding: UIUtils.paddingHorizontal(16),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: UIUtils.paddingSymmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Image.asset(
                    AppIcons.drink,
                    width: 16,
                    height: 16,
                    color: AppColor.neutral500,
                  ),
                  UIUtils.widthSpace(12),
                  const Text(
                    "Minuman",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          UIUtils.heightSpace(16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: UIUtils.paddingHorizontal(16),
            child: IntrinsicHeight(
              child: Row(
                children: menu.drinks
                        ?.map(
                          (drink) => MenuCard(
                            name: drink.name ?? "",
                            isFood: false,
                          ),
                        )
                        .toList() ??
                    [],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAboutSection({required String about}) {
    return Padding(
      padding: UIUtils.paddingFromLTRB(
        left: 16,
        top: 24,
        right: 16,
        bottom: 0,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: UIUtils.paddingAll(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tentang Resto",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            UIUtils.heightSpace(16),
            Text(
              about,
            )
          ],
        ),
      ),
    );
  }

  Widget buildReviewSection({required List<CustomerReviewEntity> reviews}) {
    return Padding(
      padding: UIUtils.paddingFromLTRB(
        left: 16,
        top: 24,
        right: 16,
        bottom: 24,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: UIUtils.paddingAll(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ulasan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            UIUtils.heightSpace(16),
            Column(
              children: reviews
                  .map(
                    (review) => ReviewCard(review: review),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddReviewDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Consumer<RestaurantDetailProvider>(
            builder: (context, provider, child) {
          return AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            title: const Text('Tulis Review'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  UIUtils.heightSpace(16),
                  TextField(
                    onChanged: provider.onUserNameChanged,
                    decoration: const InputDecoration(
                      label: Text("Nama"),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  UIUtils.heightSpace(16),
                  TextField(
                    onChanged: provider.onUserReviewChanged,
                    decoration: const InputDecoration(
                      label: Text("Review"),
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Kirim'),
                onPressed: () {
                  provider.submitReview(
                    restaurantId: widget.restaurantArg.id,
                    onSuccess: () {
                      _showSnackbar(message: 'Review berhasil dikirim');
                    },
                    onError: () {
                      _showSnackbar(message: 'Review gagal dikirim');
                    },
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  _showSnackbar({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
