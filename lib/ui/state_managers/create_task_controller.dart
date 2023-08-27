import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class CreateTaskController extends GetxController{
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> createTask(String title, String description, String status) async {
    _isLoading = true;
    update();

    Map<String, dynamic> requestBody = {
      "title":title,
      "description":description,
      "status":status
    };
    final NetworkResponse response =
    await NetworkCaller().postRequest(Urls.createTaskUrl, requestBody);

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