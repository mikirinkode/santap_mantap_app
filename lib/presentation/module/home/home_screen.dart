import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:santap_mantap_app/presentation/global_widgets/error_state_view.dart';
import 'package:santap_mantap_app/presentation/module/home/home_provider.dart';
import 'package:santap_mantap_app/routes/navigation_route.dart';
import 'package:santap_mantap_app/theme/app_color.dart';
import 'package:santap_mantap_app/utils/ui_loading_dummy_data.dart';
import 'package:santap_mantap_app/utils/ui_state.dart';
import 'package:santap_mantap_app/utils/ui_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../domain/entities/restaurant_entity.dart';
import '../../../utils/cache_manager_provider.dart';
import 'widget/restaurant_card.dart';
import 'widget/top_restaurant_card.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HomeProvider>().getRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return provider.state.when(
              onInitial: () => const SizedBox(),
              onLoading: () => buildLoadingIndicator(),
              onError: (message) => ErrorStateView(
                message: message,
                onRetry: () {
                  provider.getRestaurants();
                },
              ),
              onSuccess: () => SingleChildScrollView(
                physics: const ScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(),
                    buildSearchBar(),
                    buildSectionTitle(title: "Resto Top Markotop"),
                    buildTopRestaurantRow(
                        topRestaurants: provider.topRestaurants),
                    buildSectionTitle(title: "Restoran lainnya"),
                    buildRestaurantList(restaurants: provider.restaurants),
                    UIUtils.heightSpace(16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildLoadingIndicator() {
    return Skeletonizer(
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(),
            buildSearchBar(),
            buildSectionTitle(title: "Resto Top Markotop"),
            buildTopRestaurantRow(
                topRestaurants: UiLoadingDummyData.dummyRestaurants),
            buildSectionTitle(title: "Restoran lainnya"),
            buildRestaurantList(
                restaurants: UiLoadingDummyData.dummyRestaurants),
            UIUtils.heightSpace(16),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle({required String title}) {
    return Padding(
      padding: UIUtils.paddingFromLTRB(
        left: 16,
        top: 24,
        right: 16,
        bottom: 16,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: UIUtils.paddingFromLTRB(
        left: 16,
        top: 16,
        right: 16,
        bottom: 0,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, NavigationRoute.settingRoute.name);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: UIUtils.paddingAll(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://avatars.githubusercontent.com/u/69853015?v=4",
                  width: 45,
                  height: 45,
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
              ),
              UIUtils.widthSpace(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Selamat Datang,",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  UIUtils.heightSpace(4),
                  const Text(
                    "Wafa Al Ausath",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: UIUtils.paddingFromLTRB(
        left: 16,
        top: 16,
        right: 16,
        bottom: 0,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, NavigationRoute.searchRoute.name);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1, color: AppColor.neutral200),
                ),
                padding: UIUtils.paddingAll(16),
                child: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.search,
                      size: 18,
                    ),
                    UIUtils.widthSpace(12),
                    const Text(
                      "Cari Restoran",
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: AppColor.neutral200,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          UIUtils.widthSpace(16),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, NavigationRoute.favoriteRoute.name);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: AppColor.neutral200),
              ),
              padding: UIUtils.paddingAll(12),
              child: const Icon(CupertinoIcons.heart_fill),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopRestaurantRow(
      {required List<RestaurantEntity> topRestaurants}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: UIUtils.paddingHorizontal(16),
      child: Row(
        children: topRestaurants
            .map(
              (restaurant) => TopRestaurantCard(
                restaurant: restaurant,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    NavigationRoute.detailRoute.name,
                    arguments: restaurant,
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget buildRestaurantList({required List<RestaurantEntity> restaurants}) {
    return Padding(
      padding: UIUtils.paddingHorizontal(16),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final RestaurantEntity restaurant = restaurants[index];
          return RestaurantCard(
            restaurant: restaurant,
            onTap: () {
              Navigator.pushNamed(
                context,
                NavigationRoute.detailRoute.name,
                arguments: restaurant,
              );
            },
          );
        },
      ),
    );
  }
}
