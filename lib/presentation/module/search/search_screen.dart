import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:santap_mantap_app/presentation/global_widgets/empty_state_view.dart';
import 'package:santap_mantap_app/presentation/module/home/widget/restaurant_card.dart';
import 'package:santap_mantap_app/presentation/module/search/search_provider.dart';
import 'package:santap_mantap_app/utils/ui_state.dart';

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
      body: SafeArea(
        child: Consumer<SearchProvider>(
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
                      prefixIcon: Icon(Icons.search),
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
                  onInitial: () => const SizedBox(),
                  onLoading: () => const Expanded(
                    child: Center(
                      child: CupertinoActivityIndicator(
                        radius: 16,
                      ),
                    ),
                  ),
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
                                    arguments: provider.restaurants[index].id,
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
      ),
    );
  }
}
