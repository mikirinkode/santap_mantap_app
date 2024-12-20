import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:santap_mantap_app/utils/cache_manager_provider.dart';
import 'package:santap_mantap_app/utils/ui_utils.dart';

import '../../../../domain/entities/restaurant_entity.dart';
import '../../../../theme/app_color.dart';

class RestaurantCard extends StatelessWidget {
  RestaurantEntity restaurant;
  final Function() onTap;

  RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Theme.of(context).cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  child: Hero(
                    tag: "restaurant-image-${restaurant.id}",
                    createRectTween: (Rect? begin, Rect? end) {
                      return MaterialRectCenterArcTween(begin: begin, end: end);
                    },
                    child: CachedNetworkImage(
                      imageUrl: restaurant.pictureUrl ?? "",
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                      cacheManager: CacheMangerProvider.restaurantImage,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: CupertinoActivityIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Theme.of(context).cardColor,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: AppColor.neutral500,
                        ),
                      ),
                    ),
                  ),
                ),
                UIUtils.widthSpace(16),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name ?? "",
                        style: const TextStyle(
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
                          UIUtils.widthSpace(4),
                          Flexible(child: Text(restaurant.city ?? "")),
                        ],
                      ),
                      UIUtils.heightSpace(4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                          ),
                          UIUtils.widthSpace(4),
                          Flexible(child: Text("${restaurant.rating}")),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
