import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:santap_mantap_app/module/home/home_provider.dart';
import 'package:santap_mantap_app/routes/navigation_route.dart';
import 'package:santap_mantap_app/theme/app_color.dart';
import 'package:santap_mantap_app/utils/ui_state.dart';
import 'package:santap_mantap_app/utils/ui_utils.dart';

import '../../model/restaurant_model.dart';
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
              onLoading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              onError: (message) => Center(
                child: Text(message),
              ),
              onSuccess: () => buildContent(),
            );
          },
        ),
      ),
    );
  }

  Widget buildContent() {
    return SingleChildScrollView(
      physics: const ScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(),
          buildSearchBar(),
          buildSectionTitle(title: "Resto Top Markotop"),
          buildTopRestaurantRow(),
          buildSectionTitle(title: "Restoran lainnya"),
          buildRestaurantList(),
          UIUtils.heightSpace(16),
        ],
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
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
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
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 1, color: AppColor.neutral200),
        ),
        padding: UIUtils.paddingAll(16),
        child: const Row(
          children: [
            Text(
              "Cari Resto",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: AppColor.neutral200,
              ),
            ),
            Spacer(),
            Icon(
              CupertinoIcons.search,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTopRestaurantRow() {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: UIUtils.paddingHorizontal(16),
          child: Row(
            children: provider.topRestaurants
                .map(
                  (restaurant) => TopRestaurantCard(
                    restaurant: restaurant,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.detailRoute.name,
                        arguments: restaurant.id ?? "0",
                      );
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  Widget buildRestaurantList() {
    return Padding(
      padding: UIUtils.paddingHorizontal(16),
      child: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.restaurants.length,
            itemBuilder: (context, index) {
              final RestaurantModel restaurant = provider.restaurants[index];
              return RestaurantCard(
                restaurant: restaurant,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    NavigationRoute.detailRoute.name,
                    arguments: restaurant.id ?? "0",
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
