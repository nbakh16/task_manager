import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../data/models/network_response.dart';
import '../../../data/models/task_model.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utils/colors.dart';
import '../../../data/utils/urls.dart';
import '../../widgets/custom_aler_dialog.dart';
import '../../widgets/no_task_available_widget.dart';
import '../../widgets/tasks_listview_builder.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  bool _isLoading = false;
  List<Task> completedTasksList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCompletedTasksList();
    });
  }

  Future<void> getCompletedTasksList() async {
    _isLoading = true;
    if(mounted) {
      setState(() {});
    }

    completedTasksList.clear();
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.completedTasksListUrl);

    if(response.isSuccess && mounted) {
      Map<String, dynamic> decodedResponse = jsonDecode(jsonEncode(response.body));
      for(var e in decodedResponse['data']) {
        completedTasksList.add(
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
            getCompletedTasksList();
          },
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
            child: Visibility(
              visible: _isLoading == false,
              replacement: const Center(child: CircularProgressIndicator(),),
              child: Visibility(
                  visible: completedTasksList.isNotEmpty,
                  replacement: const Center(child: NoTaskAvailable()),
                  child: TasksListViewBuilder(
                    tasksList: completedTasksList,
                    chipColor: completedTaskColor,
                    onEdit: (index){
                      print(index);
                    },
                    onDelete: (index) async {
                      showDialog(barrierDismissible: false,
                          context: context, builder: (_) => CustomAlertDialog(
                              onPress: () => deleteTask(completedTasksList[index].sId ?? ''),
                              title: 'Delete Task',
                              content: 'Deleting task "${completedTasksList[index].title}"',
                              actionText: 'Confirm'
                          ));
                    },
                  )
              ),
            ),
          ),
        )
    );
  }

  Future<void> deleteTask(String id) async {
    final NetworkResponse response = await NetworkCaller().getRequest('${Urls.deleteTaskUrl}$id');

    if(response.isSuccess && mounted) {
      Navigator.pop(context);
      getCompletedTasksList();
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task delete failed!'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
