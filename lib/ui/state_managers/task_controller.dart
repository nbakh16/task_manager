import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';

class TaskController extends GetxController{
  bool _isLoading = false;
  TaskModel _taskModel = TaskModel();

  bool get isLoading => _isLoading;
  TaskModel get taskModel => _taskModel;

  Future<bool> getTasksList(String responseUrl) async {
    _isLoading = true;
    update();

    final NetworkResponse response = await NetworkCaller().getRequest(responseUrl);
    _isLoading = false;

    if(response.isSuccess) {
      _taskModel = TaskModel.fromJson(response.body!);
      update();

      return true;
    }
    else {
      Get.snackbar('Failed', 'Tasks list failed!',
          backgroundColor: Colors.red, colorText: Colors.white);
      update();

      return false;
    }
  }

}