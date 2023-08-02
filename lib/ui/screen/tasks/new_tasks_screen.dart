import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/ui/utils/colors.dart';

import '../../../data/models/task_model.dart';
import '../../../data/utils/task_status.dart';
import '../../../data/utils/urls.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/task_card.dart';

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
      body: Padding(
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
                replacement: noTaskAvailable(context),
                child: tasksListViewBuilder()
              )
            ],
          ),
        ),
      )
    );
  }

  Padding noTaskAvailable(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 56.0),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            size: MediaQuery.sizeOf(context).width * 0.25,
            color: mainColor.shade300,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text('Not New Task'),
          )
        ],
      ),
    );
  }

  Expanded tasksListViewBuilder() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 14.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: newTasksList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  title: newTasksList[index].title ?? '',
                  description: newTasksList[index].description ?? '',
                  date: newTasksList[index].createdDate ?? '',
                  status: newTasksList[index].status ?? '',
                );
              }),
          ),
        ),
      ),
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
}
