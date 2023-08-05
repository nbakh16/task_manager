import 'package:shared_preferences/shared_preferences.dart';

typedef ThemeChangedCallback = void Function(bool isLight);

class ThemeUtility{
  ThemeUtility._();

  static bool isLight = true;
  static ThemeChangedCallback? themeChangedCallback;

  static Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLight = prefs.getBool('isLight') ?? true;
  }

  static Future<void> saveTheme(bool isLight) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLight', isLight);
    themeChangedCallback?.call(isLight);
  }

  static void switchTheme() {
    isLight = !isLight;
    saveTheme(isLight);
  }
}