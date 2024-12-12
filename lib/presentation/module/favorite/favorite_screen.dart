import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:santap_mantap_app/presentation/module/favorite/favorite_provider.dart';
import 'package:santap_mantap_app/utils/ui_state.dart';
import 'package:santap_mantap_app/utils/ui_utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../routes/navigation_route.dart';
import '../../../utils/ui_loading_dummy_data.dart';
import '../../global_widgets/empty_state_view.dart';
import '../../global_widgets/error_state_view.dart';
import '../home/widget/restaurant_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<FavoriteProvider>().getRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resto Favoritmu"),
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, child) {
          return provider.state.when(
            onInitial: () => const SizedBox(),
            onLoading: () => buildLoadingIndicator(),
            onError: (message) => Expanded(
              child: ErrorStateView(
                message: message,
                onRetry: () {
                  provider.getRestaurants();
                },
              ),
            ),
            onSuccess: () => provider.restaurants.isEmpty
                ? const EmptyStateView(
                    message:
                        "Kamu belum memiliki restaurant favorite, silahkan tambahkan favorite terlebih dahulu.",
                  )
                : ListView.builder(
                    itemCount: provider.restaurants.length,
                    padding: UIUtils.paddingTop(16),
                    itemBuilder: (context, index) {
                      return RestaurantCard(
                        restaurant: provider.restaurants[index],
                        onTap: () async {
                          final shouldRefresh = await Navigator.pushNamed(
                            context,
                            NavigationRoute.detailRoute.name,
                            arguments: provider.restaurants[index],
                          );

                          if (shouldRefresh == true) {
                            provider.getRestaurants();
                          }
                        },
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  Widget buildLoadingIndicator() {
    return Skeletonizer(
      child: SingleChildScrollView(
        physics: const ScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: UIUtils.paddingTop(16),
        child: Column(
          children: UiLoadingDummyData.dummyRestaurants
              .map((e) => RestaurantCard(
                    restaurant: e,
                    onTap: () {},
                  ))
              .toList(),
        ),
      ),
    );
  }
}
