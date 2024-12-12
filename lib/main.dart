import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:santap_mantap_app/di/injection.dart';
import 'package:santap_mantap_app/domain/entities/restaurant_entity.dart';
import 'package:santap_mantap_app/presentation/module/detail/restaurant_detail_provider.dart';
import 'package:santap_mantap_app/presentation/module/detail/restaurant_detail_screen.dart';
import 'package:santap_mantap_app/presentation/module/favorite/favorite_provider.dart';
import 'package:santap_mantap_app/presentation/module/favorite/favorite_screen.dart';
import 'package:santap_mantap_app/presentation/module/home/home_screen.dart';
import 'package:santap_mantap_app/presentation/module/search/search_provider.dart';
import 'package:santap_mantap_app/presentation/module/search/search_screen.dart';
import 'package:santap_mantap_app/presentation/module/setting/setting_provider.dart';
import 'package:santap_mantap_app/presentation/module/setting/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'presentation/module/home/home_provider.dart';
import 'routes/navigation_route.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final injection = await Injection.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeProvider(
            repository: injection.restaurantRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantDetailProvider(context: context),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingProvider()..initSetting(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(
        builder: (context, settingProvider, child) {
      return MaterialApp(
        title: 'SantapMantap',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(context),
        darkTheme: AppTheme.darkTheme(context),
        themeMode:
            settingProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        initialRoute: NavigationRoute.mainRoute.name,
        routes: {
          NavigationRoute.mainRoute.name: (context) => const HomeScreen(),
          NavigationRoute.detailRoute.name: (context) => RestaurantDetailScreen(
                restaurantArg: ModalRoute.of(context)?.settings.arguments
                    as RestaurantEntity,
              ),
          NavigationRoute.searchRoute.name: (context) => const SearchScreen(),
          NavigationRoute.favoriteRoute.name: (context) =>
              const FavoriteScreen(),
          NavigationRoute.settingRoute.name: (context) => const SettingScreen(),
        },
      );
    });
  }
}
