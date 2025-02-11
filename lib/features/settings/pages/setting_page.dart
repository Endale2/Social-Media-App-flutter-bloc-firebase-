import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/themes/theme_cubit.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();

    bool isDarkMode = themeCubit.isDarkMode;

    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Column(
          children: [
            ListTile(
              title: Text("dark mode"),
              trailing: CupertinoSwitch(
                  value: isDarkMode,
                  onChanged: (value) => themeCubit.toggleTheme()),
            )
          ],
        ));
  }
}
