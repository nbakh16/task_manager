import 'package:get/get.dart';

import 'login_controller.dart';
import 'signup_controller.dart';
import 'task_summary_controller.dart';
import 'task_controller.dart';
import 'email_verification_controller.dart';
import 'pin_verification_controller.dart';
import 'set_password_controller.dart';
import 'profile_controller.dart';
import 'create_task_controller.dart';

class ControllerBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(SignupController());
    Get.put(TaskSummaryController());
    Get.put(TaskController());
    Get.put(EmailVerificationController());
    Get.put(PinVerificationController());
    Get.put(SetPasswordController());
    Get.put(ProfileController());
    Get.put(CreateTaskController());
  }
}