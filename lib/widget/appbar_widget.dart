import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthensure/utils/health_data_preferences.dart';

AppBar buildAppBar(BuildContext context) {
  final user = HealthDataPreferences.getHealthData();

  return AppBar(
    leading: BackButton(),
    backgroundColor: Colors.transparent,
    elevation: 0,
    actions: [
      IconButton(
        icon: Icon(CupertinoIcons.moon_stars),
        onPressed: () {
          final newUser = user.copyWith(isDarkMode: true);
          HealthDataPreferences.setHealthData(newUser);
        },
      ),
      IconButton(
        icon: Icon(CupertinoIcons.sun_max),
        onPressed: () {
          final newUser = user.copyWith(isDarkMode: false);
          HealthDataPreferences.setHealthData(newUser);
        },
      ),
    ],
  );
}
