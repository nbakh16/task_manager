import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/colors.dart';

import '../../../data/models/task_model.dart';
import '../../../data/utils/task_status.dart';
import '../../../data/utils/urls.dart';
import '../../widgets/custom_aler_dialog.dart';
import '../../widgets/no_task_available_widget.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/tasks_listview_builder.dart';

class NewTasksScreen extends StatefulWidget {
  const NewTasksScreen({super.key});

  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  bool _isLoading = false;
  List<Task> newTasksList = [];

  int newTaskCount=0, progressTaskCount=0, completedTaskCount=0, canceledTaskCount=0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTaskStatusCount();
      getNewTasksList();
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
          case TaskStatus.cancelledTask:
            canceledTaskCount = task.sum ?? 0;
            break;
        }
      }
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Tasks status count failed!'),
        backgroundColor: Colors.red,
      ));
    }
    _isLoading = false;
    if(mounted) {
      setState(() {});
    }

  }

  Future<void> getNewTasksList() async {
    _isLoading = true;
    if(mounted) {
      setState(() {});
    }

    newTasksList.clear();
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.newTasksListUrl);

    if(response.isSuccess && mounted) {
      Map<String, dynamic> decodedResponse = jsonDecode(jsonEncode(response.body));
      for(var e in decodedResponse['data']) {
        newTasksList.add(
            Task.fromJson(e)
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Tasks list failed!'),
        backgroundColor: Colors.red,
      ));
    }

    _isLoading = false;
    if(mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor.shade50,
      body: RefreshIndicator(
        onRefresh: () async {
          getTaskStatusCount();
          getNewTasksList();
        },
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
          child: Visibility(
            visible: _isLoading == false,
            replacement: const Center(child: CircularProgressIndicator(),),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                summaryRow(),
                Visibility(
                  visible: newTasksList.isNotEmpty,
                  replacement: const NoTaskAvailable(),
                  child: Expanded(
                    child: TasksListViewBuilder(
                      tasksList: newTasksList,
                      chipColor: newTaskColor,
                      onEdit: (index){
                        print(index);
                      },
                      onDelete: (index) async {
                        showDialog(barrierDismissible: false,
                            context: context, builder: (_) => CustomAlertDialog(
                                onPress: () => deleteTask(newTasksList[index].sId ?? ''),
                                title: 'Delete Task',
                                content: 'Deleting task "${newTasksList[index].title}"',
                                actionText: 'Confirm'
                            ));
                      },
                    ),
                  )
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
        ),
        SummaryCard(
          taskCount: progressTaskCount,
          taskType: 'Progress',
        ),
        SummaryCard(
          taskCount: canceledTaskCount,
          taskType: 'Canceled',
        ),
        SummaryCard(
          taskCount: completedTaskCount,
          taskType: 'Completed',
        ),
      ],
    );
  }

  Future<void> deleteTask(String id) async {
    final NetworkResponse response = await NetworkCaller().getRequest('${Urls.deleteTaskUrl}$id');

    if(response.isSuccess && mounted) {
      Navigator.pop(context);
      getNewTasksList();
      getTaskStatusCount();
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task delete failed!'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
