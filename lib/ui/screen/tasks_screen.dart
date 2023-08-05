import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/colors.dart';
import 'package:task_manager/data/utils/tasks_screen_info.dart';
import 'package:task_manager/ui/widgets/custom_chip.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _taskModel.taskData?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskCard(
                            taskData: _taskModel.taskData![index],
                            onEdit: () {
                              editTaskModalBottomSheet(index);
                            },
                            onDelete: () {
                              _isTaskDeleted = false;

                              deleteTaskShowDialog(context, index);
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

  void editTaskModalBottomSheet(int index) {
    TextEditingController titleTEController = TextEditingController();
    TextEditingController descriptionTEController = TextEditingController();

    titleTEController.text = _taskModel.taskData?[index].title ?? "";
    descriptionTEController.text = _taskModel.taskData?[index].description ?? "";
    String taskStatus = _taskModel.taskData?[index].status ?? 'New';

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.0)
            )),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState){
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 18,
                  right: 18,
                  left: 18,
                  top: 18),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Update Task',
                              style: Theme.of(context).primaryTextTheme.titleLarge
                          ),
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.cancel_outlined,
                                color: Colors.red.shade300,
                              )
                          )
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: titleTEController,
                      decoration: const InputDecoration(
                          hintText: 'Title of the task',
                          labelText: 'Title'
                      ),
                      maxLines: 1,
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      readOnly: true,
                      validator: (String? value) {
                        if(value?.isEmpty ?? true) {
                          return 'Missing title!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12,),
                    TextFormField(
                      controller: descriptionTEController,
                      decoration: const InputDecoration(
                        hintText: 'Brief description',
                        labelText: 'Description',
                      ),
                      maxLines: 4,
                      maxLength: 250,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      readOnly: true,
                      // onEditingComplete: createTask,
                      // validator: (String? value) {
                      //   if(value?.isEmpty ?? true) {
                      //     return 'Description';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 12,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomChip(
                          radio: RadioListTile(
                            value: TaskStatus.newTask,
                            groupValue: taskStatus,
                            title: Text(TaskStatus.newTask,
                              style: Theme.of(context).primaryTextTheme.labelMedium,
                            ),
                            onChanged: (value) {
                              taskStatus = value!;
                              setState(() {});
                            },
                          ),
                          chipColor: newTaskColor,
                        ),
                        CustomChip(
                          radio: RadioListTile(
                            value: TaskStatus.progressTask,
                            groupValue: taskStatus,
                            title: Text(TaskStatus.progressTask,
                              style: Theme.of(context).primaryTextTheme.labelMedium,
                            ),
                            onChanged: (value) {
                              taskStatus = value!;
                              setState(() {});
                            },
                          ),
                          chipColor: progressTaskColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomChip(
                          radio: RadioListTile(
                            value: TaskStatus.canceledTask,
                            groupValue: taskStatus,
                            title: Text(TaskStatus.canceledTask,
                              style: Theme.of(context).primaryTextTheme.labelMedium,
                            ),
                            onChanged: (value) {
                              taskStatus = value!;
                              setState(() {});
                            },
                          ),
                          chipColor: canceledTaskColor,
                        ),
                        CustomChip(
                          radio: RadioListTile(
                            value: TaskStatus.completedTask,
                            groupValue: taskStatus,
                            title: Text(TaskStatus.completedTask,
                              style: Theme.of(context).primaryTextTheme.labelMedium,
                            ),
                            onChanged: (value) {
                              taskStatus = value!;
                              setState(() {});
                            },
                          ),
                          chipColor: completedTaskColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    Visibility(
                      visible: _isLoading == false,
                      replacement: const CustomLoading(),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              //TODO: edit task api

                              if (_taskModel.taskData![index].status != taskStatus) {
                                updateTaskStatus(_taskModel.taskData![index].sId!, taskStatus);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Update Task'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<void> updateTaskStatus(String id, String status) async {
    final NetworkResponse response = await NetworkCaller().getRequest('${Urls.taskStatusUpdateUrl}$id/$status');
    final Map<String, Color> colorsMap = {
      TaskStatus.newTask: newTaskColor,
      TaskStatus.progressTask: progressTaskColor,
      TaskStatus.canceledTask: canceledTaskColor,
      TaskStatus.completedTask: completedTaskColor,
    };

    final Color snackBarColor = colorsMap[status] ?? mainColor;

    if(response.isSuccess && mounted) {
      Navigator.pop(context);

      //TODO: update screen without calling API
      getTasksList();
      getTaskStatusCount();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Task status updated to $status'),
        backgroundColor: snackBarColor,
      ));
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task status update failed!'),
        backgroundColor: Colors.red,
      ));
    }
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

  Future<Object?> deleteTaskShowDialog(BuildContext context, int index) {
    return showGeneralDialog(
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
  }
}
