import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:santap_mantap_app/model/menu_model.dart';
import 'package:santap_mantap_app/model/restaurant_model.dart';
import 'package:santap_mantap_app/model/review_model.dart';
import 'package:santap_mantap_app/module/detail/restaurant_detail_provider.dart';
import 'package:santap_mantap_app/utils/app_icons.dart';
import 'package:santap_mantap_app/utils/ui_state.dart';

import '../../global_widgets/error_state_view.dart';
import '../../network/api_config.dart';
import '../../theme/app_color.dart';
import '../../utils/ui_utils.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RestaurantDetailProvider>().getRestaurant(
            widget.restaurantId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, provider, child) {
          return provider.state.when(
            onInitial: () => const SizedBox(),
            onLoading: () => const Center(
              child: CupertinoActivityIndicator(),
            ),
            onError: (message) => ErrorStateView(
              message: message,
              onRetry: () {
                provider.getRestaurant(widget.restaurantId);
              },
            ),
            onSuccess: () => buildContent(restaurant: provider.restaurant),
          );
        },
      ),
    );
  }

  Widget buildContent({RestaurantModel? restaurant}) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          child: Hero(
            tag: "hero-restaurant-image",
            child: CachedNetworkImage(
              imageUrl: restaurant?.getPictureUrl(size: ImageSize.large) ?? "",
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
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
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Column(
              children: [
                UIUtils.heightSpace(200),
                buildBasicInfoSection(
                  name: restaurant?.name ?? "",
                  address: "${restaurant?.address}, ${restaurant?.city}",
                  rating: restaurant?.rating ?? 0.0,
                ),
                buildMenuSection(
                  menu: restaurant?.menus ??
                      MenuModel(
                        foods: [],
                        drinks: [],
                      ),
                ),
                buildAboutSection(
                  about: restaurant?.description ?? "",
                ),
                buildReviewSection(
                  reviews: restaurant?.customerReviews ?? [],
                )
              ],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: UIUtils.paddingAll(16),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: Colors.white,
              child: const Icon(
                CupertinoIcons.back,
              ),
            ),
          ),
        ),
      ],
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  UIUtils.heightSpace(8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                      ),
                      UIUtils.widthSpace(8),
                      Flexible(
                        child: Text(address),
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

  Widget buildMenuSection({required MenuModel menu}) {
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: UIUtils.paddingSymmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Image.asset(
                    AppIcons.food,
                    width: 16,
                    height: 16,
                    color: AppColor.neutral500,
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
                          (food) => buildMenuCard(
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
                color: Colors.white,
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
                          (drink) => buildMenuCard(
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

  Widget buildMenuCard({
    required String name,
    required bool isFood,
  }) {
    return Padding(
      padding: UIUtils.paddingRight(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: AppColor.neutral100,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: UIUtils.paddingAll(16),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColor.neutral50,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                (isFood) ? AppIcons.food : AppIcons.drink,
                width: 24,
                height: 24,
                color: AppColor.neutral700,
              ),
            ),
            UIUtils.heightSpace(8),
            SizedBox(
              width: 100,
              child: Text(
                name,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
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
          color: Colors.white,
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

  Widget buildReviewSection({required List<CustomerReviewModel> reviews}) {
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
          color: Colors.white,
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
                    (review) => buildReviewCard(review: review),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReviewCard({required CustomerReviewModel review}) {
    return Padding(
      padding: UIUtils.paddingBottom(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: AppColor.neutral50,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: UIUtils.paddingAll(8),
                child: const Icon(
                  CupertinoIcons.person_alt,
                  color: AppColor.neutral400,
                ),
              ),
              UIUtils.widthSpace(16),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name ?? "",
                      style: const TextStyle(color: AppColor.neutral400),
                    ),
                    UIUtils.heightSpace(4),
                    Text(
                      review.review ?? "",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              )
            ],
          ),
          UIUtils.heightSpace(12),
          Container(
            width: double.infinity,
            height: 1,
            color: AppColor.neutral50,
          ),
        ],
      ),
    );
  }
}
