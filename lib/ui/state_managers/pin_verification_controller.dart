import 'dart:convert';

import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class PinVerificationController extends GetxController{
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> verifyEmailWithPin(String email, String otp) async {
    _isLoading = true;
    update();

    final String responseUrl = Urls.recoveryOTPUrl(email, otp);
    final NetworkResponse response = await NetworkCaller().getRequest(responseUrl);

    _isLoading = false;
    update();

    if(otp.length == 6) {
      Map<String, dynamic> decodedResponse = jsonDecode(jsonEncode(response.body));
      if(response.isSuccess) {
        if(decodedResponse['status'] == 'success') {
          return true;
        }
        else {
          return false;
        }
      }
      else {
        return false;
      }
    } else {
      return false;
    }
  }
}