import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper with ChangeNotifier {
  // Private instance.
  static final SharedPrefsHelper _instance = SharedPrefsHelper._private();

  // Private constructor.
  SharedPrefsHelper._private();

  // Public instance getter.
  static SharedPrefsHelper get instance => _instance;

  late SharedPreferences data;

  Future<void> init() async {
    data = await SharedPreferences.getInstance();
  }

  /// Stores the provided value to shared preferences.
  Future<void> setValue(String key, dynamic value) async {
    switch (value.runtimeType) {
      case const (double):
        await data.setDouble(key, value);
        break;
      case const (int):
        await data.setInt(key, value);
        break;
      case const (String):
        await data.setString(key, value);
        break;
      case const (bool):
        await data.setBool(key, value);
        break;
      case const (List<String>):
        await data.setStringList(key, value);
        break;
      default:
        return;
    }
  }

  /// Stores the provided value to shared preference and notifies all listeners about it.
  Future<void> setValueAloud(String key, dynamic value) async {
    setValue(key, value);

    notifyListeners();
  }
}