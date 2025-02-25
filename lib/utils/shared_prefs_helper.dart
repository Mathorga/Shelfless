import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
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
}