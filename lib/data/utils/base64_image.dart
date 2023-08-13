import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:task_manager/data/utils/assets_utils.dart';
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
  static bool isBase64String(String? str) {
    if (str == null) return false;
    final RegExp base64Regex = RegExp(
        r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$');
    return base64Regex.hasMatch(str);
  }

  static ImageProvider<Object> getBase64Image(String base64String) {
    if (base64String.isNotEmpty) {
      if(isBase64String(base64String)) {
        List<int> imageBytes = base64Decode(base64String);
        return Image.memory(
          Uint8List.fromList(imageBytes),
          fit: BoxFit.cover,
        ).image;
      }
      else {
        return Image.network(base64String).image;
      }
    } else {
      return Image.asset(AssetsUtils.placeholderPNG).image;
    }
  }
}