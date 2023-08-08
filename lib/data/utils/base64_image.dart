import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'auth_utility.dart';

class Base64Image {
  //encode image path to base64 and send to server
  static Future<String> base64EncodedString(image) async {
    List<int> imageBytes = await image!.readAsBytes();
    return base64Encode(imageBytes);
  }


  //decode base64 before showing on UI
  static ImageProvider<Object> imageFromBase64String() {
    String? base64String = AuthUtility.userInfo.data?.photo ?? '';
    return Image.memory(base64Decode(base64String), fit: BoxFit.cover,).image;
  }

  //check if the received image is in base64 or not
  bool isBase64String(String? str) {
    if (str == null) return false;
    final RegExp base64Regex = RegExp(
        r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$');
    return base64Regex.hasMatch(str);
  }
}