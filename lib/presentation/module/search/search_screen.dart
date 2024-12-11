import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:santap_mantap_app/presentation/global_widgets/empty_state_view.dart';
import 'package:santap_mantap_app/presentation/module/home/widget/restaurant_card.dart';
import 'package:santap_mantap_app/presentation/module/search/search_provider.dart';
import 'package:santap_mantap_app/utils/ui_loading_dummy_data.dart';
import 'package:santap_mantap_app/utils/ui_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../routes/navigation_route.dart';
import '../../../theme/app_color.dart';
import '../../../utils/ui_utils.dart';
import '../../global_widgets/error_state_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pencarian"),
        scrolledUnderElevation: 0,
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Padding(
                padding: UIUtils.paddingFromLTRB(
                  left: 16,
                  top: 16,
                  right: 16,
                  bottom: 0,
                ),
                child: TextField(
                  onChanged: (value) => {
                    provider.onSearchInputChanged(query: value),
                  },
                  keyboardType: TextInputType.text,
                  canRequestFocus: true,
                  textInputAction: TextInputAction.search,
                  autofocus: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      size: 18,
                    ),
                    hintText: "Cari restoran",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: AppColor.neutral200,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              provider.state.when(
                onInitial: () => Expanded(child: buildInitialSearchInfo()),
                onLoading: () => Flexible(child: buildLoadingIndicator()),
                onError: (message) => Expanded(
                  child: ErrorStateView(
                    message: message,
                    onRetry: () {
                      provider.searchRestaurants();
                    },
                  ),
                ),
                onSuccess: () => provider.restaurants.isEmpty
                    ? const Expanded(
                        child: EmptyStateView(
                          message:
                              "Pencarian tidak ditemukan, coba lagi dengan kata kunci lain.",
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: provider.restaurants.length,
                          padding: UIUtils.paddingTop(16),
                          itemBuilder: (context, index) {
                            return RestaurantCard(
                              restaurant: provider.restaurants[index],
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  NavigationRoute.detailRoute.name,
                                  arguments: provider.restaurants[index],
                                );
                              },
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildInitialSearchInfo() {
    return Padding(
      padding: UIUtils.paddingAll(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.search,
            color: AppColor.neutral400,
            size: 100,
          ),
          UIUtils.heightSpace(24),
          const Text(
            "Cari Resto",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          UIUtils.heightSpace(8),
          const Text(
            "Cari nama restoran dan temukan restoran favoritmu disini.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.neutral400,
            ),
          ),
          UIUtils.heightSpace(16),
        ],
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
