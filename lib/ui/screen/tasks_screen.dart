import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/colors.dart';
import 'package:task_manager/data/utils/tasks_screen_info.dart';
import 'package:task_manager/ui/state_managers/task_summary_controller.dart';
import 'package:task_manager/ui/widgets/custom_chip.dart';

import '../../data/utils/task_status.dart';
import '../../data/utils/urls.dart';
import '../state_managers/task_controller.dart';
import '../widgets/custom_alert_dialog.dart';
import '../widgets/custom_loading.dart';
import '../widgets/task_card.dart';
import '../widgets/task_summary_row.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen(this.tasksScreenInfo, {super.key});

  final TasksScreenInfo tasksScreenInfo;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _isTaskDeleted = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TaskSummaryController _taskSummaryController = Get.find();
  final TaskController _taskController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _taskController.getTasksList(widget.tasksScreenInfo.responseUrl);
      _taskSummaryController.getTaskStatusCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _taskSummaryController.getTaskStatusCount();
          _taskController.getTasksList(widget.tasksScreenInfo.responseUrl);
        },
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GetBuilder<TaskSummaryController>(
                builder: (_) {
                  if(_taskSummaryController.isLoading) {
                    return const CustomLoading();
                  }
                  return TaskSummaryRow(
                    newTaskCount: _taskSummaryController.newTaskCount,
                    progressTaskCount: _taskSummaryController.progressTaskCount,
                    canceledTaskCount: _taskSummaryController.canceledTaskCount,
                    completedTaskCount: _taskSummaryController.completedTaskCount,
                  );
                }
              ),
              GetBuilder<TaskController>(
                builder: (_) {
                  if(_taskController.isLoading) {
                    return const CustomLoading();
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 56),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _taskController.taskModel.taskData?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Animate(
                              effects: const [FlipEffect(curve: Curves.easeInOut)],
                              child: TaskCard(
                                taskData: _taskController.taskModel.taskData![index],
                                onEdit: () {
                                  editTaskModalBottomSheet(index);
                                },
                                onDelete: () {
                                  _isTaskDeleted = false;
                                  deleteTaskShowDialog(context, index);
                                },
                                chipColor: widget.tasksScreenInfo.chipColor,
                              ),
                            );
                          }),
                    ),
                  );
                }
              )
            ],
          ),
        ),
      )
    );
  }

  void editTaskModalBottomSheet(int index) {
    TextEditingController titleTEController = TextEditingController();
    TextEditingController descriptionTEController = TextEditingController();

    titleTEController.text = _taskController.taskModel.taskData?[index].title ?? "";
    descriptionTEController.text = _taskController.taskModel.taskData?[index].description ?? "";
    String taskStatus = _taskController.taskModel.taskData?[index].status ?? 'New';

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.0)
            )),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState){
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 18,
                    right: 18,
                    left: 18,
                    top: 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: AnimateList(
                    interval: 50.ms,
                    effects: const [ScaleEffect(curve: Curves.easeInOut)],
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
                                onPressed: () => Get.back(),
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
                              title: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(TaskStatus.newTask,
                                  style: Theme.of(context).primaryTextTheme.labelMedium,
                                ),
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
                              title: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(TaskStatus.progressTask,
                                  style: Theme.of(context).primaryTextTheme.labelMedium,
                                ),
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
                              title: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(TaskStatus.canceledTask,
                                  style: Theme.of(context).primaryTextTheme.labelMedium,
                                ),
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
                              title: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(TaskStatus.completedTask,
                                  style: Theme.of(context).primaryTextTheme.labelMedium,
                                ),
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
                      ElevatedButton(
                        onPressed: (){
                          //TODO: edit task api

                          if (_taskController.taskModel.taskData![index].status != taskStatus) {
                            updateTaskStatus(_taskController.taskModel.taskData![index].sId!, taskStatus);
                          } else {
                            Get.back();
                          }
                        },
                        child: const Text('Update Task'),
                      ),
                    ],)
                  ),
                ),
              ),
            );
          });
        });
  }

  Future<void> updateTaskStatus(String id, String status) async {
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.taskStatusUpdateUrl(id, status));
    final Map<String, Color> colorsMap = {
      TaskStatus.newTask: newTaskColor,
      TaskStatus.progressTask: progressTaskColor,
      TaskStatus.canceledTask: canceledTaskColor,
      TaskStatus.completedTask: completedTaskColor,
    };

    final Color snackBarColor = colorsMap[status] ?? mainColor;

    if(response.isSuccess && mounted) {
      Get.back();

      setState(() {
        _taskController.taskModel.taskData!.removeWhere((element) => element.sId == id);

        switch(widget.tasksScreenInfo.taskStatus) {
          case TaskStatus.newTask:
            _taskSummaryController.newTaskCount -= 1;
            break;
          case TaskStatus.progressTask:
            _taskSummaryController.progressTaskCount -= 1;
            break;
          case TaskStatus.canceledTask:
            _taskSummaryController.canceledTaskCount -= 1;
            break;
          case TaskStatus.completedTask:
            _taskSummaryController.completedTaskCount -= 1;
            break;
        }

        switch(status) {
          case TaskStatus.newTask:
            _taskSummaryController.newTaskCount += 1;
            break;
          case TaskStatus.progressTask:
            _taskSummaryController.progressTaskCount += 1;
            break;
          case TaskStatus.canceledTask:
            _taskSummaryController.canceledTaskCount += 1;
            break;
          case TaskStatus.completedTask:
            _taskSummaryController.completedTaskCount += 1;
            break;
        }
      });

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
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.deleteTaskUrl(id));

    if(response.isSuccess && mounted) {
      Get.back();
      setState(() {
        _taskController.taskModel.taskData!.removeWhere((element) => element.sId == id);

        switch(widget.tasksScreenInfo.taskStatus) {
          case TaskStatus.newTask:
            _taskSummaryController.newTaskCount -= 1;
            break;
          case TaskStatus.progressTask:
            _taskSummaryController.progressTaskCount -= 1;
            break;
          case TaskStatus.canceledTask:
            _taskSummaryController.canceledTaskCount -= 1;
            break;
          case TaskStatus.completedTask:
            _taskSummaryController.completedTaskCount -= 1;
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
                  deleteTask(_taskController.taskModel.taskData?[index].sId ?? '');
                  setState(() {
                    _isTaskDeleted = true;
                  });
                },
                title: 'Delete Task',
                content: 'Deleting task "${_taskController.taskModel.taskData?[index].title ?? 'Null'}"',
                actionText: 'Confirm'
            ),
          );
        }
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
