import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/restaurant_entity.dart';
import '../../../../theme/app_color.dart';
import '../../../../utils/cache_manager_provider.dart';
import '../../../../utils/ui_utils.dart';

class TopRestaurantCard extends StatelessWidget {
  RestaurantEntity restaurant;
  final Function() onTap;

  TopRestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: UIUtils.paddingLeft(16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Hero(
                      tag: "restaurant-image-${restaurant.id}",
                      child: CachedNetworkImage(
                        imageUrl: restaurant.pictureUrl ?? "",
                        height: 150,
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
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColor.primary500,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      padding: UIUtils.paddingSymmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                            UIUtils.widthSpace(8),
                            Text(
                              "${restaurant.rating}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 16,
                        ),
                        UIUtils.widthSpace(8),
                        Flexible(
                          child: Text(restaurant.city ?? ""),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
