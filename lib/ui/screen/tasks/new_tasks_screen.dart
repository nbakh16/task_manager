import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/ui/utils/colors.dart';

import '../../../data/models/task_model.dart';
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

  @override
  void initState() {
    super.initState();
    getNewTasksList();
  }

  Future<void> getNewTasksList() async {
    _isLoading = true;
    if(mounted) {
      setState(() {});
    }

    newTasksList.clear();
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.newTasksListUrl);

    _isLoading = false;
    if(mounted) {
      setState(() {});
    }

    if(response.isSuccess) {
      Map<String, dynamic> decodedResponse = jsonDecode(jsonEncode(response.body));
      for(var e in decodedResponse['data']) {
        newTasksList.add(
            Task.fromJson(e)
        );
      }
    }
    print(newTasksList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor.shade50,
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            summaryRow(),
            Visibility(
              visible: _isLoading == false,
              replacement: const Center(child: CircularProgressIndicator()),
              child: Visibility(
                visible: newTasksList.isNotEmpty,
                replacement: noTaskAvailable(context),
                child: tasksListViewBuilder()
              ),
            )
          ],
        ),
      )
    );
  }

  Column noTaskAvailable(BuildContext context) {
    return Column(
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
    return const Row(
      children: [
        SummaryCard(
          taskCount: 16,
          taskType: 'New Task',
        ),
        SummaryCard(
          taskCount: 16,
          taskType: 'Progress',
        ),
        SummaryCard(
          taskCount: 16,
          taskType: 'Canceled',
        ),
        SummaryCard(
          taskCount: 16,
          taskType: 'Completed',
        ),
      ],
    );
  }
}
