class Urls {
  Urls._();

  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';

  static String signupUrl = '$_baseUrl/registration';
  static String loginUrl = '$_baseUrl/login';
  static String createTaskUrl = '$_baseUrl/createTask';
  static String deleteTaskUrl = '$_baseUrl/deleteTask/'; //id variable

  static String taskStatusCountUrl = '$_baseUrl/taskStatusCount';
  static String newTasksListUrl = '$_baseUrl/listTaskByStatus/New';
  static String completedTasksListUrl = '$_baseUrl/listTaskByStatus/Completed';
  static String progressTasksListUrl = '$_baseUrl/listTaskByStatus/Progress';
  static String cancelledTasksListUrl = '$_baseUrl/listTaskByStatus/Cancelled';


  static String recoveryEmailUrl = '$_baseUrl/RecoverVerifyEmail/'; //email address
  static String recoveryOTPUrl = '$_baseUrl/RecoverVerifyOTP/'; //email address // otp
  static String setPasswordUrl = '$_baseUrl/RecoverResetPass';

}