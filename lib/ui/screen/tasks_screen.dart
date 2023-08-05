import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/colors.dart';
import 'package:task_manager/data/utils/tasks_screen_info.dart';

import '../../data/models/task_model.dart';
import '../../data/utils/task_status.dart';
import '../../data/utils/urls.dart';
import '../widgets/custom_alert_dialog.dart';
import '../widgets/custom_loading.dart';
import '../widgets/no_task_available_widget.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_card.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen(this.tasksScreenInfo, {super.key});

  final TasksScreenInfo tasksScreenInfo;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _isLoading = false;
  TaskModel _taskModel = TaskModel();

  int newTaskCount=0, progressTaskCount=0, completedTaskCount=0, canceledTaskCount=0;

  bool _isTaskDeleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTasksList();
      getTaskStatusCount();
    });
  }

  Future<void> getTaskStatusCount() async {
    newTaskCount=0; progressTaskCount=0;
    completedTaskCount=0; canceledTaskCount=0;

    _isLoading = true;
    if(mounted) {
      setState(() {});
    }

    final NetworkResponse response = await NetworkCaller().getRequest(Urls.taskStatusCountUrl);

    if(response.isSuccess && mounted) {
      Map<String, dynamic> decodedResponse = jsonDecode(jsonEncode(response.body));
      List<TaskCountModel> taskStatusAndCountList = (decodedResponse['data'] as List)
          .map((data) => TaskCountModel.fromJson(data))
          .toList();

      for (var task in taskStatusAndCountList) {
        switch(task.sId) {
          case TaskStatus.newTask:
            newTaskCount = task.sum ?? 0;
            break;
          case TaskStatus.progressTask:
            progressTaskCount = task.sum ?? 0;
            break;
          case TaskStatus.completedTask:
            completedTaskCount = task.sum ?? 0;
            break;
          case TaskStatus.canceledTask:
            canceledTaskCount = task.sum ?? 0;
            break;
        }
      }
    }
    else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tasks status count failed!'),
          backgroundColor: Colors.red,
        ));
      }
    }
    _isLoading = false;
    if(mounted) {
      setState(() {});
    }
  }

  Future<void> getTasksList() async {
    _isLoading = true;
    if(mounted) {
      setState(() {});
    }

    final NetworkResponse response = await NetworkCaller().getRequest(widget.tasksScreenInfo.responseUrl);

    if(response.isSuccess && mounted) {
      _taskModel = TaskModel.fromJson(response.body!);
    }
    else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tasks list failed!'),
          backgroundColor: Colors.red,
        ));
      }
    }

    _isLoading = false;
    if(mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          getTaskStatusCount();
          getTasksList();
        },
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
          child: Visibility(
            visible: _isLoading == false,
            replacement: const CustomLoading(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                summaryRow(),
                Visibility(
                  visible: _taskModel.taskData?.isNotEmpty ?? false,
                  replacement: const NoTaskAvailableWarning(),
                  child: Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: _taskModel.taskData?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskCard(
                            taskData: _taskModel.taskData![index],
                            onEdit: () {},
                            onDelete: () {
                              _isTaskDeleted = false;

                              showGeneralDialog(
                                context: context,
                                pageBuilder: (_, __, ___) {
                                  return Container();
                                },
                                transitionBuilder: (_, anim, __, ___) {
                                  if(_isTaskDeleted) {
                                    return Container();
                                  } else {
                                    return Transform.scale(
                                      scale: Curves.easeInOut.transform(anim.value),
                                      child: CustomAlertDialog(
                                          onPress: () {
                                            deleteTask(_taskModel.taskData?[index].sId ?? '');
                                            setState(() {
                                              _isTaskDeleted = true;
                                            });
                                          },
                                          title: 'Delete Task',
                                          content: 'Deleting task "${_taskModel.taskData?[index].title ?? 'Null'}"',
                                          actionText: 'Confirm'
                                      ),
                                    );
                                  }
                                },
                                transitionDuration: const Duration(milliseconds: 300),
                              );
                            },
                            chipColor: widget.tasksScreenInfo.chipColor,
                          );
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }


  Row summaryRow() {
    return Row(
      children: [
        SummaryCard(
          taskCount: newTaskCount,
          taskType: 'New Task',
          textColor: newTaskColor,
        ),
        SummaryCard(
          taskCount: progressTaskCount,
          taskType: 'Progress',
          textColor: progressTaskColor,
        ),
        SummaryCard(
          taskCount: canceledTaskCount,
          taskType: 'Canceled',
          textColor: canceledTaskColor,
        ),
        SummaryCard(
          taskCount: completedTaskCount,
          taskType: 'Completed',
          textColor: completedTaskColor,
        ),
      ],
    );
  }

  Future<void> deleteTask(String id) async {
    final NetworkResponse response = await NetworkCaller().getRequest('${Urls.deleteTaskUrl}$id');

    if(response.isSuccess && mounted) {
      Navigator.pop(context);
      setState(() {
        _taskModel.taskData!.removeWhere((element) => element.sId == id);

        switch(widget.tasksScreenInfo.taskStatus) {
          case TaskStatus.newTask:
            newTaskCount -= 1;
            break;
          case TaskStatus.progressTask:
            progressTaskCount -= 1;
            break;
          case TaskStatus.canceledTask:
            canceledTaskCount -= 1;
            break;
          case TaskStatus.completedTask:
            completedTaskCount -= 1;
            break;
        }
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task delete failed!'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
