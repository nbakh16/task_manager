import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/models/login_model.dart';

class AuthUtility {
  AuthUtility._();

  static LoginModel userInfo = LoginModel();

  static Future<LoginModel> getUserInfo() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    String value = sharedPrefs.getString('user-data')!;

    return LoginModel.fromJson(jsonDecode(value));
  }

  static Future<void> saveUserInfo(LoginModel model) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setString('user-data', jsonEncode(model.toJson()));

    userInfo = model;
  }

  static Future<void> clearUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

  static Future<bool> isUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isLoggedIn = sharedPreferences.containsKey('user-data');
    if(isLoggedIn) {
      userInfo = await getUserInfo();
    }
    return isLoggedIn;
  }
}