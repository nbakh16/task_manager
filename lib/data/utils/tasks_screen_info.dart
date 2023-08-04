import 'dart:ui';

class TasksScreenInfo {
  final String responseUrl;
  final String taskStatus;
  final Color? chipColor;

  TasksScreenInfo({required this.responseUrl, required this.taskStatus, this.chipColor});
}