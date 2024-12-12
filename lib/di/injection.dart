import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:santap_mantap_app/data/source/local/sqlite_service.dart';
import 'package:santap_mantap_app/data/source/network/remote_data_source.dart';
import 'package:santap_mantap_app/domain/repositories/restaurant_repository.dart';
import 'package:santap_mantap_app/core/services/permission_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/restaurant_repository_impl.dart';
import '../data/source/local/shared_preferences_service.dart';
import '../core/services/notification_service.dart';

class Injection {
  static Injection? _instance;

  RestaurantRepository? _restaurantRepository;

  SharedPreferencesService? _sharedPreferencesService;

  SqliteService? _sqliteService;

  PermissionService? _permissionService;

  NotificationService? _notificationService;

  Injection._internal() {
    _instance = this;
  }

  static Injection get instance => _instance ??= Injection._internal();

  initialize() async {
    final remoteDataSource = RemoteDataSource();
    final sharedPreferences = await SharedPreferences.getInstance();
    final notificationsPlugin = FlutterLocalNotificationsPlugin();

    _sqliteService = SqliteService();

    _restaurantRepository = RestaurantRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    _sharedPreferencesService = SharedPreferencesService(
      preferences: sharedPreferences,
    );

    _permissionService = PermissionService(
      notificationsPlugin: notificationsPlugin,
    );

    _notificationService = NotificationService(
      notificationsPlugin: notificationsPlugin,
    )..init()..configureLocalTimeZone();
  }

  RestaurantRepository get restaurantRepository => _restaurantRepository!;

  SharedPreferencesService get sharedPreferencesService =>
      _sharedPreferencesService!;

  SqliteService get sqliteService => _sqliteService!;

  PermissionService get permissionService => _permissionService!;

  NotificationService get notificationService => _notificationService!;
}
