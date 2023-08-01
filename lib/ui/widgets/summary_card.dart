import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.taskCount,
    required this.taskType,
    super.key,
  });

  final int taskCount;
  final String taskType;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(taskCount.toString(),
                style: Theme.of(context).primaryTextTheme.titleLarge?.copyWith(
                  fontSize: 20
                )
              ),
              Text(taskType,
                style: Theme.of(context).primaryTextTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}