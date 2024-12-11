import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:santap_mantap_app/presentation/module/setting/setting_provider.dart';

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
      context.read<SettingProvider>().checkIsDarkTheme();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pengaturan"),
        ),
        body: Consumer<SettingProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                SwitchListTile(
                  title: const Text("Tema Gelap"),
                  value: provider.isDarkTheme,
                  onChanged: provider.onChangeTheme,
                ),
              ],
            );
          },
        ));
  }
}
