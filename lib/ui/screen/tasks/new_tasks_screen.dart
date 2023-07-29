import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/assets_utils.dart';
import 'package:task_manager/ui/utils/colors.dart';

import '../../widgets/summary_card.dart';
import '../../widgets/task_card.dart';

class NewTasksScreen extends StatefulWidget {
  const NewTasksScreen({super.key});

  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor.shade50,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full Name'),
            Text('email@abc.com',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal
              ),
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: CircleAvatar(
            child: Image.asset(AssetsUtils.forwardPNG),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            summaryRow(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      return TaskCard();
                    }),
                ),
              ),
            )
          ],
        ),
      )
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
