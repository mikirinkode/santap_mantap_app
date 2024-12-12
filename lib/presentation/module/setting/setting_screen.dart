import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:santap_mantap_app/presentation/module/setting/setting_provider.dart';
import 'package:santap_mantap_app/theme/app_color.dart';
import 'package:santap_mantap_app/utils/ui_utils.dart';

import '../../../core/services/notification_service.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SettingProvider>().initSetting();
    });
  }

  @override
  void dispose() {
    selectNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
      ),
      body: Consumer<SettingProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                UIUtils.heightSpace(16),
                SwitchListTile(
                  title: const Text(
                    "Tema Gelap",
                  ),
                  subtitle: const Text(
                    "Gunakan Tema Gelap",
                  ),
                  secondary: Icon(
                    provider.isDarkTheme
                        ? CupertinoIcons.moon_fill
                        : CupertinoIcons.moon,
                  ),
                  value: provider.isDarkTheme,
                  onChanged: provider.onChangeTheme,
                ),
                SwitchListTile(
                  title: Text(
                    "Pengingat",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    "Hidupkan pengingat waktu makan siang pukul 11.00",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  secondary: Icon(
                    provider.isReminderEnabled
                        ? CupertinoIcons.bell_fill
                        : CupertinoIcons.bell,
                  ),
                  value: provider.isReminderEnabled,
                  onChanged: provider.toggleReminder,
                ),
                Column(
                  children: provider.pendingNotificationRequests.map((request) {
                    return ListTile(
                      title: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                          ),
                          UIUtils.widthSpace(16),
                          Text(
                            "Pengingat ${request.title}",
                          ),
                        ],
                      ),
                      leading: const SizedBox(),
                    );
                  }).toList(),
                ),
                Padding(
                  padding: UIUtils.paddingAll(24),
                  child: Divider(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                ListTile(
                  title: const Text(
                    "Izin Notifikasi",
                  ),
                  subtitle: Text(
                    provider.isNotificationGranted
                        ? "Izin diberikan"
                        : "Izin belum diberikan",
                  ),
                  leading: Icon(
                    provider.isNotificationGranted
                        ? CupertinoIcons.bell_circle_fill
                        : CupertinoIcons.bell_slash,
                  ),
                  trailing: Visibility(
                    visible: provider.isNotificationGranted == false,
                    child: TextButton(
                      onPressed: () {
                        provider.requestNotificationPermission(
                          onGranted: () {
                            _showSnackbar(message: "Izin diberikan");
                          },
                          onDenied: () {
                            _showSnackbar(message: "Izin ditolak");
                          },
                        );
                      },
                      child: Text("Izinkan"),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _showSnackbar({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
