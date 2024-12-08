import 'package:flutter/material.dart';
import 'package:santap_mantap_app/screen/detail_screen.dart';
import 'package:santap_mantap_app/screen/main_screen.dart';

import 'routes/navigation_route.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SantapMantap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      initialRoute: NavigationRoute.mainRoute.name,
      routes: {
        NavigationRoute.mainRoute.name: (context) => const MainScreen(),
        NavigationRoute.detailRoute.name: (context) => const DetailScreen(),
      }
    );
  }
}
