import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/health_data_model.dart';

class HealthDataPreferences {
  static late SharedPreferences _preferences;

  static const _keyUser = 'user';
  static late HealthData myHealthData;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    myHealthData = HealthData(
      height: 165.0,
      weight: 65.0,
      bloodType: 'A+',
      bmi: 24.0,
      vaccinationStatus: 'Fully Vaccinated',
      date: DateTime.now(),
      isDarkMode: false,
    );
  }

  static Future<void> setHealthData(HealthData healthData) async {
    final json = jsonEncode(healthData.toJson());
    await _preferences.setString(_keyUser, json);
  }

  static HealthData getHealthData() {
    final json = _preferences.getString(_keyUser);
    return json == null ? myHealthData : HealthData.fromJson(jsonDecode(json));
  }
}
