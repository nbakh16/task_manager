import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../data/models/network_response.dart';
import '../../../data/models/task_model.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utils/colors.dart';
import '../../../data/utils/urls.dart';
import '../../widgets/custom_alert_dialog.dart';
import '../../widgets/no_task_available_widget.dart';
import '../../widgets/tasks_listview_builder.dart';

class CanceledTasksScreen extends StatefulWidget {
  const CanceledTasksScreen({super.key});

  @override
  State<CanceledTasksScreen> createState() => _CanceledTasksScreenState();
}

class _CanceledTasksScreenState extends State<CanceledTasksScreen> {
  bool _isLoading = false;
  List<Task> canceledTasksList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCanceledTasksList();
    });
  }

  Future<void> getCanceledTasksList() async {
    _isLoading = true;
    if(mounted) {
      setState(() {});
    }

    canceledTasksList.clear();
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.cancelledTasksListUrl);

    if(response.isSuccess && mounted) {
      Map<String, dynamic> decodedResponse = jsonDecode(jsonEncode(response.body));
      for(var e in decodedResponse['data']) {
        canceledTasksList.add(
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
            getCanceledTasksList();
          },
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
            child: Visibility(
              visible: _isLoading == false,
              replacement: const Center(child: CircularProgressIndicator(),),
              child: Visibility(
                  visible: canceledTasksList.isNotEmpty,
                  replacement: const Center(child: NoTaskAvailable()),
                  child: TasksListViewBuilder(
                    tasksList: canceledTasksList,
                    chipColor: canceledTaskColor,
                    onEdit: (index){
                      print(index);
                    },
                    onDelete: (index) async {
                      showDialog(barrierDismissible: false,
                          context: context, builder: (_) => CustomAlertDialog(
                              onPress: () => deleteTask(canceledTasksList[index].sId ?? ''),
                              title: 'Delete Task',
                              content: 'Deleting task "${canceledTasksList[index].title}"',
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
      getCanceledTasksList();
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Task delete failed!'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
