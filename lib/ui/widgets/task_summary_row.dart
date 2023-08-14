import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:task_manager/ui/widgets/summary_card.dart';

import '../../data/utils/colors.dart';

class TaskSummaryRow extends StatelessWidget {
  const TaskSummaryRow(
      {super.key,
      required this.newTaskCount,
      required this.progressTaskCount,
      required this.canceledTaskCount,
      required this.completedTaskCount});

  final int newTaskCount,
      progressTaskCount,
      canceledTaskCount,
      completedTaskCount;

  @override
  Widget build(BuildContext context) {
    return Row(children: AnimateList(
      interval: 100.ms,
      effects: [SlideEffect(duration: 200.ms, curve: Curves.easeInOut)],
      children: [
        Expanded(
          child: SummaryCard(
            taskCount: newTaskCount,
            taskType: 'New Task',
            textColor: newTaskColor,
          ),
        ),
        Expanded(
          child: SummaryCard(
            taskCount: progressTaskCount,
            taskType: 'Progress',
            textColor: progressTaskColor,
          ),
        ),
        Expanded(
          child: SummaryCard(
            taskCount: canceledTaskCount,
            taskType: 'Canceled',
            textColor: canceledTaskColor,
          ),
        ),
        Expanded(
          child: SummaryCard(
            taskCount: completedTaskCount,
            taskType: 'Completed',
            textColor: completedTaskColor,
          ),
        ),
      ],)
    );
  }
}
