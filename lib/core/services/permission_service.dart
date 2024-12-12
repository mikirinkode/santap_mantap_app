import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PermissionService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  PermissionService({required FlutterLocalNotificationsPlugin notificationsPlugin})
      : _notificationsPlugin = notificationsPlugin;

  Future<bool> isNotificationPermissionGranted() async {
    return await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;
  }


  // Future<bool> isExactAlarmsPermissionGranted() async {
  //   return await _notificationsPlugin
  //           .resolvePlatformSpecificImplementation<
  //               AndroidFlutterLocalNotificationsPlugin>()
  //           ?.canScheduleExactNotifications() ??
  //       false;
  // }


   Future<bool> requestExactAlarmsPermission() async {
   return await _notificationsPlugin
           .resolvePlatformSpecificImplementation<
               AndroidFlutterLocalNotificationsPlugin>()
           ?.requestExactAlarmsPermission() ??
       false;
 }

  Future<bool> requestAndroidNotificationPermission() async {
    debugPrint("permission service: requestNotificationPermission called");
    return await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        false;
  }
}
