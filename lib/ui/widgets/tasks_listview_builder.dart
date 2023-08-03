import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

import '../../data/models/task_model.dart';

class TasksListViewBuilder extends StatelessWidget {
  const TasksListViewBuilder({
    super.key,
    required this.tasksList,
    required this.onEdit,
    required this.onDelete,
    this.chipColor,
  });

  final List<Task> tasksList;
  final Function(int index) onEdit, onDelete;
  final Color? chipColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: tasksList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  title: tasksList[index].title ?? '',
                  description: tasksList[index].description ?? '',
                  date: tasksList[index].createdDate ?? '',
                  status: tasksList[index].status ?? '',
                  onEdit: () => onEdit(index),
                  onDelete: ()=> onDelete(index),
                  chipColor: chipColor,
                );
              }),
        ),
      ),
    );
  }
}