import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:santap_mantap_app/data/source/local/shared_preferences_service.dart';
import 'package:santap_mantap_app/core/services/notification_service.dart';
import 'package:santap_mantap_app/core/services/permission_service.dart';

import '../../../data/model/daily_reminder_model.dart';

class SettingProvider extends ChangeNotifier {
  final SharedPreferencesService _sharedPreferencesService;

  final PermissionService _permissionService;

  final NotificationService _notificationService;

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  bool _isReminderEnabled = false;
  bool get isReminderEnabled => _isReminderEnabled;
  int _notificationId = 0;

  bool _isNotificationGranted = false;
  bool get isNotificationGranted => _isNotificationGranted;

  List<PendingNotificationRequest> pendingNotificationRequests = [];

  SettingProvider({
    required SharedPreferencesService sharedPreferencesService,
    required PermissionService permissionService,
    required NotificationService notificationService,
  })  : _sharedPreferencesService = sharedPreferencesService,
        _permissionService = permissionService,
        _notificationService = notificationService;

  Future<void> initSetting() async {
    _isDarkTheme = await _sharedPreferencesService.isDarkTheme;
    _isNotificationGranted =
        await _permissionService.isNotificationPermissionGranted();
    pendingNotificationRequests =
        await _notificationService.pendingNotificationRequests();
    _isReminderEnabled = pendingNotificationRequests.isNotEmpty;
    notifyListeners();
  }

  void onChangeTheme(bool value) {
    _isDarkTheme = value;
    _sharedPreferencesService.setDarkTheme(value);
    notifyListeners();
  }

  Future<void> toggleReminder(bool value) async {
    debugPrint("toggleReminder: $value");
    if (value == false) {
      for (var request in pendingNotificationRequests) {
        await cancelNotification(request.id);
      }
    } else {
      scheduleDailyLunchNotification();
    }
    initSetting();
  }

  Future<void> requestNotificationPermission({
    required Function onGranted,
    required Function onDenied,
  }) async {
    final isGranted =
        await _permissionService.requestAndroidNotificationPermission();
    _isNotificationGranted = isGranted;
    notifyListeners();
    if (isGranted) {
      onGranted();
    } else {
      onDenied();
    }
  }

  showNotification() {
    _notificationService.showNotification(
      id: _notificationId,
      title: "title",
      body: "body",
      payload: "payload",
    );
  }

  void scheduleDailyLunchNotification() {
    for (var reminder in DailyReminderModel.reminders) {
      _notificationId += 1;
      final scheduledDate =
          _notificationService.getScheduleDate(type: reminder.type);

      _notificationService.createScheduledNotification(
        id: _notificationId,
        scheduledDate: scheduledDate,
        notificiationTitle: reminder.title,
        notificiationBody: reminder.body,
      );
    }
  }

  Future<void> checkPendingNotificationRequests(BuildContext context) async {
    pendingNotificationRequests =
        await _notificationService.pendingNotificationRequests();
    _isReminderEnabled = pendingNotificationRequests.isNotEmpty;
    notifyListeners();
  }

  Future<void> cancelNotification(int id) async {
    await _notificationService.cancelNotification(id);
    initSetting();
  }
}
