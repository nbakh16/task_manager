import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class ProfileController extends GetxController{
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> updateProfile(String fName, String lName, String mobile, String photo) async {
    _isLoading = true;
    update();

    Map<String, dynamic> requestBody = {
      // "email": AuthUtility.userInfo.data!.email,
      "firstName": fName,
      "lastName": lName,
      "mobile": mobile,
      "photo": photo
    };
    final NetworkResponse response = await NetworkCaller().postRequest(Urls.profileUpdateUrl, requestBody);

    _isLoading = false;
    update();

    if(response.isSuccess) {
      return true;
    }
    else {
      return false;
    }
  }
}