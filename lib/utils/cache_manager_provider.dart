import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheMangerProvider {
  CacheMangerProvider._();

  static final restaurantImage = CacheManager(
    Config(
      "restaurantImage",
      stalePeriod: const Duration(days: 7),
    ),
  );
}
