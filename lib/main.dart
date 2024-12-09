import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:santap_mantap_app/di/injection.dart';
import 'package:santap_mantap_app/domain/entities/restaurant_entity.dart';
import 'package:santap_mantap_app/presentation/module/detail/restaurant_detail_provider.dart';
import 'package:santap_mantap_app/presentation/module/detail/restaurant_detail_screen.dart';
import 'package:santap_mantap_app/presentation/module/home/home_screen.dart';
import 'package:santap_mantap_app/presentation/module/search/search_provider.dart';
import 'package:santap_mantap_app/presentation/module/search/search_screen.dart';

import 'presentation/module/home/home_provider.dart';
import 'routes/navigation_route.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Injection.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantDetailProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchProvider(),
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
    return MaterialApp(
      title: 'SantapMantap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      themeMode: ThemeMode.system,
      initialRoute: NavigationRoute.mainRoute.name,
      routes: {
        NavigationRoute.mainRoute.name: (context) => const HomeScreen(),
        NavigationRoute.detailRoute.name: (context) => RestaurantDetailScreen(
              restaurantArg: ModalRoute.of(context)?.settings.arguments
                  as RestaurantEntity,
            ),
        NavigationRoute.searchRoute.name: (context) => const SearchScreen(),
      },
    );
  }
}
