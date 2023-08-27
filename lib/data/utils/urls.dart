import 'package:task_manager/data/utils/task_status.dart';

class Urls {
  Urls._();

  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';

  static String signupUrl = '$_baseUrl/registration';
  static String loginUrl = '$_baseUrl/login';

  static String createTaskUrl = '$_baseUrl/createTask';
  static String deleteTaskUrl(String id) => '$_baseUrl/deleteTask/$id';
  static String taskStatusUpdateUrl(String id, String taskStatus) => '$_baseUrl/updateTaskStatus/$id/$taskStatus';

  static String newTasksListUrl = '$_baseUrl/listTaskByStatus/${TaskStatus.newTask}';
  static String completedTasksListUrl = '$_baseUrl/listTaskByStatus/${TaskStatus.completedTask}';
  static String progressTasksListUrl = '$_baseUrl/listTaskByStatus/${TaskStatus.progressTask}';
  static String canceledTasksListUrl = '$_baseUrl/listTaskByStatus/${TaskStatus.canceledTask}';
  static String taskStatusCountUrl = '$_baseUrl/taskStatusCount';

  static String recoveryEmailUrl(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static String recoveryOTPUrl(String email, String otp) => '$_baseUrl/RecoverVerifyOTP/$email/$otp';
  static String setPasswordUrl = '$_baseUrl/RecoverResetPass';

  static String profileUpdateUrl = '$_baseUrl/profileUpdate';
}